<?php

declare(strict_types=1);

namespace STA;

use RuntimeException;

/**
 * Photo handling for the Stage 4A import.
 *
 * A browser backup carries its photographs twice:
 *   * in "__images", as base64 data URLs keyed by the image key
 *     (for example "stu_photo_stu_001" or "logoImage"), and
 *   * inline in the records themselves, for older records that still
 *     hold a data URL in their photo field.
 *
 * This class reads both, checks that each file really is an image and
 * writes it into assets/ under a fresh, safe name. The file is then
 * registered in the media table with its original key, so the picture
 * can always be traced back to the record it came from.
 */
final class Photos
{
    /**
     * Decode a data URL into its mime type and raw bytes.
     *
     * @return array{mime: string, bytes: string}|null
     */
    public static function decode(string $value): ?array
    {
        $value = trim((string) $value);

        if ($value === '' || !preg_match('#^data:([^;,]+)?(;base64)?,#i', $value, $match)) {
            return null;
        }

        $mime = strtolower(trim($match[1] ?? 'image/jpeg'));
        $isBase64 = isset($match[2]) && $match[2] !== '';
        $body = substr($value, strlen($match[0]));

        if ($isBase64) {
            $bytes = base64_decode($body, true);
        } else {
            $bytes = rawurldecode($body);
        }

        if ($bytes === false || $bytes === '') {
            return null;
        }

        return ['mime' => $mime, 'bytes' => $bytes];
    }

    /**
     * Check that the bytes really are one of the allowed images.
     *
     * @return array{ok: bool, mime?: string, reason?: string}
     */
    public static function verify(string $bytes, string $claimedMime): array
    {
        $allowed = (array) Config::get('uploads.mime_types', []);
        $maxBytes = (int) Config::get('uploads.max_bytes', 8 * 1024 * 1024);

        if (strlen($bytes) > $maxBytes) {
            return ['ok' => false, 'reason' => 'larger than ' . $maxBytes . ' bytes'];
        }

        $detected = '';

        if (class_exists('finfo')) {
            $finfo = new \finfo(FILEINFO_MIME_TYPE);
            $found = $finfo->buffer($bytes);
            $detected = is_string($found) ? $found : '';
        }

        if ($detected === '' || !isset($allowed[$detected])) {
            return ['ok' => false, 'reason' => 'not an allowed image type (' . ($detected !== '' ? $detected : 'unknown') . ')'];
        }

        if ($claimedMime !== '' && $claimedMime !== $detected && !str_starts_with($claimedMime, 'image/')) {
            return ['ok' => false, 'reason' => 'the file type does not match the data'];
        }

        return ['ok' => true, 'mime' => $detected];
    }

    /**
     * Write an image into the assets folder and register it.
     *
     * @return array{ok: bool, path?: string, reason?: string}
     */
    public static function save(string $bytes, string $mime, string $legacyKey, ?int $userId = null): array
    {
        $check = self::verify($bytes, $mime);

        if (!$check['ok']) {
            return ['ok' => false, 'reason' => $check['reason'] ?? 'not an allowed image'];
        }

        $mime = (string) $check['mime'];
        $allowed = (array) Config::get('uploads.mime_types', []);
        $extension = (string) ($allowed[$mime] ?? 'jpg');
        $dir = rtrim((string) Config::get('uploads.dir', ''), DIRECTORY_SEPARATOR);

        if ($dir === '' || !is_dir($dir)) {
            return ['ok' => false, 'reason' => 'the assets folder is missing'];
        }

        if (!is_writable($dir)) {
            return ['ok' => false, 'reason' => 'the assets folder is not writable'];
        }

        $safeKey = preg_replace('/[^A-Za-z0-9_-]+/', '-', $legacyKey) ?? 'image';
        $filename = 'img_' . date('Ymd_His') . '_' . substr(bin2hex(random_bytes(8)), 0, 16) . '_' . substr($safeKey, 0, 40) . '.' . $extension;
        $destination = $dir . DIRECTORY_SEPARATOR . $filename;

        if (file_put_contents($destination, $bytes, LOCK_EX) === false) {
            return ['ok' => false, 'reason' => 'the file could not be written'];
        }

        @chmod($destination, 0644);

        $path = 'assets/' . $filename;

        try {
            Database::execute(
                'INSERT INTO media (filename, path, mime, size, kind, legacy_key, uploaded_by, is_demo)
                 VALUES (?, ?, ?, ?, ?, ?, ?, 0)',
                [$filename, $path, $mime, strlen($bytes), 'image', $legacyKey, $userId]
            );
        } catch (\Throwable $e) {
            error_log('Could not register imported media: ' . $e->getMessage());
        }

        return ['ok' => true, 'path' => $path];
    }

    /**
     * Collect every image in an export.
     *
     * @param array<string, mixed> $export
     * @param array<int, string>   $domains
     * @return array{images: array<string, string>, inline: array<string, string>}
     */
    public static function collect(array $export, array $domains): array
    {
        $images = [];
        $inline = [];

        $exportImages = $export['__images'] ?? [];

        if (is_array($exportImages)) {
            foreach ($exportImages as $key => $value) {
                if (is_string($value) && $value !== '') {
                    $images[(string) $key] = $value;
                }
            }
        }

        /* Older records still carry their picture inside the record. */
        foreach ($domains as $domain) {
            $records = $export[$domain] ?? null;

            if (!is_array($records)) {
                continue;
            }

            foreach ($records as $record) {
                if (!is_array($record)) {
                    continue;
                }

                $id = (string) ($record['id'] ?? '');

                foreach (['photo', 'imageUrl', 'image'] as $field) {
                    $value = $record[$field] ?? null;

                    if (is_string($value) && str_starts_with($value, 'data:image/')) {
                        $inline[$domain . ':' . $id . ':' . $field] = $value;
                    }
                }
            }
        }

        return ['images' => $images, 'inline' => $inline];
    }

    /**
     * Point a record at the imported picture.
     *
     * The original key is kept, so a browser that still has the picture
     * in its own storage keeps showing it; anything else falls back to
     * the file on the server.
     *
     * @param array<string, mixed> $record
     * @param array<string, string> $map
     * @return array{record: array<string, mixed>, linked: int}
     */
    public static function link(array $record, array $map): array
    {
        $linked = 0;

        foreach (['photoKey', 'imageKey'] as $keyField) {
            $key = (string) ($record[$keyField] ?? '');

            if ($key === '' || !isset($map[$key])) {
                continue;
            }

            $path = $map[$key];

            if ($keyField === 'photoKey') {
                $record['photo'] = $path;
            } else {
                $record['imageUrl'] = $path;
            }

            $linked++;
        }

        return ['record' => $record, 'linked' => $linked];
    }

    /** @throws RuntimeException */
    public static function assertAssetsFolder(): void
    {
        $dir = rtrim((string) Config::get('uploads.dir', ''), DIRECTORY_SEPARATOR);

        if ($dir === '' || !is_dir($dir)) {
            throw new RuntimeException('The assets folder is missing.');
        }
    }
}
