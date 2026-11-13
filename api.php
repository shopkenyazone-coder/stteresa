<?php
/**
 * Site content store (secured).
 *
 * GET  -> returns saved site content as JSON.
 *         Visitors only receive public content. Signed-in staff receive
 *         the working dataset with all password/session secrets removed.
 * POST -> replaces the saved site content. Requires a signed-in user and
 *         a valid CSRF token.
 *
 * Password hashes, recovery answers and session tokens are never written
 * back to this store; MySQL is the authority for accounts.
 *
 * PHP 8.1+
 */

declare(strict_types=1);

require __DIR__ . '/src/bootstrap.php';

use STA\Auth;
use STA\Csrf;
use STA\Response;
use STA\Store;

ini_set('display_errors', '0');
header('X-Content-Type-Options: nosniff');
header('Cache-Control: no-store, private');

const PUBLIC_CONTENT_KEYS = [
    'settings',
    'logo',
    'logoImage',
    'slider',
    'leadership',
    'announcements',
    'aboutImage',
    'campusImage',
    'progEarly',
    'progElem',
    'progMiddle',
    'ctaImage',
    'favicon',
];

const USER_SECRET_FIELDS = [
    'password',
    'passwordHash',
    'legacyPasswordHash',
    'recoveryAnswerHash',
    'sessionToken',
    'csrfToken',
    'tempPasswordExpiresAt',
];

$dataDir = __DIR__ . DIRECTORY_SEPARATOR . 'data';
$dataFile = $dataDir . DIRECTORY_SEPARATOR . 'site-data.json';
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

/**
 * Remove anything that must never reach a browser.
 *
 * @param array<string, mixed> $data
 * @return array<string, mixed>
 */
function strip_user_secrets(array $data): array
{
    if (!isset($data['users']) || !is_array($data['users'])) {
        return $data;
    }

    $clean = [];

    foreach ($data['users'] as $user) {
        if (!is_array($user)) {
            $clean[] = $user;
            continue;
        }

        foreach (USER_SECRET_FIELDS as $field) {
            unset($user[$field]);
        }

        $clean[] = $user;
    }

    $data['users'] = $clean;

    return $data;
}

/**
 * @param array<string, mixed> $data
 * @return array<string, mixed>
 */
function public_content(array $data): array
{
    $out = [];

    foreach (PUBLIC_CONTENT_KEYS as $key) {
        if (array_key_exists($key, $data)) {
            $out[$key] = $data[$key];
        }
    }

    return $out;
}

function read_store(string $file): ?array
{
    if (!is_file($file)) {
        return null;
    }

    $raw = @file_get_contents($file);

    if ($raw === false) {
        return null;
    }

    $decoded = json_decode($raw, true);

    return is_array($decoded) ? $decoded : null;
}

$authenticatedUser = Auth::currentUser();

if ($method === 'GET') {
    $data = read_store($dataFile);

    if ($data === null) {
        $data = [];
    }

    /* Domains that have been moved to MySQL are served from the
       database. Domains still to be migrated keep coming from the
       JSON mirror, so nothing can disappear mid-migration. */
    foreach (Store::readMigrated() as $key => $value) {
        $data[$key] = $value;
    }

    $data = strip_user_secrets($data);

    if ($authenticatedUser === null) {
        $data = public_content($data);
    }

    Response::json(['ok' => true, 'data' => $data === [] ? null : $data]);
}

if ($method === 'POST') {
    if ($authenticatedUser === null) {
        Response::json(['ok' => false, 'error' => 'Please sign in to save changes.'], 401);
    }

    $postUser = Auth::requireUser([], true);

    Csrf::requireValid(sta_json_header_token());

    $contentType = $_SERVER['CONTENT_TYPE'] ?? '';

    if (!str_contains(strtolower($contentType), 'application/json')) {
        Response::json(['ok' => false, 'error' => 'Content must be sent as JSON.'], 415);
    }

    $raw = file_get_contents('php://input');

    if ($raw === false || $raw === '') {
        Response::json(['ok' => false, 'error' => 'No content was sent.'], 400);
    }

    if (strlen($raw) > 20 * 1024 * 1024) {
        Response::json(['ok' => false, 'error' => 'The content is too large to save.'], 413);
    }

    $decoded = json_decode($raw, true);

    if (!is_array($decoded)) {
        Response::json(['ok' => false, 'error' => 'The content is not valid JSON.'], 400);
    }

    $decoded = strip_user_secrets($decoded);

    /* The migrated domains are written to MySQL first, because the
       database is their source of truth. The JSON file below stays as
       a full mirror of everything the browser sent, so the original
       data is always recoverable. */
    $migratedWrite = [];

    foreach (Store::domains() as $key => $spec) {
        if (!Store::isMigrated($key) || !array_key_exists($key, $decoded)) {
            continue;
        }

        $records = $decoded[$key];

        if (!is_array($records)) {
            continue;
        }

        /* The browser holds the live copy of the domain, so a save
           replaces it (records that disappeared are marked removed,
           never destroyed). */
        $result = Store::write($key, $records, true);
        $migratedWrite[$key] = $result['written'];
    }

    if (!is_dir($dataDir) && !mkdir($dataDir, 0755, true) && !is_dir($dataDir)) {
        Response::json(['ok' => false, 'error' => 'The data folder could not be created.'], 500);
    }

    if (!is_writable($dataDir)) {
        Response::json(['ok' => false, 'error' => 'The data folder is not writable.'], 500);
    }

    $encoded = json_encode($decoded, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

    if ($encoded === false) {
        Response::json(['ok' => false, 'error' => 'Could not encode the content.'], 500);
    }

    $tmp = tempnam($dataDir, 'site-');

    if ($tmp === false) {
        Response::json(['ok' => false, 'error' => 'Could not prepare the save file.'], 500);
    }

    if (file_put_contents($tmp, $encoded, LOCK_EX) === false) {
        @unlink($tmp);
        Response::json(['ok' => false, 'error' => 'Could not write the content.'], 500);
    }

    @chmod($tmp, 0644);

    if (!@rename($tmp, $dataFile)) {
        @unlink($tmp);
        Response::json(['ok' => false, 'error' => 'Could not store the content.'], 500);
    }

    Auth::audit('content.save', 'Site content saved (' . strlen($encoded) . ' bytes)', (int) $postUser['id']);

    Response::json([
        'ok'       => true,
        'saved'    => true,
        'bytes'    => strlen($encoded),
        'migrated' => $migratedWrite,
    ]);
}

Response::json(['ok' => false, 'error' => 'Method not allowed. Use GET or POST.'], 405);
