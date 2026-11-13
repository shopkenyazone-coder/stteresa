<?php

declare(strict_types=1);

/**
 * End the server session. Requires POST and a valid CSRF token so a
 * third-party page cannot sign a user out.
 */

require dirname(__DIR__) . '/src/bootstrap.php';

use STA\Auth;
use STA\Csrf;
use STA\Response;

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
    Response::json(['ok' => false, 'error' => 'Method not allowed. Use POST.'], 405);
}

$token = sta_json_header_token();

if ($token === '' && isset($_POST['csrf_token']) && is_string($_POST['csrf_token'])) {
    $token = $_POST['csrf_token'];
}

Csrf::requireValid($token);

Auth::logoutUser();

Response::json(['ok' => true, 'signedOut' => true]);
