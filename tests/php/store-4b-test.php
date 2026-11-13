<?php

declare(strict_types=1);

/**
 * Stage 4B domain test.
 *
 * Runs the complete Stage 4B domain set against a throwaway database:
 *
 *   set STA_DB_NAME=sta_school_test
 *   php tests/php/store-4b-test.php
 *
 * Every domain must survive a write -> read round trip unchanged, a
 * re-import must not duplicate records, document domains must read
 * back as the original object, soft deletes keep the rows, and the
 * relationship report must find no orphans for matching data.
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

echo "Stage 4B domain test (database: " . Config::get('db.name') . ")\n";
echo str_repeat('-', 60) . "\n";

check('test database is in use', Config::get('db.name') === 'sta_school_test', (string) Config::get('db.name'));

/* -----------------------------------------------------------------
 * Clean every domain table and start the fixture set
 * ----------------------------------------------------------------- */
$tables4b = [
    'domain_attendance', 'domain_audit_log', 'domain_class_assignments', 'domain_class_fee_structures',
    'domain_exams', 'domain_exam_results', 'domain_exam_schedule', 'domain_fee_charges', 'domain_fee_items',
    'domain_fee_notification_log', 'domain_homework', 'domain_homework_submissions', 'domain_inv_counters',
    'domain_inv_items', 'domain_inv_movements', 'domain_inv_orders', 'domain_inv_requests', 'domain_inv_suppliers',
    'domain_inv_transfers', 'domain_materials', 'domain_message_log', 'domain_notifications',
    'domain_notification_settings', 'domain_parents', 'domain_payments', 'domain_report_cards',
    'domain_student_transfers', 'domain_submissions', 'domain_sub_counters', 'domain_timetable',
    'domain_tt_archive', 'domain_tt_classes', 'domain_tt_classrooms', 'domain_tt_config', 'domain_tt_constraints',
    'domain_tt_divisions', 'domain_tt_subjects', 'domain_tt_teachers',
];

foreach ($tables4b as $table) {
    Database::execute("DELETE FROM `{$table}`");
}

Database::execute("UPDATE domain_state SET migrated_at = NULL, record_count = 0 WHERE domain_key NOT IN ('students', 'teachers', 'classes', 'academicYears', 'leadership', 'slider', 'announcements', 'settings', 'logo')");
Database::execute('DELETE FROM classes');
Database::execute('DELETE FROM staff');

$student = [
    'id' => 'stu_4b_fixture', 'firstName' => 'Fixture', 'lastName' => 'Student', 'className' => 'Grade 9',
    'grade' => 'Grade 9', 'status' => 'active', 'admissionNo' => 'S4B-001', 'feeBalance' => 0,
];

Store::write('students', [$student], true);

/* A teacher for the fixture and matching portal accounts, so the
   student/teacher relationship checks are complete. */
Database::execute("DELETE FROM users WHERE legacy_id IN ('stu_4b_fixture', 'tea_4b_fixture')");
Database::execute("DELETE FROM staff WHERE legacy_id = 'tea_4b_fixture'");
Database::insert('users', [
    'legacy_id' => 'tea_4b_fixture', 'username' => 's4b_teacher', 'email' => 's4b-tea@example.test',
    'password_hash' => \STA\Auth::hashPassword('s4bfixpass1'), 'role' => 'teacher', 'status' => 'active',
    'name' => 'Fixture Teacher', 'is_demo' => 1,
]);
Database::insert('users', [
    'legacy_id' => 'stu_4b_fixture', 'username' => 's4b_student', 'email' => 's4b-stu@example.test',
    'password_hash' => \STA\Auth::hashPassword('s4bfixpass1'), 'role' => 'student', 'status' => 'active',
    'name' => 'Fixture Student', 'is_demo' => 1,
]);

Store::write('teachers', [
    ['id' => 'tea_4b_fixture', 'firstName' => 'Fixture', 'lastName' => 'Teacher', 'subject' => 'Mathematics', 'status' => 'active', 'staffNo' => 'S4B-T001'],
], true);

Store::write('classes', [
    ['id' => 'cls_fixture', 'name' => 'Grade 9', 'level' => 9, 'academicYear' => '2026', 'term' => '1', 'teacherId' => 'tea_4b_fixture', 'teacherName' => 'Fixture Teacher', 'subjects' => [], 'status' => 'active'],
], true);

$fixtures = [
    'attendance' => [
        ['id' => 't_att_1', 'studentId' => 'stu_4b_fixture', 'className' => 'Grade 9', 'date' => '2026-01-06', 'status' => 'present'],
        ['id' => 't_att_2', 'studentId' => 'stu_4b_fixture', 'className' => 'Grade 9', 'date' => '2026-01-07', 'status' => 'absent'],
    ],
    'auditLog' => [
        ['id' => 't_aud_1', 'action' => 'test.fixture', 'detail' => 'Stage 4B fixture', 'at' => '2026-01-01T00:00:00Z'],
    ],
    'classAssignments' => [
        ['id' => 't_ca_1', 'classId' => 'cls_fixture', 'className' => 'Grade 9', 'teacherId' => 'tea_4b_fixture', 'teacherName' => 'Fixture Teacher', 'assignedAt' => '2026-01-06'],
    ],
    'classFeeStructures' => [
        ['id' => 't_cfs_1', 'className' => 'Grade 9', 'year' => '2026', 'tuition' => 45000, 'transport' => 12000],
    ],
    'examResults' => [
        ['id' => 't_er_1', 'examId' => 't_ex_1', 'examTitle' => 'Maths Test', 'studentId' => 'stu_4b_fixture', 'score' => 18, 'maxMarks' => 20],
    ],
    'exams' => [
        ['id' => 't_ex_1', 'title' => 'Maths Test', 'className' => 'Grade 9', 'type' => 'Class exam', 'questions' => [['question' => '1+1?', 'answer' => '2']]],
    ],
    'examSchedule' => [
        ['id' => 't_es_1', 'examId' => 't_ex_1', 'examTitle' => 'Maths Test', 'className' => 'Grade 9', 'date' => '2026-02-02', 'startTime' => '08:00', 'room' => 'Room 4'],
    ],
    'feeCharges' => [
        ['id' => 't_fc_1', 'studentId' => 'stu_4b_fixture', 'studentName' => 'Fixture Student', 'item' => 'Tuition', 'amount' => 45000, 'year' => '2026', 'term' => '1'],
    ],
    'feeItems' => [
        ['id' => 't_fi_1', 'name' => 'Tuition', 'amount' => 45000, 'category' => 'tuition', 'year' => '2026'],
    ],
    'feeNotificationLog' => [
        ['id' => 't_fnl_1', 'channel' => 'portal', 'status' => 'sent', 'studentId' => 'stu_4b_fixture', 'sentAt' => '2026-01-02T00:00:00Z'],
    ],
    'homework' => [
        ['id' => 't_hw_1', 'classId' => 'cls_001', 'className' => 'Grade 9', 'title' => 'Chapter 3 exercises', 'subject' => 'Mathematics', 'dueDate' => '2026-01-10'],
    ],
    'homeworkSubmissions' => [
        ['id' => 't_hs_1', 'homeworkId' => 't_hw_1', 'studentId' => 'stu_4b_fixture', 'content' => 'Completed', 'submittedAt' => '2026-01-09T00:00:00Z'],
    ],
    'invCounters' => ['nextInvoice' => 12, 'nextOrder' => 5, 'nextSupplier' => 8],
    'invItems' => [
        ['id' => 't_ii_1', 'name' => 'Exercise books', 'sku' => 'BK-001', 'quantity' => 150, 'reorderLevel' => 25, 'unit' => 'pcs'],
        ['id' => 't_ii_2', 'name' => 'Chalk', 'sku' => 'CH-001', 'quantity' => 40, 'reorderLevel' => 10, 'unit' => 'boxes'],
    ],
    'invMovements' => [
        ['id' => 't_im_1', 'itemId' => 't_ii_1', 'type' => 'in', 'quantity' => 200, 'date' => '2026-01-02', 'reference' => 'Supplier delivery'],
    ],
    'invOrders' => [
        ['id' => 't_io_1', 'items' => [['itemId' => 't_ii_1', 'quantity' => 200]], 'total' => 30000, 'status' => 'delivered', 'supplierId' => 't_is_1'],
    ],
    'invRequests' => [
        ['id' => 't_ir_1', 'itemId' => 't_ii_1', 'itemName' => 'Exercise books', 'quantity' => 20, 'status' => 'pending', 'requestedBy' => 'Store'],
    ],
    'invSuppliers' => [
        ['id' => 't_is_1', 'name' => 'S&S Stationers', 'phone' => '0712345678', 'email' => 'orders@stationers.test'],
    ],
    'invTransfers' => [
        ['id' => 't_it_1', 'itemId' => 't_ii_1', 'itemName' => 'Exercise books', 'quantity' => 25, 'from' => 'Store', 'to' => 'Kitchen', 'date' => '2026-01-03'],
    ],
    'materials' => [
        ['id' => 't_ma_1', 'title' => 'Grade 9 Mathematics Notes', 'className' => 'Grade 9', 'subject' => 'Mathematics', 'type' => 'PDF', 'url' => 'https://files.stteresa.test/math-notes.pdf'],
    ],
    'messageLog' => [
        ['id' => 't_msg_1', 'channel' => 'portal', 'to' => 'all', 'subject' => 'Term begins', 'status' => 'sent', 'sentAt' => '2026-01-02T00:00:00Z'],
    ],
    'notifications' => [
        ['id' => 't_ntf_1', 'userId' => 'seed-admin', 'title' => 'Welcome', 'body' => 'Welcome to Stage 4B', 'audience' => 'staff', 'readAt' => ''],
    ],
    'notificationSettings' => ['sms' => false, 'email' => false, 'portal' => true, 'defaultAudience' => 'portal'],
    'parents' => [
        ['id' => 't_par_1', 'name' => 'Sam Parent', 'phone' => '0700000000', 'email' => 'parent@example.test', 'childrenIds' => ['stu_4b_fixture']],
    ],
    'payments' => [
        ['id' => 't_pay_1', 'receiptNo' => 'RCP-9001', 'studentId' => 'stu_4b_fixture', 'studentName' => 'Fixture Student', 'amount' => 4200, 'item' => 'Tuition', 'method' => 'Cash', 'date' => '2026-01-05'],
    ],
    'reportCards' => [
        ['id' => 't_rc_1', 'studentId' => 'stu_4b_fixture', 'studentName' => 'Fixture Student', 'term' => '1', 'year' => '2026', 'grades' => ['Mathematics' => 'A']],
    ],
    'studentTransfers' => [
        ['id' => 't_st_1', 'studentId' => 'stu_4b_fixture', 'action' => 'transfer-in', 'byName' => 'secretary', 'at' => '2026-01-04T00:00:00Z'],
    ],
    'subCounters' => ['exam_marking' => 7, 'approvals' => 3],
    'submissions' => [
        ['id' => 't_sub_1', 'examId' => 't_ex_1', 'studentId' => 'stu_4b_fixture', 'answers' => [['question' => '1+1?', 'answer' => '2']], 'submittedAt' => '2026-02-02T09:00:00Z'],
    ],
    'timetable' => [
        ['id' => 't_tt_1', 'classId' => 'cls_001', 'className' => 'Grade 9', 'subject' => 'Mathematics', 'teacherId' => 'tea_001', 'day' => 'Monday', 'period' => 2, 'startTime' => '09:00', 'endTime' => '09:40'],
        ['id' => 't_tt_2', 'classId' => 'cls_001', 'className' => 'Grade 9', 'subject' => 'English', 'teacherId' => 'tea_001', 'day' => 'Tuesday', 'period' => 2, 'startTime' => '09:00', 'endTime' => '09:40'],
    ],
    'ttArchive' => [
        ['id' => 't_ta_1', 'archivedAt' => '2026-01-01T00:00:00Z', 'name' => 'Term 1 2026 archive', 'entries' => []],
    ],
    'ttClasses' => [
        ['id' => 't_tc_1', 'name' => 'Grade 9', 'level' => 9, 'academicYear' => '2026', 'createdBy' => 'admin'],
    ],
    'ttClassrooms' => [
        ['id' => 't_troom_1', 'name' => 'Room 4', 'capacity' => 35, 'location' => 'Block A'],
    ],
    'ttConfig' => ['periodsPerDay' => 8, 'saturday' => false, 'autoAssign' => true, 'allowDoublePeriods' => true],
    'ttConstraints' => ['tea_001' => ['blocked' => ['Monday-1']], 'tea_002' => ['blocked' => []]],
    'ttDivisions' => [
        ['id' => 't_tdiv_1', 'name' => 'A', 'className' => 'Grade 9', 'capacity' => 35],
        ['id' => 't_tdiv_2', 'name' => 'B', 'className' => 'Grade 9', 'capacity' => 34],
    ],
    'ttSubjects' => [
        ['id' => 't_tsbj_1', 'name' => 'Mathematics', 'code' => 'MATH', 'weeklyLessons' => 6],
        ['id' => 't_tsbj_2', 'name' => 'English', 'code' => 'ENG', 'weeklyLessons' => 5],
    ],
    'ttTeachers' => [
        ['id' => 't_ttea_1', 'userId' => 'seed-teacher', 'name' => 'Margaret OBrien', 'subjects' => ['Mathematics'], 'classes' => ['Grade 9']],
    ],
];

/* -----------------------------------------------------------------
 * 1. CREATE + READ + IDEMPOTENCY
 * ----------------------------------------------------------------- */
foreach ($fixtures as $domain => $fixture) {
    $result = Store::write($domain, $fixture, true);
    $expected = array_is_list($fixture) ? count($fixture) : 1;

    check(
        "write {$domain}",
        $result['written'] === $expected,
        'written=' . $result['written'] . ' expected=' . $expected
    );

    $before = Store::read($domain);
    $beforeCount = count($before ?? []);

    Store::write($domain, $fixture, true);

    $after = Store::read($domain);

    check("re-importing {$domain} does not duplicate records", count($after ?? []) === $beforeCount, 'record count changed from ' . $beforeCount . ' to ' . count($after ?? []));
}

/* -----------------------------------------------------------------
 * 2. RECORD FIDELITY
 * ----------------------------------------------------------------- */
$attendance = Store::read('attendance');
$first = null;

foreach ($attendance as $record) {
    if (($record['id'] ?? '') === 't_att_1') {
        $first = $record;
        break;
    }
}

check('attendance keeps every original field', $first !== null && $first == $fixtures['attendance'][0]);
check('exams keep their nested questions', ($exams = Store::read('exams')) !== null && ($exams[0]['questions'][0]['answer'] ?? '') === '2');
check('timetable round-trips both lessons', count(Store::read('timetable')) === 2);
check('payments round-trip', count(Store::read('payments')) === 1);
$parents = Store::read('parents');
check('parents keep their children list', is_array($parents) && is_array($parents[0]['childrenIds'] ?? null) && $parents[0]['childrenIds'] === ['stu_4b_fixture']);

/* -----------------------------------------------------------------
 * 3. DOCUMENT DOMAINS (single object, not a list)
 * ----------------------------------------------------------------- */
$documentDomains = ['invCounters', 'notificationSettings', 'subCounters', 'ttConfig', 'ttConstraints'];

foreach ($documentDomains as $domain) {
    $read = Store::read($domain);
    check("document domain {$domain} reads back identically", $read == $fixtures[$domain]);

    Store::write($domain, (array) $fixtures[$domain], true);
    check("document domain {$domain} is not duplicated", count((array) Store::read($domain)) === count((array) $fixtures[$domain]));
}

/* -----------------------------------------------------------------
 * 4. SOFT DELETE
 * ----------------------------------------------------------------- */
$result = Store::delete('attendance', 't_att_2');
$remaining = Store::read('attendance');
$rows = (int) Database::value('SELECT COUNT(*) FROM domain_attendance');

check('soft delete reports success', ($result['ok'] ?? false) === true);
check('the deleted record disappears from reads', count($remaining) === 1, 'live=' . count($remaining));
check('the deleted record is kept in the table', $rows === 2, 'rows=' . $rows);

$missing = Store::delete('attendance', 'no_such_record');
check('deleting a missing record is refused', ($missing['ok'] ?? true) === false);

/* -----------------------------------------------------------------
 * 5. CREATE + UPDATE
 * ----------------------------------------------------------------- */
$created = Store::create('feeItems', ['id' => 't_fi_2', 'name' => 'Transport', 'amount' => 12000, 'category' => 'transport']);
check('create returns ok', ($created['ok'] ?? false) === true, json_encode($created));

$created = Store::create('feeItems', ['id' => 't_fi_2', 'name' => 'Transport', 'amount' => 12000]);
check('create refuses a duplicate id', ($created['ok'] ?? true) === false);

$updated = Store::update('feeItems', 't_fi_2', ['amount' => 15000]);
check('update returns ok', ($updated['ok'] ?? false) === true);

$items = Store::read('feeItems');
$target = null;

foreach ($items as $item) {
    if (($item['id'] ?? '') === 't_fi_2') {
        $target = $item;
        break;
    }
}

check('update changed the amount', ($target['amount'] ?? 0) === 15000, var_export($target['amount'] ?? null, true));
check('update kept the other fields', ($target['name'] ?? '') === 'Transport');

/* -----------------------------------------------------------------
 * 6. RELATIONSHIP REPORT (nothing dangling for imported fixtures)
 * ----------------------------------------------------------------- */
$relations = Store::relationshipReport();
$students = (int) Database::value('SELECT COUNT(*) FROM students WHERE legacy_id = ?', ['stu_4b_fixture']);
check('the fixture student is in MySQL', $students === 1, 'rows=' . $students);

foreach ($relations as $label => $count) {
    check("relationship {$label} is complete", $count === 0, 'orphans=' . $count);
}

/* -----------------------------------------------------------------
 * 7. CLEANUP (throwaway database)
 * ----------------------------------------------------------------- */
foreach ($tables4b as $table) {
    Database::execute("DELETE FROM `{$table}`");
}

Database::execute("DELETE FROM students WHERE legacy_id = ?", ['stu_4b_fixture']);
Database::execute("DELETE FROM staff WHERE legacy_id = 'tea_4b_fixture'");
Database::execute("DELETE FROM classes WHERE legacy_id = 'cls_fixture'");
Database::execute("DELETE FROM users WHERE legacy_id IN ('stu_4b_fixture', 'tea_4b_fixture')");
Database::execute("UPDATE domain_state SET migrated_at = NULL, record_count = 0 WHERE domain_key NOT IN ('students', 'teachers', 'classes', 'academicYears', 'leadership', 'slider', 'announcements', 'settings', 'logo')");

echo "\n" . str_repeat('-', 60) . "\n";
echo "Result: {$passed} passed, {$failed} failed\n";

exit($failed === 0 ? 0 : 1);
