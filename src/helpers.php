<?php

declare(strict_types=1);

/**
 * Small global helpers shared by pages and API endpoints.
 */

if (!function_exists('sta_e')) {
    /** Escape any value for safe HTML output (XSS protection). */
    function sta_e(mixed $value): string
    {
        return htmlspecialchars((string) $value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
    }
}

if (!function_exists('sta_is_post')) {
    function sta_is_post(): bool
    {
        return ($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST';
    }
}

if (!function_exists('sta_post_string')) {
    function sta_post_string(string $key, string $default = ''): string
    {
        $value = $_POST[$key] ?? $default;
        return is_string($value) ? trim($value) : $default;
    }
}

if (!function_exists('sta_get_string')) {
    function sta_get_string(string $key, string $default = ''): string
    {
        $value = $_GET[$key] ?? $default;
        return is_string($value) ? trim($value) : $default;
    }
}

if (!function_exists('sta_json_body')) {
    /** @return array<string, mixed> */
    function sta_json_body(): array
    {
        $raw = file_get_contents('php://input');

        if ($raw === false || $raw === '') {
            return [];
        }

        $decoded = json_decode($raw, true);
        return is_array($decoded) ? $decoded : [];
    }
}

if (!function_exists('sta_json_header_token')) {
    /** Read the CSRF token from the X-CSRF-Token header. */
    function sta_json_header_token(): string
    {
        $token = $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
        return is_string($token) ? $token : '';
    }
}

if (!function_exists('sta_url')) {
    function sta_url(string $path = ''): string
    {
        $base = rtrim((string) \STA\Config::get('app.url', ''), '/');
        return $base . '/' . ltrim($path, '/');
    }
}

if (!function_exists('sta_redirect')) {
    function sta_redirect(string $location, int $status = 302): never
    {
        \STA\Response::redirect($location, $status);
    }
}
