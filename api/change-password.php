<?php
/**
 * Change your OWN password (any signed-in staff member).
 *
 * POST JSON: { "currentPassword": "…", "newPassword": "…" }
 * Requires a valid X-CSRF-Token. MySQL is the authority — the browser's
 * local copy of credentials is ignored here.
 *
 * Note: accounts flagged must_change_password are funnelled to
 * admin/password.php by requireUser() and cannot use this endpoint.
 *
 * PHP 8.1+
 */

declare(strict_types=1);

require __DIR__ . '/../src/bootstrap.php';

use STA\Auth;
use STA\Csrf;
use STA\Response;

ini_set('display_errors', '0');
header('X-Content-Type-Options: nosniff');
header('Cache-Control: no-store, private');

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
    Response::json(['ok' => false, 'error' => 'Method not allowed.'], 405);
}

$user = Auth::requireUser([], true);

Csrf::requireValid(sta_json_header_token());

$body = sta_json_body();
$currentPassword = isset($body['currentPassword']) && is_string($body['currentPassword']) ? $body['currentPassword'] : '';
$newPassword = isset($body['newPassword']) && is_string($body['newPassword']) ? $body['newPassword'] : '';

$result = Auth::changePassword((int) $user['id'], $currentPassword, $newPassword);

Response::json($result, !empty($result['ok']) ? 200 : 400);
