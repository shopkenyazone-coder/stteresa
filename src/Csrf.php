<?php

declare(strict_types=1);

namespace STA;

/**
 * Per-session CSRF token. Tokens are compared in constant time and
 * are rotated on login and password change.
 */
final class Csrf
{
    public static function token(): string
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            return '';
        }

        if (empty($_SESSION['csrf_token']) || !is_string($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }

        return $_SESSION['csrf_token'];
    }

    public static function validate(?string $token): bool
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            return false;
        }

        $expected = $_SESSION['csrf_token'] ?? '';

        if (!is_string($expected) || $expected === '' || !is_string($token) || $token === '') {
            return false;
        }

        return hash_equals($expected, $token);
    }

    /** For JSON endpoints: stop with 403 when the token is missing or wrong. */
    public static function requireValid(?string $token): void
    {
        if (!self::validate($token)) {
            Response::json(['ok' => false, 'error' => 'Your session has expired. Please refresh the page and try again.'], 403);
        }
    }

    public static function rotate(): string
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            return '';
        }

        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        return $_SESSION['csrf_token'];
    }
}
