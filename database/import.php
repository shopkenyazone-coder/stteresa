<?php

declare(strict_types=1);

/**
 * Safe, reusable importer for legacy JSON exports and photographs.
 *
 * Accepts the JSON produced by the old static site (either the raw
 * site-data object or the {"ok":true,"data":{...}} wrapper).
 *
 * Nothing is ever deleted. Unknown entities are preserved verbatim in
 * import_staging so they can be migrated to proper tables later. A
 * timestamped copy of the source file is kept in storage/imports/.
 *
 * Usage:
 *   php database/import.php --file="site-data.json" [options]
 *
 * Options:
 *   --file=PATH       JSON export to import (required)
 *   --photos=DIR      folder of photographs to copy into assets/
 *   --overwrite       update existing non-demo accounts (never deletes)
 *   --dry-run         validate and report only; write nothing
 *   --help            show this help
 */

if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit("This script can only be run from the command line.\n");
}

require dirname(__DIR__) . '/src/bootstrap.php';

use STA\Auth;
use STA\Config;
use STA\Database;

$options = getopt('', ['file:', 'photos:', 'overwrite', 'dry-run', 'help']);

if (array_key_exists('help', $options) || empty($options['file'])) {
    echo "Usage: php database/import.php --file=\"site-data.json\" [--photos=\"path/to/assets\"] [--overwrite] [--dry-run]\n";
    exit(array_key_exists('help', $options) ? 0 : 1);
}

$file      = (string) $options['file'];
$photosDir = isset($options['photos']) ? (string) $options['photos'] : null;
$overwrite = array_key_exists('overwrite', $options);
$dryRun    = array_key_exists('dry-run', $options);

function out(string $text): void
{
    echo $text . PHP_EOL;
}

function to_mysql_date(mixed $value): ?string
{
    if (!is_string($value) || trim($value) === '') {
        return null;
    }

    $timestamp = strtotime($value);
    return $timestamp === false ? null : date('Y-m-d H:i:s', $timestamp);
}

/**
 * Validate and store an embedded data-URL photo.
 *
 * @return array{path: string, mime: string, size: int}|null
 */
function save_data_url_photo(string $dataUrl, ?int $userId, bool $dryRun): ?array
{
    if (!preg_match('#^data:(image/[a-z0-9.+-]+);base64,(.+)$#is', $dataUrl, $match)) {
        return null;
    }

    $mime = strtolower($match[1]);
    $allowed = Config::get('uploads.mime_types', []);

    if (!is_array($allowed) || !isset($allowed[$mime])) {
        return null;
    }

    $raw = preg_replace('/\s+/', '', $match[2]) ?? '';
    $bytes = base64_decode($raw, true);

    if ($bytes === false || $bytes === '') {
        return null;
    }

    $max = (int) Config::get('uploads.max_bytes', 8 * 1024 * 1024);

    if (strlen($bytes) <= 0 || strlen($bytes) > $max) {
        return null;
    }

    $info = @getimagesizefromstring($bytes);

    if (!is_array($info) || ($info['mime'] ?? '') !== $mime) {
        return null;
    }

    $hash = hash('sha256', $bytes);
    $legacyKey = 'import-' . $hash;

    $existing = Database::one('SELECT path, mime, size FROM media WHERE legacy_key = ? LIMIT 1', [$legacyKey]);

    if ($existing !== null) {
        return ['path' => (string) $existing['path'], 'mime' => (string) $existing['mime'], 'size' => (int) $existing['size']];
    }

    $extension = is_array($allowed) ? (string) $allowed[$mime] : 'jpg';
    $filename = 'img_import_' . $hash . '.' . $extension;
    $dir = rtrim((string) Config::get('uploads.dir', ''), DIRECTORY_SEPARATOR);
    $destination = $dir . DIRECTORY_SEPARATOR . $filename;
    $relative = 'assets/' . $filename;

    if (!$dryRun) {
        if (!is_dir($dir) && !@mkdir($dir, 0775, true) && !is_dir($dir)) {
            return null;
        }

        if (file_put_contents($destination, $bytes, LOCK_EX) === false) {
            return null;
        }

        @chmod($destination, 0644);

        Database::insert('media', [
            'filename'    => $filename,
            'path'        => $relative,
            'mime'        => $mime,
            'size'        => strlen($bytes),
            'kind'        => 'image',
            'legacy_key'  => $legacyKey,
            'uploaded_by' => $userId,
            'is_demo'     => 0,
        ]);
    }

    return ['path' => $relative, 'mime' => $mime, 'size' => strlen($bytes)];
}

if (!is_file($file) || !is_readable($file)) {
    fwrite(STDERR, "Could not read: {$file}\n");
    exit(1);
}

$raw = file_get_contents($file);

if ($raw === false || $raw === '') {
    fwrite(STDERR, "The file is empty.\n");
    exit(1);
}

$decoded = json_decode($raw, true);

if (!is_array($decoded)) {
    fwrite(STDERR, "The file is not valid JSON.\n");
    exit(1);
}

$data = $decoded;

if (isset($decoded['data']) && is_array($decoded['data'])) {
    $data = $decoded['data'];
}

if ($data === []) {
    fwrite(STDERR, "No data found in the export.\n");
    exit(1);
}

$sourceHash = hash('sha256', $raw);
$sourceName = basename($file);

out($dryRun ? 'DRY RUN - no database or file changes will be made.' : 'Importing legacy data...');
out('Source: ' . $file);
out('SHA-256: ' . $sourceHash);
out('Entities: ' . implode(', ', array_keys($data)));

if (!$dryRun) {
    $importDir = STA_ROOT . '/storage/imports';

    if (!is_dir($importDir) && !@mkdir($importDir, 0775, true) && !is_dir($importDir)) {
        fwrite(STDERR, "Could not create storage/imports.\n");
        exit(1);
    }

    $copy = $importDir . DIRECTORY_SEPARATOR . date('Ymd-His') . '_' . preg_replace('/[^A-Za-z0-9._-]/', '_', $sourceName);

    if (@copy($file, $copy)) {
        out('Source copy saved: ' . $copy);
    } else {
        out('Warning: could not copy the source file. The original is unchanged.');
    }
}

$runId = 0;

if (!$dryRun) {
    $runId = Database::insert('import_runs', [
        'source_file' => $sourceName,
        'source_hash' => $sourceHash,
        'mode'        => 'import',
        'status'      => 'running',
        'notes'       => $overwrite ? 'overwrite flag enabled' : 'non-destructive defaults',
    ]);
}

$counts = [
    'users_inserted'   => 0,
    'users_updated'    => 0,
    'users_skipped'    => 0,
    'messages_inserted' => 0,
    'messages_skipped' => 0,
    'staged_inserted'  => 0,
    'staged_skipped'   => 0,
    'photos_copied'    => 0,
    'photos_skipped'   => 0,
];

try {
    if (!$dryRun) {
        Database::pdo()->beginTransaction();
    }

    /* ---------------- Users ---------------- */
    $users = $data['users'] ?? [];

    if (is_array($users)) {
        foreach ($users as $index => $legacy) {
            if (!is_array($legacy)) {
                continue;
            }

            $username = trim((string) ($legacy['username'] ?? ''));

            if ($username === '') {
                out("  skipped user #{$index}: missing username");
                $counts['users_skipped']++;
                continue;
            }

            $legacyId = isset($legacy['id']) ? (string) $legacy['id'] : null;
            $existing = Database::one('SELECT * FROM users WHERE username = ? LIMIT 1', [$username]);

            if ($existing === null && $legacyId !== null && $legacyId !== '') {
                $existing = Database::one('SELECT * FROM users WHERE legacy_id = ? LIMIT 1', [$legacyId]);
            }

            $email = trim((string) ($legacy['email'] ?? ''));
            $email = $email === '' ? null : substr($email, 0, 190);

            $bcrypt = null;
            $legacyHash = null;
            $mustChange = !empty($legacy['mustChangePassword']) ? 1 : 0;

            $passwordHash = (string) ($legacy['passwordHash'] ?? '');

            if ($passwordHash !== '') {
                if (str_starts_with($passwordHash, 'pbkdf2$')) {
                    $legacyHash = $passwordHash;
                } else {
                    $bcrypt = $passwordHash;
                }
            }

            if ($bcrypt === null && isset($legacy['password']) && is_string($legacy['password']) && $legacy['password'] !== '') {
                $bcrypt = Auth::hashPassword($legacy['password']);
            }

            if ($bcrypt === null && $legacyHash === null) {
                $bcrypt = Auth::hashPassword(bin2hex(random_bytes(16)));
                $mustChange = 1;
            }

            $photo = null;
            $photoValue = $legacy['photo'] ?? null;

            if (is_string($photoValue) && str_starts_with($photoValue, 'data:image/')) {
                $saved = save_data_url_photo($photoValue, $existing ? (int) $existing['id'] : null, $dryRun);
                $photo = $saved['path'] ?? null;
            } elseif (is_string($photoValue) && $photoValue !== '') {
                $photo = substr($photoValue, 0, 255);
            }

            $row = [
                'legacy_id'                   => $legacyId,
                'username'                    => substr($username, 0, 64),
                'email'                       => $email,
                'password_hash'               => $bcrypt,
                'legacy_password_hash'        => $legacyHash,
                'role'                        => substr(strtolower(trim((string) ($legacy['role'] ?? 'student'))), 0, 32) ?: 'student',
                'status'                      => substr(strtolower(trim((string) ($legacy['status'] ?? 'active'))), 0, 16) ?: 'active',
                'name'                        => substr(trim((string) ($legacy['name'] ?? $username)), 0, 190) ?: $username,
                'phone'                       => substr((string) ($legacy['phone'] ?? ''), 0, 40) ?: null,
                'subject'                     => substr((string) ($legacy['subject'] ?? ''), 0, 120) ?: null,
                'grade'                       => substr((string) ($legacy['grade'] ?? ''), 0, 80) ?: null,
                'class_name'                  => substr((string) ($legacy['className'] ?? ''), 0, 120) ?: null,
                'photo'                       => $photo,
                'must_change_password'        => $mustChange,
                'temp_password_expires_at'    => to_mysql_date($legacy['tempPasswordExpiresAt'] ?? null),
                'recovery_question'           => isset($legacy['recoveryQuestion']) ? substr((string) $legacy['recoveryQuestion'], 0, 255) : null,
                'recovery_answer_hash'        => null,
                'legacy_recovery_answer_hash' => isset($legacy['recoveryAnswerHash']) ? substr((string) $legacy['recoveryAnswerHash'], 0, 255) : null,
                'is_demo'                     => 0,
            ];

            if ($existing !== null) {
                if ((int) $existing['is_demo'] === 1 || !$overwrite) {
                    out("  skipped existing user: {$username}");
                    $counts['users_skipped']++;
                    continue;
                }

                if ($dryRun) {
                    out("  would update user: {$username}");
                    $counts['users_updated']++;
                    continue;
                }

                $update = $row;
                unset($update['legacy_id'], $update['is_demo']);

                try {
                    Database::update('users', $update, ['id' => (int) $existing['id']]);
                } catch (PDOException $e) {
                    if ((int) ($e->errorInfo[1] ?? 0) === 1062) {
                        $update['email'] = null;
                        Database::update('users', $update, ['id' => (int) $existing['id']]);
                        out("  updated {$username} (duplicate e-mail cleared)");
                    } else {
                        throw $e;
                    }
                }

                out("  updated existing user: {$username}");
                $counts['users_updated']++;
                continue;
            }

            if ($dryRun) {
                out("  would insert user: {$username} ({$row['role']})");
                $counts['users_inserted']++;
                continue;
            }

            try {
                Database::insert('users', $row);
            } catch (PDOException $e) {
                if ((int) ($e->errorInfo[1] ?? 0) !== 1062) {
                    throw $e;
                }

                $row['email'] = null;

                try {
                    Database::insert('users', $row);
                } catch (PDOException $retry) {
                    if ((int) ($retry->errorInfo[1] ?? 0) === 1062) {
                        out("  skipped conflicting user: {$username}");
                        $counts['users_skipped']++;
                        continue;
                    }
                    throw $retry;
                }

                out("  inserted {$username} (duplicate e-mail cleared)");
                $counts['users_inserted']++;
                continue;
            }

            out("  inserted user: {$username} ({$row['role']})");
            $counts['users_inserted']++;
        }
    }

    /* ---------------- Contact messages ---------------- */
    $messages = $data['contactMessages'] ?? $data['contact_messages'] ?? [];

    if (is_array($messages)) {
        foreach ($messages as $index => $message) {
            if (!is_array($message)) {
                continue;
            }

            $name = trim((string) ($message['name'] ?? ''));
            $email = trim((string) ($message['email'] ?? ''));
            $body = trim((string) ($message['message'] ?? ''));

            if ($name === '' || $email === '' || $body === '') {
                out("  skipped contact message #{$index}: incomplete");
                $counts['messages_skipped']++;
                continue;
            }

            $legacyId = isset($message['id']) ? (string) $message['id'] : 'hash-' . substr(hash('sha256', $name . $email . $body), 0, 24);
            $exists = Database::one('SELECT id FROM contact_messages WHERE legacy_id = ? LIMIT 1', [$legacyId]);

            if ($exists !== null) {
                $counts['messages_skipped']++;
                continue;
            }

            if ($dryRun) {
                out("  would insert contact message: {$legacyId}");
                $counts['messages_inserted']++;
                continue;
            }

            Database::insert('contact_messages', [
                'legacy_id' => substr($legacyId, 0, 120),
                'name'      => substr($name, 0, 190),
                'email'     => substr($email, 0, 190),
                'phone'     => isset($message['phone']) ? substr((string) $message['phone'], 0, 40) : null,
                'interest'  => isset($message['interest']) ? substr((string) $message['interest'], 0, 120) : null,
                'message'   => $body,
                'is_read'   => !empty($message['read']) ? 1 : 0,
                'status'    => !empty($message['read']) ? 'read' : 'new',
                'is_demo'   => 0,
            ]);

            $counts['messages_inserted']++;
        }
    }

    /* ---------------- Everything else -> staging ---------------- */
    foreach ($data as $entity => $value) {
        if (in_array($entity, ['users', 'contactMessages', 'contact_messages', '__images'], true)) {
            continue;
        }

        $rows = is_array($value) && array_is_list($value) ? $value : [$value];

        foreach ($rows as $index => $item) {
            $payload = json_encode($item, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

            if ($payload === false) {
                continue;
            }

            $hash = hash('sha256', $payload);
            $legacyId = is_array($item) && isset($item['id']) ? (string) $item['id'] : $entity . '-' . $index;

            if ($dryRun) {
                $counts['staged_inserted']++;
                continue;
            }

            $inserted = Database::execute(
                'INSERT IGNORE INTO import_staging (source_file, entity, legacy_id, payload_hash, payload, status, created_at)
                 VALUES (?, ?, ?, ?, ?, \'staged\', NOW())',
                [substr($sourceName, 0, 255), substr((string) $entity, 0, 64), substr($legacyId, 0, 120), $hash, $payload]
            );

            if ($inserted > 0) {
                $counts['staged_inserted']++;
            } else {
                $counts['staged_skipped']++;
            }
        }
    }

    if (!$dryRun) {
        Database::pdo()->commit();
    }

    /* ---------------- Photograph folder ---------------- */
    if ($photosDir !== null && is_dir($photosDir)) {
        $allowed = Config::get('uploads.mime_types', []);
        $destinationDir = rtrim((string) Config::get('uploads.dir', ''), DIRECTORY_SEPARATOR);
        $files = scandir($photosDir) ?: [];

        foreach ($files as $filename) {
            if ($filename === '.' || $filename === '..') {
                continue;
            }

            $source = $photosDir . DIRECTORY_SEPARATOR . $filename;

            if (!is_file($source)) {
                continue;
            }

            $mime = '';
            if (class_exists('finfo')) {
                $finfo = new finfo(FILEINFO_MIME_TYPE);
                $detected = $finfo->file($source);
                $mime = is_string($detected) ? $detected : '';
            }

            if (!is_array($allowed) || !isset($allowed[$mime])) {
                continue;
            }

            $safeName = preg_replace('/[^A-Za-z0-9._-]/', '_', $filename) ?? 'photo';
            $destination = $destinationDir . DIRECTORY_SEPARATOR . $safeName;

            if (file_exists($destination)) {
                out("  photo already present, skipped: {$safeName}");
                $counts['photos_skipped']++;
                continue;
            }

            if ($dryRun) {
                out("  would copy photo: {$safeName}");
                $counts['photos_copied']++;
                continue;
            }

            if (!is_dir($destinationDir) && !@mkdir($destinationDir, 0775, true) && !is_dir($destinationDir)) {
                continue;
            }

            if (@copy($source, $destination)) {
                @chmod($destination, 0644);
                Database::insert('media', [
                    'filename' => $safeName,
                    'path'     => 'assets/' . $safeName,
                    'mime'     => $mime,
                    'size'     => (int) filesize($destination),
                    'kind'     => 'image',
                    'is_demo'  => 0,
                ]);
                out("  copied photo: {$safeName}");
                $counts['photos_copied']++;
            }
        }
    }

    if (!$dryRun && $runId > 0) {
        Database::execute(
            'UPDATE import_runs SET status = ?, entity_counts = ?, finished_at = NOW() WHERE id = ?',
            ['completed', json_encode($counts, JSON_UNESCAPED_SLASHES), $runId]
        );
    }
} catch (Throwable $e) {
    if (!$dryRun && Database::pdo()->inTransaction()) {
        Database::pdo()->rollBack();
    }

    if (!$dryRun && $runId > 0) {
        Database::execute(
            'UPDATE import_runs SET status = ?, notes = ?, finished_at = NOW() WHERE id = ?',
            ['failed', substr($e->getMessage(), 0, 1000), $runId]
        );
    }

    fwrite(STDERR, "Import failed: " . $e->getMessage() . PHP_EOL);
    fwrite(STDERR, "No database changes were committed (import staging, users and messages rolled back).\n");
    exit(1);
}

out('');
out('Summary:');
foreach ($counts as $key => $value) {
    out(sprintf('  %-20s %d', $key, $value));
}

if ($dryRun) {
    out('');
    out('DRY RUN complete. Run again without --dry-run to apply.');
}

out('Nothing was deleted. Unknown entities remain in import_staging for later migration.');
