<?php

declare(strict_types=1);

/**
 * Current server session (read-only).
 *
 * Used by js/auth-bridge.js so the existing portal JavaScript knows who
 * is signed in without trusting localStorage. Only non-secret fields
 * are returned.
 */

require dirname(__DIR__) . '/src/bootstrap.php';

use STA\Auth;
use STA\Csrf;
use STA\Response;

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'GET') {
    Response::json(['ok' => false, 'error' => 'Method not allowed. Use GET.'], 405);
}

$user = Auth::currentUser();

if ($user === null) {
    Response::json([
        'ok'            => false,
        'authenticated' => false,
    ]);
}

Response::json([
    'ok'            => true,
    'authenticated' => true,
    'csrfToken'     => Csrf::token(),
    'user'          => [
        'id'                 => (int) $user['id'],
        'legacyId'           => $user['legacy_id'],
        'username'           => $user['username'],
        'name'               => $user['name'],
        'role'               => $user['role'],
        'email'              => $user['email'] ?? '',
        'phone'              => $user['phone'] ?? '',
        'subject'            => $user['subject'] ?? '',
        'grade'              => $user['grade'] ?? '',
        'className'          => $user['class_name'] ?? '',
        'photo'              => $user['photo'] ?? '',
        'mustChangePassword' => (bool) $user['must_change_password'],
        'tempPasswordExpired' => Auth::tempPasswordExpired($user),
    ],
]);
