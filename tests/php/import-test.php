<?php

declare(strict_types=1);

/**
 * Stage 4A import test (photographs + domains).
 *
 * Runs the real importer against a throwaway database using an export
 * in exactly the shape the admin panel produces (records plus
 * "__images" and inline data URLs), then checks that:
 *   - the dry run writes nothing,
 *   - the records arrive with their original ids and fields,
 *   - every photograph is written to assets/ and registered,
 *   - every record that had a picture now points at the file,
 *   - nothing is duplicated by re-running the import,
 *   - unrelated domains are left exactly as they were.
 *
 *   set STA_DB_NAME=sta_school_test
 *   php tests/php/import-test.php
 */

if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit("CLI only.\n");
}

putenv('STA_DB_NAME=sta_school_test');

require dirname(__DIR__, 2) . '/src/bootstrap.php';

use STA\Config;
use STA\Database;
use STA\Photos;
use STA\Store;

$passed = 0;
$failed = 0;

function check(string $name, bool $condition, string $detail = ''): void
{
    global $passed, $failed;

    if ($condition) {
        $passed++;
        echo "PASS  {$name}\n";
    } else {
        $failed++;
        echo "FAIL  {$name}" . ($detail !== '' ? " ({$detail})" : '') . "\n";
    }
}

function runImporter(string $file, bool $dryRun = false): array
{
    $root = dirname(__DIR__, 2);
    $parts = [
        'C:/XX/php/php.exe',
        escapeshellarg($root . '/database/import-domains.php'),
        '--file=' . escapeshellarg($file),
        '--overwrite',
    ];

    if ($dryRun) {
        $parts[] = '--dry-run';
    }

    $spec = [
        0 => ['pipe', 'r'],
        1 => ['pipe', 'w'],
        2 => ['pipe', 'w'],
    ];

    $process = proc_open(implode(' ', $parts), $spec, $pipes, $root);

    if (!is_resource($process)) {
        return ['code' => 1, 'output' => ''];
    }

    fclose($pipes[0]);
    $output = stream_get_contents($pipes[1]);
    $error = stream_get_contents($pipes[2]);
    fclose($pipes[1]);
    fclose($pipes[2]);
    $code = proc_close($process);

    return ['code' => $code, 'output' => (string) $output, 'error' => (string) $error];
}

echo "Stage 4A import test (database: " . Config::get('db.name') . ")\n";
echo str_repeat('-', 60) . "\n";

check('test database is in use', Config::get('db.name') === 'sta_school_test', (string) Config::get('db.name'));

/* -----------------------------------------------------------------
 * A clean start, and a realistic export
 * ----------------------------------------------------------------- */
foreach (['students', 'staff', 'classes', 'academic_years', 'leadership', 'slider_slides', 'announcements',
    'domain_attendance', 'domain_audit_log', 'domain_class_assignments', 'domain_class_fee_structures',
    'domain_exams', 'domain_exam_results', 'domain_exam_schedule', 'domain_fee_charges', 'domain_fee_items',
    'domain_fee_notification_log', 'domain_homework', 'domain_homework_submissions', 'domain_inv_counters',
    'domain_inv_items', 'domain_inv_movements', 'domain_inv_orders', 'domain_inv_requests', 'domain_inv_suppliers',
    'domain_inv_transfers', 'domain_materials', 'domain_message_log', 'domain_notifications',
    'domain_notification_settings', 'domain_parents', 'domain_payments', 'domain_report_cards',
    'domain_student_transfers', 'domain_submissions', 'domain_sub_counters', 'domain_timetable',
    'domain_tt_archive', 'domain_tt_classes', 'domain_tt_classrooms', 'domain_tt_config', 'domain_tt_constraints',
    'domain_tt_divisions', 'domain_tt_subjects', 'domain_tt_teachers'] as $table) {
    Database::execute("DELETE FROM `{$table}`");
}

Database::execute("DELETE FROM content_documents WHERE doc_key IN ('settings', 'logo')");
Database::execute("UPDATE domain_state SET migrated_at = NULL, record_count = 0");
Database::execute("DELETE FROM media WHERE legacy_key <> '' OR legacy_key IS NOT NULL");

/* Remember what is already in assets/ so the test only removes its own files. */
$assetsBefore = glob(dirname(__DIR__, 2) . '/assets/img_*.{png,jpg,jpeg,gif,webp}', GLOB_BRACE) ?: [];
$assetsBefore = array_map(static fn (string $file): string => realpath($file) ?: $file, $assetsBefore);

/* A real 1x1 PNG and a text file pretending to be an image. */
$png = base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Y9Zl9sAAAAASUVORK5CYII=', true);
$jpeg = base64_decode('/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/wAALCAABAAEBAREA/8QAFAABAAAAAAAAAAAAAAAAAAAACf/EABQQAQAAAAAAAAAAAAAAAAAAAAD/2gAIAQEAAD8AVN//2Q==', true);

$export = [
    'students' => [
        [
            'id' => 'imp_stu_1', 'firstName' => 'Imported', 'lastName' => 'One', 'className' => 'Grade 9',
            'grade' => 'Grade 9', 'status' => 'active', 'feeBalance' => 0,
            'photoKey' => 'stu_photo_imp_stu_1', 'photo' => '',
        ],
        [
            'id' => 'imp_stu_2', 'firstName' => 'Imported', 'lastName' => 'Two', 'className' => 'Grade 9',
            'grade' => 'Grade 9', 'status' => 'active',
            'photo' => 'data:image/jpeg;base64,' . base64_encode((string) $jpeg),
        ],
    ],
    'classes' => [
        ['id' => 'imp_cls_1', 'name' => 'Grade 9', 'level' => 9, 'teacherId' => 'imp_tea_1', 'teacherName' => 'Teacher One', 'subjects' => [], 'status' => 'active'],
    ],
    'teachers' => [
        ['id' => 'imp_tea_1', 'firstName' => 'Teacher', 'lastName' => 'One', 'subject' => 'English', 'status' => 'active'],
    ],
    'slider' => [
        ['id' => 'imp_sld_1', 'title' => 'Welcome', 'imageKey' => 'homeHero', 'imageUrl' => ''],
    ],
    'announcements' => [
        ['id' => 'imp_ann_1', 'title' => 'Term opens', 'body' => 'Term opens in January.', 'audience' => 'all', 'status' => 'published'],
    ],
    'settings' => ['schoolName' => 'St. Teresa Kanyange Academy', 'currency' => 'Ksh'],
    /* A domain that is not part of Stage 4A - it must stay untouched. */
    'payments' => [
        ['id' => 'pay_1', 'studentId' => 'imp_stu_1', 'amount' => 4200, 'method' => 'Cash'],
        ['id' => 'pay_2', 'studentId' => 'imp_stu_2', 'amount' => 300, 'method' => 'Card'],
    ],
    '__images' => [
        'stu_photo_imp_stu_1' => 'data:image/png;base64,' . base64_encode((string) $png),
        'homeHero' => 'data:image/png;base64,' . base64_encode((string) $png),
        'broken' => 'not a data url at all',
        'fake' => 'data:image/png;base64,' . base64_encode('this is not an image'),
    ],
];

$exportFile = dirname(__DIR__, 2) . '/storage/imports/test-import-' . date('His') . '.json';
file_put_contents($exportFile, json_encode($export, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));

/* -----------------------------------------------------------------
 * 1. Dry run
 * ----------------------------------------------------------------- */
$result = runImporter($exportFile, true);
$out = $result['output'];

check('dry run exits successfully', $result['code'] === 0, 'exit=' . $result['code']);
check('dry run reports the photographs it found', str_contains($out, 'images found') && str_contains($out, 'ready to import'), 'report missing');
check('dry run reports the broken photograph', str_contains($out, 'broken') || str_contains($out, 'problems'), 'no problem reported');
check('dry run reports how many records will get a picture', str_contains($out, 'records that will get a picture'), 'link report missing');

$studentsAfterDry = (int) Database::value("SELECT COUNT(*) FROM students WHERE legacy_id LIKE 'imp_%'");
check('dry run wrote no records', $studentsAfterDry === 0, 'rows=' . $studentsAfterDry);

$mediaAfterDry = (int) Database::value('SELECT COUNT(*) FROM media');
check('dry run wrote no files', $mediaAfterDry === 0, 'media rows=' . $mediaAfterDry);

/* -----------------------------------------------------------------
 * 2. Import
 * ----------------------------------------------------------------- */
$result = runImporter($exportFile);
$out = $result['output'];

check('import exits successfully', $result['code'] === 0, 'exit=' . $result['code']);
check('import verified itself', str_contains($out, 'Import complete and verified'), substr($out, -200));
check('import kept the export file in storage/imports', is_file($exportFile), basename($exportFile));

$students = Store::read('students');
check('students imported', count($students) === 2, 'count=' . count($students));

$first = null;
$second = null;

foreach ($students as $record) {
    if (($record['id'] ?? '') === 'imp_stu_1') {
        $first = $record;
    }
    if (($record['id'] ?? '') === 'imp_stu_2') {
        $second = $record;
    }
}

check('the student id is unchanged', $first !== null && ($first['id'] ?? '') === 'imp_stu_1');
check('the student fields are unchanged', ($first['firstName'] ?? '') === 'Imported' && ($first['className'] ?? '') === 'Grade 9');
check('the photo key is preserved', ($first['photoKey'] ?? '') === 'stu_photo_imp_stu_1', (string) ($first['photoKey'] ?? ''));
check(
    'the student record points at the imported photograph',
    str_starts_with((string) ($first['photo'] ?? ''), 'assets/'),
    (string) ($first['photo'] ?? '')
);
check('the inline photograph was imported as a file', str_starts_with((string) ($second['photo'] ?? ''), 'assets/'), (string) ($second['photo'] ?? ''));

$slide = Store::read('slider')[0] ?? [];
check('the slider record points at the imported photograph', str_starts_with((string) ($slide['imageUrl'] ?? ''), 'assets/'), (string) ($slide['imageUrl'] ?? ''));

/* -----------------------------------------------------------------
 * 3. The photographs are real files
 * ----------------------------------------------------------------- */
$paths = [];

foreach ([$first['photo'] ?? '', $second['photo'] ?? '', $slide['imageUrl'] ?? ''] as $path) {
    if ($path === '') {
        continue;
    }

    $paths[] = $path;
    $file = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . $path;

    check('the photograph exists on disk: ' . $path, is_file($file), $path);

    if (is_file($file)) {
        $info = @getimagesize($file);
        check('the file is a real image: ' . $path, is_array($info), $path);
    }
}

check('the broken photograph was refused', str_contains($out, 'broken'), 'no warning about the broken image');
check('the fake photograph was refused', str_contains($out, 'fake'), 'no warning about the fake image');

$media = (int) Database::value('SELECT COUNT(*) FROM media WHERE kind = "image"');
check('every imported photograph is registered', $media === count(array_unique($paths)), 'media=' . $media . ' files=' . count(array_unique($paths)));
check('the media table records the original key', (int) Database::value("SELECT COUNT(*) FROM media WHERE legacy_key = 'stu_photo_imp_stu_1'") === 1);

/* -----------------------------------------------------------------
 * 4. Nothing duplicated, unrelated data untouched
 * ----------------------------------------------------------------- */
$duplicates = (int) Database::value('SELECT COUNT(*) FROM (SELECT legacy_id FROM students GROUP BY legacy_id HAVING COUNT(*) > 1) d');
check('no duplicate students', $duplicates === 0, 'duplicates=' . $duplicates);

$firstCount = count(Store::read('students'));
$result = runImporter($exportFile);
$secondCount = count(Store::read('students'));
check('re-running the import does not duplicate records', $secondCount === $firstCount, $firstCount . ' -> ' . $secondCount);

$payments = Store::read('payments');
check('the 4B payments domain imported to MySQL', is_array($payments) && count($payments) === 2, 'payments=' . (is_array($payments) ? count($payments) : 'missing'));
check('payments keep their browser ids', is_array($payments) && ($payments[0]['id'] ?? '') === 'pay_1', 'id=' . (is_array($payments) ? ($payments[0]['id'] ?? '?') : 'missing'));

$year = Store::read('academicYears');
check('a domain that was not in the export stays empty', is_array($year) && count($year) === 0, 'count=' . (is_array($year) ? count($year) : 0));

$relationships = Store::relationshipReport();
check('the imported students link to the imported class', $relationships['students_without_class'] === 0, 'orphans=' . $relationships['students_without_class']);
check('the imported class links to the imported teacher', $relationships['classes_without_teacher'] === 0, 'orphans=' . $relationships['classes_without_teacher']);

/* -----------------------------------------------------------------
 * 5. Cleanup - the test database is throwaway, but the files stay clean
 * ----------------------------------------------------------------- */
foreach (['students', 'staff', 'classes', 'academic_years', 'leadership', 'slider_slides', 'announcements',
    'domain_attendance', 'domain_audit_log', 'domain_class_assignments', 'domain_class_fee_structures',
    'domain_exams', 'domain_exam_results', 'domain_exam_schedule', 'domain_fee_charges', 'domain_fee_items',
    'domain_fee_notification_log', 'domain_homework', 'domain_homework_submissions', 'domain_inv_counters',
    'domain_inv_items', 'domain_inv_movements', 'domain_inv_orders', 'domain_inv_requests', 'domain_inv_suppliers',
    'domain_inv_transfers', 'domain_materials', 'domain_message_log', 'domain_notifications',
    'domain_notification_settings', 'domain_parents', 'domain_payments', 'domain_report_cards',
    'domain_student_transfers', 'domain_submissions', 'domain_sub_counters', 'domain_timetable',
    'domain_tt_archive', 'domain_tt_classes', 'domain_tt_classrooms', 'domain_tt_config', 'domain_tt_constraints',
    'domain_tt_divisions', 'domain_tt_subjects', 'domain_tt_teachers'] as $table) {
    Database::execute("DELETE FROM `{$table}`");
}

Database::execute("DELETE FROM content_documents WHERE doc_key IN ('settings', 'logo')");
Database::execute("UPDATE domain_state SET migrated_at = NULL, record_count = 0");
Database::execute("DELETE FROM media WHERE legacy_key <> '' OR legacy_key IS NOT NULL");

foreach (array_unique($paths) as $path) {
    $file = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . $path;

    if (is_file($file)) {
        @unlink($file);
    }
}

if (is_file($exportFile)) {
    @unlink($exportFile);
}

$newFiles = [];

foreach (glob(dirname(__DIR__, 2) . '/assets/img_*.{png,jpg,jpeg,gif,webp}', GLOB_BRACE) ?: [] as $file) {
    $real = realpath($file) ?: $file;

    if (!in_array($real, $assetsBefore, true)) {
        $newFiles[] = $file;
    }
}

foreach ($newFiles as $file) {
    @unlink($file);
}

$left = 0;

foreach (glob(dirname(__DIR__, 2) . '/assets/img_*.{png,jpg,jpeg,gif,webp}', GLOB_BRACE) ?: [] as $file) {
    $real = realpath($file) ?: $file;

    if (!in_array($real, $assetsBefore, true)) {
        $left++;
    }
}

check('no test photographs left in assets/', $left === 0, 'files=' . $left);
check('no test rows left in the domain tables', (int) Database::value('SELECT COUNT(*) FROM students') === 0, 'rows=' . Database::value('SELECT COUNT(*) FROM students'));

echo "\n" . str_repeat('-', 60) . "\n";
echo "Result: {$passed} passed, {$failed} failed\n";

exit($failed === 0 ? 0 : 1);
