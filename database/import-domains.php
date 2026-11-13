<?php
/**
 * Stage 4A importer.
 *
 * Moves the first group of school domains from a browser export
 * (the JSON file produced by the admin panel's "export" button, or by
 * SitePersist.exportAll) into MySQL.
 *
 * Usage:
 *   php database/import-domains.php --file=<export.json> [--dry-run] [--overwrite]
 *   php database/import-domains.php --file=<export.json> --photos=<folder>
 *
 * What it does, in order:
 *   1. copies the export into storage/imports (the original is kept),
 *   2. backs up the current contents of the domain tables,
 *   3. imports each Stage 4A domain, matching records on their
 *      original browser id so nothing is duplicated,
 *   4. leaves the domains it did not touch exactly as they were,
 *   5. prints a verification report (counts, duplicates, orphans).
 *
 * Nothing is ever deleted: records that disappear from the export are
 * only marked as removed, and every other domain stays where it was.
 *
 * PHP 8.1+
 */

declare(strict_types=1);

if (PHP_SAPI !== 'cli') {
    fwrite(STDERR, "This script may only be run from the command line.\n");
    exit(1);
}

require __DIR__ . '/../src/bootstrap.php';

use STA\Database;
use STA\Photos;
use STA\Store;

$options = [
    'file'      => '',
    'dry_run'   => false,
    'overwrite' => false,
    'prune'     => false,
    'photos'    => '',
];

foreach (array_slice($argv, 1) as $argument) {
    if (str_starts_with($argument, '--file=')) {
        $options['file'] = substr($argument, 7);
    } elseif (str_starts_with($argument, '--photos=')) {
        $options['photos'] = substr($argument, 9);
    } elseif ($argument === '--dry-run') {
        $options['dry_run'] = true;
    } elseif ($argument === '--overwrite') {
        $options['overwrite'] = true;
    } elseif ($argument === '--prune') {
        $options['prune'] = true;
    } else {
        fwrite(STDERR, "Unknown option: {$argument}\n");
        exit(1);
    }
}

function line(string $message): void
{
    echo $message . PHP_EOL;
}

function ok(string $message): void
{
    echo '  OK    ' . $message . PHP_EOL;
}

function warn(string $message): void
{
    echo '  WARN  ' . $message . PHP_EOL;
}

if ($options['file'] === '') {
    line('Stage 4A importer');
    line('------------------------');
    line('Usage: php database/import-domains.php --file=<export.json> [--dry-run] [--overwrite] [--prune]');
    exit(1);
}

$source = realpath($options['file']);

if ($source === false || !is_file($source)) {
    line('The export file could not be found: ' . $options['file']);
    exit(1);
}

line('Stage 4A importer');
line('------------------------');
line('Source file : ' . $source);
line('Dry run     : ' . ($options['dry_run'] ? 'yes' : 'no'));
line('Prune       : ' . ($options['prune'] ? 'yes (records missing from the export are marked removed)' : 'no (existing records are kept)'));
line('');

$raw = file_get_contents($source);

if ($raw === false) {
    line('The export file could not be read.');
    exit(1);
}

$export = json_decode($raw, true);

if (!is_array($export)) {
    line('The export file is not valid JSON.');
    exit(1);
}

/* -----------------------------------------------------------------
 * 1. Keep a copy of the original export
 * ----------------------------------------------------------------- */
$importsDir = dirname(__DIR__) . '/storage/imports';

if (!is_dir($importsDir)) {
    mkdir($importsDir, 0775, true);
}

$stamp = date('Ymd-His');
$copy = $importsDir . '/' . $stamp . '_' . basename($source);

if (!copy($source, $copy)) {
    line('The export file could not be copied into storage/imports.');
    exit(1);
}

ok('Original export kept at storage/imports/' . basename($copy));

/* -----------------------------------------------------------------
 * 2. Back up the current contents of the domain tables
 * ----------------------------------------------------------------- */
$backupsDir = dirname(__DIR__) . '/storage/backups';

if (!is_dir($backupsDir)) {
    mkdir($backupsDir, 0775, true);
}

$backupDir = $backupsDir . '/stage4a-import-' . $stamp;

if (!is_dir($backupDir) && !mkdir($backupDir, 0775, true)) {
    line('The backup folder could not be created.');
    exit(1);
}

$before = [];

foreach (Store::domains() as $key => $spec) {
    $before[$key] = Store::read($key);
}

file_put_contents(
    $backupDir . '/domains-before.json',
    json_encode($before, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE)
);

ok('Domain tables backed up to storage/backups/' . basename($backupDir));

/* -----------------------------------------------------------------
 * 2b. Look at the photographs in the export
 * ----------------------------------------------------------------- */
$collected = Photos::collect($export, array_keys(Store::domains()));
$photoPlan = [];
$photoProblems = [];

foreach ($collected['images'] as $key => $value) {
    $decoded = Photos::decode($value);

    if ($decoded === null) {
        $photoProblems[] = $key . ' (the data could not be read)';
        continue;
    }

    $check = Photos::verify($decoded['bytes'], $decoded['mime']);

    if (!$check['ok']) {
        $photoProblems[] = $key . ' (' . ($check['reason'] ?? 'not an allowed image') . ')';
        continue;
    }

    $photoPlan[$key] = ['bytes' => $decoded['bytes'], 'mime' => (string) $check['mime']];
}

foreach ($collected['inline'] as $key => $value) {
    $decoded = Photos::decode($value);

    if ($decoded === null) {
        $photoProblems[] = $key . ' (the inline data could not be read)';
        continue;
    }

    $check = Photos::verify($decoded['bytes'], $decoded['mime']);

    if (!$check['ok']) {
        $photoProblems[] = $key . ' (' . ($check['reason'] ?? 'not an allowed image') . ')';
        continue;
    }

    $photoPlan[$key] = ['bytes' => $decoded['bytes'], 'mime' => (string) $check['mime']];
}

$photoBytes = 0;

foreach ($photoPlan as $entry) {
    $photoBytes += strlen($entry['bytes']);
}

/* How many records will end up pointing at a picture on the server? */
$linkable = 0;

foreach (Store::domains() as $domain => $spec) {
    $records = $export[$domain] ?? null;

    if (!is_array($records) || $spec['type'] !== 'list') {
        continue;
    }

    foreach ($records as $record) {
        if (!is_array($record)) {
            continue;
        }

        $id = (string) ($record['id'] ?? '');

        foreach (['photoKey', 'imageKey'] as $keyField) {
            $key = (string) ($record[$keyField] ?? '');

            if ($key !== '' && isset($photoPlan[$key])) {
                $linkable++;
            }
        }

        foreach (['photo', 'imageUrl', 'image'] as $field) {
            if (isset($photoPlan[$domain . ':' . $id . ':' . $field])) {
                $linkable++;
            }
        }
    }
}

line('Photographs in the export');
line('-----------------------');
line('  images found        : ' . (count($collected['images']) + count($collected['inline'])));
line('  ready to import     : ' . count($photoPlan));
line('  total size          : ' . number_format($photoBytes / 1024, 1) . ' KB');
line('  records that will get a picture : ' . $linkable);

if ($photoProblems !== []) {
    line('  problems            : ' . count($photoProblems));

    foreach ($photoProblems as $problem) {
        line('    - ' . $problem);
    }
}

line('');

/* -----------------------------------------------------------------
 * 3. Import the Stage 4A domains
 * ----------------------------------------------------------------- */
$photoMap = [];
$photoSaved = 0;
$photoFailed = [];

if (!$options['dry_run'] && $photoPlan !== []) {
    Photos::assertAssetsFolder();

    foreach ($photoPlan as $key => $entry) {
        $saved = Photos::save($entry['bytes'], $entry['mime'], $key);

        if ($saved['ok'] && isset($saved['path'])) {
            $photoMap[$key] = $saved['path'];
            $photoSaved++;
        } else {
            $photoFailed[] = $key . ' (' . ($saved['reason'] ?? 'could not be saved') . ')';
        }
    }

    ok($photoSaved . ' photograph(s) written to assets/ and registered in the media table');

    foreach ($photoFailed as $failure) {
        warn('photograph not saved: ' . $failure);
    }
}

$report = [];

/**
 * Point a record at the imported photograph.
 *
 * @param array<string, mixed> $record
 * @return array<string, mixed>
 */
function link_photos(array $record, string $domain, array $photoMap): array
{
    $id = (string) ($record['id'] ?? '');

    foreach (['photo', 'imageUrl', 'image'] as $field) {
        $inlineKey = $domain . ':' . $id . ':' . $field;

        if (isset($photoMap[$inlineKey])) {
            $record[$field] = $photoMap[$inlineKey];
        }
    }

    foreach (['photoKey' => 'photo', 'imageKey' => 'imageUrl'] as $keyField => $pathField) {
        $key = (string) ($record[$keyField] ?? '');

        if ($key !== '' && isset($photoMap[$key])) {
            $record[$pathField] = $photoMap[$key];
        }
    }

    return $record;
}

foreach (Store::domains() as $key => $spec) {
    if (!array_key_exists($key, $export)) {
        $report[$key] = ['status' => 'not in export', 'source' => 0, 'written' => 0, 'deleted' => 0];
        continue;
    }

    $records = $export[$key];

    if (!is_array($records)) {
        $report[$key] = ['status' => 'skipped (not an object/array)', 'source' => 0, 'written' => 0, 'deleted' => 0, 'ids' => [], 'linked' => 0];
        continue;
    }

    $isList = array_is_list($records);
    $sourceCount = ($spec['type'] === 'object' || !$isList) ? 1 : count($records);

    if ($sourceCount === 0) {
        $report[$key] = ['status' => 'empty in export', 'source' => 0, 'written' => 0, 'deleted' => 0];
        continue;
    }

    if (Store::isMigrated($key) && !$options['overwrite']) {
        warn($key . ' is already migrated; pass --overwrite to import it again.');
        $report[$key] = ['status' => 'already migrated (skipped)', 'source' => $sourceCount, 'written' => 0, 'deleted' => 0];
        continue;
    }

    if ($options['dry_run']) {
        $report[$key] = ['status' => 'dry run', 'source' => $sourceCount, 'written' => 0, 'deleted' => 0];
        continue;
    }

    $sourceIds = [];
    $written = 0;
    $seen = [];
    $linked = 0;

    if ($spec['type'] === 'object' || !array_is_list($records)) {
        /* A single document, not a list of records. */
        $sourceIds = ['__document__'];
        $written = 1;
        $result = Store::write($key, $records, $options['prune']);
        Store::markMigrated($key, 1, 'import: ' . basename($source));

        $report[$key] = [
            'status'  => 'imported',
            'source'  => $sourceCount,
            'written' => $result['written'],
            'deleted' => $result['soft_deleted'],
            'ids'     => $sourceIds,
            'linked'  => 0,
        ];

        ok($key . ': document written to ' . $spec['table']);
        continue;
    }

    foreach ($records as $record) {
        if (!is_array($record)) {
            continue;
        }

        $legacyId = trim((string) ($record['id'] ?? ''));

        if ($legacyId !== '') {
            $sourceIds[] = $legacyId;
        }

        $written++;
    }

    $isListForPhotos = array_is_list($records);

    /* Point every record at the imported photograph before it is stored. */
    if ($photoMap !== [] && ($spec['type'] === 'list' || ($spec['type'] === 'auto' && $isListForPhotos))) {
        foreach ($records as $index => $record) {
            if (!is_array($record)) {
                continue;
            }

            $before = $record;
            $records[$index] = link_photos($record, $key, $photoMap);

            if ($records[$index] !== $before) {
                $linked++;
            }
        }
    }

    $result = Store::write($key, $records, $options['prune']);
    Store::markMigrated($key, $result['written'], 'import: ' . basename($source));

    $report[$key] = [
        'status'  => 'imported',
        'source'  => $sourceCount,
        'written' => $result['written'],
        'deleted' => $result['soft_deleted'],
        'ids'     => $sourceIds,
        'linked'  => $linked,
    ];

    ok($key . ': ' . $result['written'] . ' record(s) written to ' . $spec['table']);
}

/* Domains that are not part of the migration stay in the JSON mirror. */
$migrated = Store::readMigrated();

foreach ($export as $key => $value) {
    if (isset(Store::domains()[$key])) {
        continue;
    }

    $migrated[$key] = $value;
}

if (!$options['dry_run']) {
    $mirror = dirname(__DIR__) . '/data/site-data.json';

    if (!is_dir(dirname($mirror))) {
        mkdir(dirname($mirror), 0775, true);
    }

    $encoded = json_encode($migrated, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

    if ($encoded !== false) {
        file_put_contents($mirror, $encoded, LOCK_EX);
        ok('Domains still to be migrated kept in data/site-data.json');
    }
}

/* -----------------------------------------------------------------
 * 4. Verification report
 * ----------------------------------------------------------------- */
line('');
line('Report');
line('------');

foreach ($report as $key => $row) {
    line(sprintf(
        '  %-14s %-32s source=%d written=%d removed=%d',
        $key,
        $row['status'],
        $row['source'],
        $row['written'],
        $row['deleted']
    ));
}

line('');
line('Verification');
line('------------');

$problems = 0;

foreach (Store::domains() as $key => $spec) {
    if (($report[$key]['status'] ?? '') !== 'imported') {
        continue;
    }

    if ($spec['type'] === 'object') {
        $stored = (int) Database::value('SELECT COUNT(*) FROM content_documents WHERE doc_key = ?', [$key]);
        $matches = $stored === 1 ? 'stored' : 'missing';

        if ($stored !== 1) {
            warn($key . ': the document was not stored');
            $problems++;
            continue;
        }

        ok($key . ': document ' . $matches . ' in content_documents');
        continue;
    }

    $live = (int) Database::value(
        sprintf('SELECT COUNT(*) FROM `%s` WHERE deleted_at IS NULL', $spec['table'])
    );
    $total = (int) Database::value(sprintf('SELECT COUNT(*) FROM `%s`', $spec['table']));
    $duplicates = (int) Database::value(
        sprintf('SELECT COUNT(*) FROM (SELECT legacy_id FROM `%s` GROUP BY legacy_id HAVING COUNT(*) > 1) d', $spec['table'])
    );

    /* Every record from the export must be present and live. */
    $ids = $report[$key]['ids'] ?? [];
    $found = 0;

    if ($ids !== []) {
        $placeholders = [];
        $params = [];

        foreach ($ids as $index => $value) {
            $placeholders[] = ':i' . $index;
            $params[':i' . $index] = $value;
        }

        $found = (int) Database::value(
            sprintf(
                'SELECT COUNT(*) FROM `%s` WHERE deleted_at IS NULL AND legacy_id IN (%s)',
                $spec['table'],
                implode(', ', $placeholders)
            ),
            $params
        );
    }

    if ($found !== $report[$key]['source']) {
        warn($key . ': expected ' . $report[$key]['source'] . ' record(s) from the export but found ' . $found);
        $problems++;
        continue;
    }

    if ($options['prune'] && $live !== $report[$key]['source']) {
        warn($key . ': expected ' . $report[$key]['source'] . ' live rows but found ' . $live);
        $problems++;
        continue;
    }

    if ($duplicates > 0) {
        warn($key . ': ' . $duplicates . ' duplicate id(s) found');
        $problems++;
        continue;
    }

    ok($key . ': ' . $found . ' record(s) from the export are live, ' . $live . ' live row(s), ' . $total . ' row(s) kept in total, no duplicates');
}

line('');

$relationships = Store::relationshipReport();

foreach ($relationships as $label => $count) {
    if ($count === 0) {
        ok('relationship ' . $label . ': complete');
    } else {
        warn('relationship ' . $label . ': ' . $count . ' record(s) point at something that is not in the database');
    }
}

line('');
line('Photographs');
line('-----------');

if ($photoPlan === []) {
    line('  no photographs were found in the export');
} elseif ($options['dry_run']) {
    line('  dry run: ' . count($photoPlan) . ' photograph(s) would be written to assets/');
    line('  dry run: ' . $linkable . ' record(s) would point at a picture on the server');
} else {
    $missing = 0;
    $checked = 0;

    foreach ($photoMap as $key => $path) {
        $file = dirname(__DIR__) . DIRECTORY_SEPARATOR . $path;
        $checked++;

        if (!is_file($file)) {
            $missing++;
            warn('the photograph file is missing: ' . $path . ' (' . $key . ')');
        }
    }

    $registered = (int) Database::value(
        "SELECT COUNT(*) FROM media WHERE legacy_key IS NOT NULL AND legacy_key <> ''"
    );
    $linkedTotal = 0;

    foreach ($report as $row) {
        $linkedTotal += (int) ($row['linked'] ?? 0);
    }

    if ($missing === 0 && $checked > 0) {
        ok('every imported photograph is present on disk (' . $checked . ' file(s))');
    } elseif ($checked === 0) {
        warn('no photograph file was written');
    } else {
        warn($missing . ' of ' . $checked . ' imported photograph(s) are missing from assets/');
        $problems++;
    }

    ok($linkedTotal . ' record(s) point at a picture on the server');
    ok($registered . ' imported photograph(s) registered in the media table');
}

line('');

if ($problems > 0) {
    line('The import finished with ' . $problems . ' problem(s). Nothing was deleted - review the report above.');
    exit(1);
}

line($options['dry_run'] ? 'Dry run complete. No data was written.' : 'Import complete and verified.');
exit(0);
