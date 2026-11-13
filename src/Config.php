<?php

declare(strict_types=1);

namespace STA;

/**
 * Read-only configuration store.
 *
 * config/config.php is the only place where database credentials live.
 * Environment variables can override it on the production host.
 */
final class Config
{
    /** @var array<string, mixed> */
    private static array $items = [];

    private static bool $loaded = false;

    public static function load(string $path): void
    {
        if (!is_file($path)) {
            throw new \RuntimeException('Configuration file not found: ' . $path);
        }

        $config = require $path;

        if (!is_array($config)) {
            throw new \RuntimeException('Configuration file must return an array.');
        }

        self::$items = $config;
        self::$loaded = true;
    }

    public static function get(string $key, mixed $default = null): mixed
    {
        if (!self::$loaded) {
            throw new \RuntimeException('Configuration has not been loaded.');
        }

        $value = self::$items;

        foreach (explode('.', $key) as $part) {
            if (!is_array($value) || !array_key_exists($part, $value)) {
                return $default;
            }
            $value = $value[$part];
        }

        return $value;
    }

    /** @return array<string, mixed> */
    public static function all(): array
    {
        return self::$items;
    }
}
