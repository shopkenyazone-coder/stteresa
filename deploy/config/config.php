<?php
declare(strict_types=1);

/*
 * Production configuration for stteresakanyangeacademy.co.ke
 * Upload this file to: config/config.php on the cPanel server
 * (overwrite the local XAMPP one there).
 */

require __DIR__ . '/database.php';

$database = require __DIR__ . '/database.php';

return [
    'app' => [
        'name'     => 'St. Teresa Kanyange Academy',
        'env'      => 'production',
        'debug'    => false,
        'url'      => 'https://stteresakanyangeacademy.co.ke',
        'timezone' => 'Africa/Nairobi',
    ],

    'db' => $database,

    'session' => [
        'name'     => 'STASESSID',
        'lifetime' => 7200,
        'samesite' => 'Lax',
    ],

    'security' => [
        'max_login_attempts'      => 5,
        'lockout_minutes'         => 15,
        'password_min_length'     => 8,
        'temp_password_ttl_hours' => 72,
    ],

    'uploads' => [
        'dir'        => dirname(__DIR__) . DIRECTORY_SEPARATOR . 'assets',
        'max_bytes'  => 8 * 1024 * 1024,
        'mime_types' => [
            'image/jpeg' => 'jpg',
            'image/png'  => 'png',
            'image/gif'  => 'gif',
            'image/webp' => 'webp',
        ],
    ],
];
