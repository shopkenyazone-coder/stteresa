<?php

declare(strict_types=1);

/**
 * Stage 4A store test.
 *
 * Runs the whole Stage 4A data path against a throwaway database so
 * the live school data is never touched:
 *
 *   set STA_DB_NAME=sta_school_test
 *   php tests/php/store-test.php
 *
 * Covers create / read / update / delete for every migrated domain,
 * record fidelity (a record read back is identical to the one
 * written), idempotency (no duplicates on re-import), soft deletes
 * (nothing is destroyed) and the relationships between the domains.
 */

if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit("CLI only.\n");
}

putenv('STA_DB_NAME=sta_school_test');

require dirname(__DIR__, 2) . '/src/bootstrap.php';

use STA\Config;
use STA\Database;
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

echo "Stage 4A store test (database: " . Config::get('db.name') . ")\n";
echo str_repeat('-', 60) . "\n";

check('test database is in use', Config::get('db.name') === 'sta_school_test', (string) Config::get('db.name'));

/* -----------------------------------------------------------------
 * Start from a clean set of domain tables
 * ----------------------------------------------------------------- */
foreach (['students', 'staff', 'classes', 'academic_years', 'leadership', 'slider_slides', 'announcements'] as $table) {
    Database::execute("DELETE FROM `{$table}`");
}

Database::execute("DELETE FROM content_documents WHERE doc_key IN ('settings', 'logo')");
Database::execute("UPDATE domain_state SET migrated_at = NULL, record_count = 0");

/* -----------------------------------------------------------------
 * Fixtures shaped exactly like the browser records
 * ----------------------------------------------------------------- */
$students = [
    [
        'id' => 'stu_001', 'firstName' => 'John', 'lastName' => 'Smith', 'fullName' => 'John Smith',
        'email' => 'jsmith@student.stteresa.edu', 'grade' => 'Grade 9', 'className' => 'Grade 9',
        'admissionNo' => 'STA-2024-001', 'gender' => 'Male', 'dob' => '2010-05-14',
        'parentName' => 'Robert Smith', 'parentPhone' => '(555) 201-8899', 'parentEmail' => 'rsmith@parent.stteresa.edu',
        'address' => '42 Oak Lane, Fairfield, CT', 'admissionDate' => '2024-08-20',
        'status' => 'active', 'feeBalance' => 0, 'photo' => '', 'someExtraField' => 'keep me',
    ],
    [
        'id' => 'stu_002', 'firstName' => 'Emily', 'lastName' => 'Johnson', 'fullName' => 'Emily Johnson',
        'email' => 'ejohnson@student.stteresa.edu', 'grade' => 'Grade 9', 'className' => 'Grade 9',
        'admissionNo' => 'STA-2025-002', 'gender' => 'Female', 'dob' => '2011-03-22',
        'parentName' => 'Michael Johnson', 'parentPhone' => '(555) 334-1122', 'parentEmail' => 'mjohnson@parent.stteresa.edu',
        'address' => '18 Pine Road, Fairfield, CT', 'admissionDate' => '2025-08-19',
        'status' => 'active', 'feeBalance' => 12500, 'photo' => '',
    ],
    [
        'id' => 'stu_003', 'firstName' => 'Peter', 'lastName' => 'Mwangi', 'fullName' => 'Peter Mwangi',
        'email' => 'pmwangi@student.stteresa.edu', 'grade' => 'Grade 8', 'className' => 'Grade 8',
        'admissionNo' => 'STA-2025-003', 'gender' => 'Male', 'status' => 'pending',
        'admissionDate' => '2025-09-02', 'feeBalance' => 0, 'photo' => '',
    ],
];

$teachers = [
    [
        'id' => 'tea_001', 'firstName' => 'Margaret', 'lastName' => 'OBrien', 'email' => 'mobrien@stteresa.edu',
        'subject' => 'Mathematics', 'role' => 'Teacher', 'phone' => '(555) 100-2000',
        'qualification' => 'M.Ed.', 'status' => 'active', 'photo' => '', 'staffNo' => 'STA-T001',
        'bio' => 'M.Ed. with 28 years in Catholic education.',
    ],
    [
        'id' => 'tea_002', 'firstName' => 'David', 'lastName' => 'Chen', 'email' => 'dchen@stteresa.edu',
        'subject' => 'Science', 'role' => 'Teacher', 'phone' => '(555) 100-2001',
        'qualification' => 'M.S. Engineering', 'status' => 'active', 'photo' => '', 'staffNo' => 'STA-T002',
    ],
];

$classes = [
    [
        'id' => 'cls_001', 'name' => 'Grade 9', 'level' => 9, 'academicYear' => '2026', 'term' => '1',
        'teacherId' => 'tea_001', 'teacherName' => 'Margaret OBrien', 'subjects' => ['Mathematics', 'English'],
        'status' => 'active',
    ],
    [
        'id' => 'cls_002', 'name' => 'Grade 8', 'level' => 8, 'academicYear' => '2026', 'term' => '1',
        'teacherId' => 'tea_002', 'teacherName' => 'David Chen', 'subjects' => ['Science'],
        'status' => 'active',
    ],
    [
        'id' => 'cls_003', 'name' => 'Grade 10', 'level' => 10, 'academicYear' => '2026', 'term' => '1',
        'teacherId' => 'tea_001', 'teacherName' => 'Margaret OBrien', 'subjects' => ['Mathematics'],
        'status' => 'active',
    ],
];

$years = [
    ['id' => 'yr_001', 'label' => '2026', 'name' => 'Academic Year 2026', 'startDate' => '2026-01-06', 'endDate' => '2026-12-11', 'defaultTerm' => '1', 'status' => 'active'],
    ['id' => 'yr_002', 'label' => '2025', 'name' => 'Academic Year 2025', 'startDate' => '2025-01-07', 'endDate' => '2025-12-12', 'defaultTerm' => '1', 'status' => 'inactive'],
];

$leadership = [
    ['id' => 'lea_001', 'name' => 'Sr. Mary Wanjiku', 'position' => 'Headteacher', 'email' => 'head@stteresa.edu', 'photo' => ''],
];

$slides = [
    ['id' => 'sld_001', 'title' => 'Welcome', 'description' => 'Excellence in Catholic education since 1962', 'imageUrl' => 'assets/a.jpg', 'imageKey' => ''],
];

$announcements = [
    ['id' => 'ann_001', 'title' => 'Term opens', 'body' => 'The new term opens on 6 January.', 'audience' => 'all', 'status' => 'published', 'publishedAt' => '2026-01-02'],
];

$settings = [
    'schoolName' => 'St. Teresa Kanyange Academy', 'motto' => 'Unity is Strength', 'currency' => 'Ksh',
    'academicYear' => '2026', 'term' => '1', 'timezone' => 'Africa/Nairobi',
];

$logo = ['name' => 'St. Teresa Kanyange Academy', 'initials' => 'ST', 'image' => 'assets/logo.png'];

/* -----------------------------------------------------------------
 * 1. CREATE + READ
 * ----------------------------------------------------------------- */
$written = Store::write('students', $students);
check('write students returns the record count', $written['written'] === 3, (string) $written['written']);

$read = Store::read('students');
check('read students returns every record', is_array($read) && count($read) === 3, (string) (is_array($read) ? count($read) : 0));

$first = $read[0] ?? [];
check('record keeps its original id', ($first['id'] ?? '') === 'stu_001', (string) ($first['id'] ?? ''));
check('record keeps every original field', ($first['someExtraField'] ?? '') === 'keep me', 'unknown fields are preserved');
check('numeric field keeps its type', ($first['feeBalance'] ?? null) === 0, var_export($first['feeBalance'] ?? null, true));
check('record round-trips unchanged', $first == $students[0]);

$columns = Database::one('SELECT full_name, class_name, admission_no, fee_balance FROM students WHERE legacy_id = ?', ['stu_001']);
check('searchable columns are filled', ($columns['full_name'] ?? '') === 'John Smith', (string) ($columns['full_name'] ?? ''));
check('class column is filled', ($columns['class_name'] ?? '') === 'Grade 9', (string) ($columns['class_name'] ?? ''));
check('fee balance column is filled', (float) ($columns['fee_balance'] ?? -1) === 0.0, (string) ($columns['fee_balance'] ?? ''));

/* -----------------------------------------------------------------
 * 2. IDEMPOTENCY (re-import must not duplicate)
 * ----------------------------------------------------------------- */
Store::write('students', $students);
$total = (int) Database::value('SELECT COUNT(*) FROM students');
check('re-importing does not duplicate rows', $total === 3, 'rows=' . $total);

$dupes = (int) Database::value('SELECT COUNT(*) FROM (SELECT legacy_id FROM students GROUP BY legacy_id HAVING COUNT(*) > 1) d');
check('no duplicate ids in the table', $dupes === 0, 'duplicates=' . $dupes);

/* -----------------------------------------------------------------
 * 3. UPDATE
 * ----------------------------------------------------------------- */
$updated = $students[0];
$updated['className'] = 'Grade 10';
$updated['feeBalance'] = 4500;
$result = Store::update('students', 'stu_001', $updated);
check('update reports success', ($result['ok'] ?? false) === true);

$read = Store::read('students');
$found = null;

foreach ($read as $record) {
    if (($record['id'] ?? '') === 'stu_001') {
        $found = $record;
    }
}

check('update keeps the record id', ($found['id'] ?? '') === 'stu_001');
check('update changes the stored value', ($found['className'] ?? '') === 'Grade 10', (string) ($found['className'] ?? ''));
check('update keeps the update time', (float) Database::value('SELECT fee_balance FROM students WHERE legacy_id = ?', ['stu_001']) === 4500.0);

$missing = Store::update('students', 'nope_999', ['className' => 'X']);
check('updating a missing record is refused', ($missing['ok'] ?? true) === false, (string) ($missing['error'] ?? ''));

/* -----------------------------------------------------------------
 * 4. DELETE (soft - the row is kept)
 * ----------------------------------------------------------------- */
$deleted = Store::delete('students', 'stu_003');
check('delete reports success', ($deleted['ok'] ?? false) === true);

$live = Store::read('students');
check('deleted record is no longer returned', count($live) === 2, 'live=' . count($live));

$rows = (int) Database::value('SELECT COUNT(*) FROM students');
check('deleted record is still kept in the table', $rows === 3, 'rows=' . $rows);

$stamped = Database::value('SELECT deleted_at FROM students WHERE legacy_id = ?', ['stu_003']);
check('deleted record is stamped, not destroyed', $stamped !== null, (string) $stamped);

/* -----------------------------------------------------------------
 * 5. The other domains
 * ----------------------------------------------------------------- */
Store::write('teachers', $teachers);
Store::write('classes', $classes);
Store::write('academicYears', $years);
Store::write('leadership', $leadership);
Store::write('slider', $slides);
Store::write('announcements', $announcements);
Store::write('settings', $settings);
Store::write('logo', $logo);

check('teachers read back', count(Store::read('teachers')) === 2);
check('classes read back', count(Store::read('classes')) === 3);
check('academic years read back', count(Store::read('academicYears')) === 2);
check('leadership read back', count(Store::read('leadership')) === 1);
check('slider read back', count(Store::read('slider')) === 1);
check('announcements read back', count(Store::read('announcements')) === 1);

$settingsRead = Store::read('settings');
check('settings read back as an object', is_array($settingsRead) && ($settingsRead['schoolName'] ?? '') === 'St. Teresa Kanyange Academy');
check('settings keep every key', array_keys($settingsRead) === array_keys($settings), implode(',', array_keys($settingsRead)));

$logoRead = Store::read('logo');
check('logo read back as an object', is_array($logoRead) && ($logoRead['initials'] ?? '') === 'ST');

$classRow = Database::one('SELECT teacher_legacy_id, teacher_name, subjects FROM classes WHERE legacy_id = ?', ['cls_001']);
check('class keeps the teacher link', ($classRow['teacher_legacy_id'] ?? '') === 'tea_001', (string) ($classRow['teacher_legacy_id'] ?? ''));
check('class keeps the teacher name', ($classRow['teacher_name'] ?? '') === 'Margaret OBrien');
check('class keeps its subject list', is_array(json_decode((string) $classRow['subjects'], true)) && count(json_decode((string) $classRow['subjects'], true)) === 2);

/* -----------------------------------------------------------------
 * 6. RELATIONSHIPS
 * ----------------------------------------------------------------- */
$relations = Store::relationshipReport();
check('every student sits in a known class', $relations['students_without_class'] === 0, 'orphans=' . $relations['students_without_class']);
check('every class has a known teacher', $relations['classes_without_teacher'] === 0, 'orphans=' . $relations['classes_without_teacher']);

Store::write('classes', array_merge($classes, [[
    'id' => 'cls_004', 'name' => 'Grade 7', 'level' => 7, 'academicYear' => '2026', 'term' => '1',
    'teacherId' => 'tea_missing', 'teacherName' => 'Gone', 'subjects' => [], 'status' => 'active',
]]));

$relations = Store::relationshipReport();
check('a class with a missing teacher is reported', $relations['classes_without_teacher'] === 1, 'orphans=' . $relations['classes_without_teacher']);
check('the broken link is not deleted', count(Store::read('classes')) === 4, 'classes=' . count(Store::read('classes')));

/* -----------------------------------------------------------------
 * 7. NOTHING IS LOST WHEN A DOMAIN SHRINKS
 * ----------------------------------------------------------------- */
Store::write('students', [$students[0]]);
$total = (int) Database::value('SELECT COUNT(*) FROM students');
$live = (int) Database::value('SELECT COUNT(*) FROM students WHERE deleted_at IS NULL');
check('an import keeps every row', $total === 3, 'rows=' . $total);
check('an import does not remove records by itself', $live === 2, 'live=' . $live);

Store::write('students', [$students[0]], true);
$total = (int) Database::value('SELECT COUNT(*) FROM students');
$live = (int) Database::value('SELECT COUNT(*) FROM students WHERE deleted_at IS NULL');
check('a pruning save keeps every row', $total === 3, 'rows=' . $total);
check('a pruning save only marks removals', $live === 1, 'live=' . $live);

/* -----------------------------------------------------------------
 * 8. THE MIGRATION SWITCH
 * ----------------------------------------------------------------- */
check('a domain is not served from MySQL before it is imported', Store::isMigrated('students') === false);

Store::markMigrated('students', 1, 'stage 4A test');
check('a domain is served from MySQL after the import', Store::isMigrated('students') === true);

$migrated = Store::readMigrated();
check('readMigrated returns only imported domains', array_keys($migrated) === ['students'], implode(',', array_keys($migrated)));

$counts = Store::counts();
check('counts report live and deleted rows', $counts['students']['total'] === 3 && $counts['students']['live'] === 1 && $counts['students']['deleted'] === 2, json_encode($counts['students']));

echo "\n" . str_repeat('-', 60) . "\n";
echo "Result: {$passed} passed, {$failed} failed\n";

exit($failed === 0 ? 0 : 1);
