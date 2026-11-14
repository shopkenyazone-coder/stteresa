<?php
/**
 * Administrator-assisted password reset (server-side).
 *
 * Issues a NEW temporary password for an account in MySQL — the authority
 * for signing in. The browser's local copy alone can never authenticate,
 * which is why this endpoint exists.
 *
 * POST JSON: { "username": "David", "reason": "optional note" }
 * Auth: signed-in admin/director/headteacher + valid X-CSRF-Token.
 * Response: { ok: true, tempPassword, expiresAt } — shown exactly once.
 *
 * PHP 8.1+
 */

declare(strict_types=1);

require __DIR__ . '/../src/bootstrap.php';

use STA\Auth;
use STA\Config;
use STA\Csrf;
use STA\Database;
use STA\Response;

ini_set('display_errors', '0');
header('X-Content-Type-Options: nosniff');
header('Cache-Control: no-store, private');

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
    Response::json(['ok' => false, 'error' => 'Method not allowed.'], 405);
}

$admin = Auth::requireUser(['admin', 'director', 'headteacher'], true);

Csrf::requireValid(sta_json_header_token());

$contentType = $_SERVER['CONTENT_TYPE'] ?? '';

if (!str_contains(strtolower($contentType), 'application/json')) {
    Response::json(['ok' => false, 'error' => 'Content must be sent as JSON.'], 415);
}

$body = sta_json_body();
$username = trim((string) ($body['username'] ?? ''));
$reason = trim((string) ($body['reason'] ?? ''));

if ($username === '' || mb_strlen($username) > 64) {
    Response::json(['ok' => false, 'error' => 'A valid username is required.'], 422);
}

$user = Database::one(
    'SELECT * FROM users WHERE username = ? OR legacy_id = ? LIMIT 1',
    [$username, $username]
);

if ($user === null) {
    Response::json(['ok' => false, 'error' => 'No account found for that username.'], 404);
}

$temp = Auth::generateTempPassword();
$ttlHours = (int) Config::get('security.temp_password_ttl_hours', 72);
if ($ttlHours < 1) {
    $ttlHours = 72;
}
$expiresAt = date('Y-m-d H:i:s', time() + $ttlHours * 3600);

Database::execute(
    'UPDATE users
        SET password_hash = ?,
            must_change_password = 1,
            temp_password_expires_at = ?,
            failed_login_count = 0,
            locked_until = NULL,
            password_changed_at = NULL
      WHERE id = ?',
    [Auth::hashPassword($temp), $expiresAt, (int) $user['id']]
);

/* Kill every outstanding session for the account, including the one the
   teacher might still hold on another device. */
Database::execute('DELETE FROM sessions WHERE user_id = ?', [(int) $user['id']]);

Auth::audit(
    'auth.password.reset',
    'Temporary password issued for ' . $user['username'] . ' (' . $user['role'] . ') by ' . $admin['username'] . ($reason !== '' ? ' — ' . $reason : ''),
    (int) $admin['id']
);

Response::json([
    'ok'          => true,
    'tempPassword' => $temp,
    'expiresAt'   => date('c', strtotime($expiresAt)),
    'username'    => $user['username'],
]);
