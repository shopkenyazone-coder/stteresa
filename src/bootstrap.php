<?php

declare(strict_types=1);

/**
 * Shared bootstrap for every PHP page and endpoint.
 *
 * Loads configuration, registers the simple class autoloader,
 * configures error handling and starts a hardened PHP session.
 */

define('STA_ROOT', dirname(__DIR__));

spl_autoload_register(static function (string $class): void {
    $prefix = 'STA\\';

    if (!str_starts_with($class, $prefix)) {
        return;
    }

    $relative = substr($class, strlen($prefix));
    $file = __DIR__ . DIRECTORY_SEPARATOR . str_replace('\\', DIRECTORY_SEPARATOR, $relative) . '.php';

    if (is_file($file)) {
        require $file;
    }
});

require __DIR__ . '/helpers.php';

\STA\Config::load(STA_ROOT . '/config/config.php');

date_default_timezone_set((string) \STA\Config::get('app.timezone', 'Africa/Nairobi'));

$debug = (bool) \STA\Config::get('app.debug', false);

error_reporting(E_ALL);
ini_set('display_errors', $debug ? '1' : '0');
ini_set('log_errors', '1');

$logDir = STA_ROOT . '/storage/logs';
if (!is_dir($logDir)) {
    @mkdir($logDir, 0775, true);
}
ini_set('error_log', $logDir . '/php-error.log');

if (PHP_SAPI !== 'cli' && !headers_sent()) {
    \STA\Response::securityHeaders();
}

if (session_status() === PHP_SESSION_NONE) {
    $secure = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off')
        || (($_SERVER['SERVER_PORT'] ?? '') === '443');

    /* Shared hosting often ships a broken or non-writable default session
       save path, which silently drops every session and makes CSRF tokens
       fail ("Your session has expired"). Use a project-local path when we
       can; fall back to the server default otherwise. */
    $sessionDir = STA_ROOT . '/storage/sessions';
    if (!is_dir($sessionDir)) {
        @mkdir($sessionDir, 0700, true);
    }
    if (is_dir($sessionDir) && is_writable($sessionDir)) {
        $htaccess = $sessionDir . '/.htaccess';
        if (!is_file($htaccess)) {
            @file_put_contents($htaccess, "Require all denied\n");
        }
        session_save_path($sessionDir);
    }

    ini_set('session.use_strict_mode', '1');
    ini_set('session.use_only_cookies', '1');
    ini_set('session.cookie_httponly', '1');
    ini_set('session.gc_maxlifetime', (string) (int) \STA\Config::get('session.lifetime', 7200));

    session_name((string) \STA\Config::get('session.name', 'STASESSID'));

    session_set_cookie_params([
        'lifetime' => 0,
        'path'     => '/',
        'domain'   => '',
        'secure'   => $secure,
        'httponly' => true,
        'samesite' => (string) \STA\Config::get('session.samesite', 'Lax'),
    ]);

    session_start();
}
