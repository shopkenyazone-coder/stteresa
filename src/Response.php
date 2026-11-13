<?php

declare(strict_types=1);

namespace STA;

/**
 * JSON and header helpers. Every API response goes through here so
 * headers and encoding are always consistent.
 */
final class Response
{
    /** @param array<string, mixed> $payload */
    public static function json(array $payload, int $status = 200): never
    {
        http_response_code($status);
        header('Content-Type: application/json; charset=utf-8');
        header('X-Content-Type-Options: nosniff');
        header('Cache-Control: no-store, private');
        echo json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
        exit;
    }

    public static function securityHeaders(): void
    {
        if (PHP_SAPI === 'cli' || headers_sent()) {
            return;
        }

        header('X-Content-Type-Options: nosniff');
        header('Referrer-Policy: strict-origin-when-cross-origin');
        header('X-Frame-Options: SAMEORIGIN');
    }

    public static function redirect(string $location, int $status = 302): never
    {
        if (!headers_sent()) {
            header('Location: ' . $location, true, $status);
        }
        exit;
    }
}
