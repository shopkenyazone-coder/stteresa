<?php
/**
 * Secure CRUD API for the domains that now live in MySQL (Stage 4A).
 *
 *   GET  api/domain.php?domain=students[&id=…]
 *        -> { ok, domain, records }  (or { ok, domain, record })
 *
 *   POST api/domain.php?domain=students
 *        body: { "op": "create" | "update" | "delete",
 *                "id": "…", "record": { … } }
 *        header: X-CSRF-Token
 *
 * Rules:
 *   * a signed-in session is required,
 *   * every write needs a valid CSRF token,
 *   * each domain has its own read / write / delete permissions,
 *   * a student may only ever read their own student record,
 *   * deletes are soft, so nothing is destroyed.
 *
 * PHP 8.1+
 */

declare(strict_types=1);

require __DIR__ . '/../src/bootstrap.php';

use STA\Auth;
use STA\Csrf;
use STA\Response;
use STA\Store;

ini_set('display_errors', '0');
header('X-Content-Type-Options: nosniff');
header('Cache-Control: no-store, private');

const DOMAIN_PERMISSIONS = [
    'students'      => [
        'read'   => ['admin', 'headteacher', 'secretary', 'teacher', 'chiefexaminer'],
        'write'  => ['admin', 'secretary'],
        'delete' => ['admin', 'secretary'],
    ],
    'teachers'      => [
        'read'   => ['admin', 'headteacher', 'chiefexaminer'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'classes'       => [
        'read'   => ['admin', 'headteacher', 'secretary', 'teacher'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'academicYears' => [
        'read'   => ['admin', 'headteacher', 'secretary', 'teacher', 'chiefexaminer'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'leadership'    => [
        'read'   => ['admin', 'headteacher', 'secretary', 'teacher', 'chiefexaminer'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'slider'        => [
        'read'   => ['admin', 'headteacher', 'secretary', 'teacher', 'chiefexaminer'],
        'write'  => ['admin'],
        'delete' => ['admin'],
    ],
    'announcements' => [
        'read'   => ['admin', 'headteacher', 'secretary', 'teacher', 'chiefexaminer'],
        'write'  => ['admin', 'headteacher', 'teacher'],
        'delete' => ['admin'],
    ],
    'settings'      => [
        'read'   => ['admin', 'headteacher', 'secretary'],
        'write'  => ['admin'],
        'delete' => ['admin'],
    ],
    'logo'          => [
        'read'   => ['admin', 'headteacher', 'secretary'],
        'write'  => ['admin'],
        'delete' => ['admin'],
    ],
    /* Stage 4B domain families (staff-only, by design) */
    'attendance' => [
        'read'   => ['admin', 'headteacher', 'teacher', 'secretary'],
        'write'  => ['admin', 'headteacher', 'teacher'],
        'delete' => ['admin'],
    ],
    'homework' => [
        'read'   => ['admin', 'headteacher', 'teacher', 'secretary'],
        'write'  => ['admin', 'headteacher', 'teacher'],
        'delete' => ['admin'],
    ],
    'homeworkSubmissions' => [
        'read'   => ['admin', 'headteacher', 'teacher'],
        'write'  => ['admin', 'headteacher', 'teacher'],
        'delete' => ['admin'],
    ],
    'submissions' => [
        'read'   => ['admin', 'headteacher', 'chiefexaminer', 'teacher'],
        'write'  => ['admin', 'headteacher', 'chiefexaminer', 'teacher'],
        'delete' => ['admin'],
    ],
    'materials' => [
        'read'   => ['admin', 'headteacher', 'teacher'],
        'write'  => ['admin', 'headteacher', 'teacher'],
        'delete' => ['admin'],
    ],
    'exams' => [
        'read'   => ['admin', 'headteacher', 'chiefexaminer', 'teacher', 'secretary'],
        'write'  => ['admin', 'headteacher', 'chiefexaminer', 'teacher', 'secretary'],
        'delete' => ['admin', 'headteacher'],
    ],
    'examSchedule' => [
        'read'   => ['admin', 'headteacher', 'chiefexaminer', 'teacher', 'secretary'],
        'write'  => ['admin', 'headteacher', 'chiefexaminer', 'teacher', 'secretary'],
        'delete' => ['admin', 'headteacher'],
    ],
    'examResults' => [
        'read'   => ['admin', 'headteacher', 'chiefexaminer', 'teacher', 'secretary'],
        'write'  => ['admin', 'headteacher', 'chiefexaminer', 'teacher', 'secretary'],
        'delete' => ['admin', 'headteacher'],
    ],
    'payments' => [
        'read'   => ['admin', 'headteacher', 'secretary'],
        'write'  => ['admin', 'secretary'],
        'delete' => ['admin'],
    ],
    'feeCharges' => [
        'read'   => ['admin', 'headteacher', 'secretary'],
        'write'  => ['admin', 'secretary'],
        'delete' => ['admin'],
    ],
    'feeItems' => [
        'read'   => ['admin', 'headteacher', 'secretary'],
        'write'  => ['admin', 'secretary'],
        'delete' => ['admin'],
    ],
    'feeNotificationLog' => [
        'read'   => ['admin', 'headteacher', 'secretary'],
        'write'  => ['admin', 'headteacher', 'secretary'],
        'delete' => ['admin'],
    ],
    'classFeeStructures' => [
        'read'   => ['admin', 'headteacher', 'secretary'],
        'write'  => ['admin', 'secretary'],
        'delete' => ['admin'],
    ],
    'classAssignments' => [
        'read'   => ['admin', 'headteacher', 'teacher', 'secretary'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'timetable' => [
        'read'   => ['admin', 'headteacher', 'teacher'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'ttArchive' => [
        'read'   => ['admin', 'headteacher'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'ttClasses' => [
        'read'   => ['admin', 'headteacher', 'teacher'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'ttClassrooms' => [
        'read'   => ['admin', 'headteacher'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'ttConfig' => [
        'read'   => ['admin', 'headteacher'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'ttConstraints' => [
        'read'   => ['admin', 'headteacher'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'ttDivisions' => [
        'read'   => ['admin', 'headteacher', 'teacher'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'ttSubjects' => [
        'read'   => ['admin', 'headteacher', 'teacher'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'ttTeachers' => [
        'read'   => ['admin', 'headteacher'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'invCounters' => [
        'read'   => ['admin', 'headteacher', 'storekeeper'],
        'write'  => ['admin', 'headteacher', 'storekeeper'],
        'delete' => ['admin'],
    ],
    'invItems' => [
        'read'   => ['admin', 'headteacher', 'storekeeper', 'kitchenmanager'],
        'write'  => ['admin', 'headteacher', 'storekeeper'],
        'delete' => ['admin'],
    ],
    'invMovements' => [
        'read'   => ['admin', 'headteacher', 'storekeeper', 'kitchenmanager'],
        'write'  => ['admin', 'headteacher', 'storekeeper'],
        'delete' => ['admin'],
    ],
    'invOrders' => [
        'read'   => ['admin', 'headteacher', 'storekeeper'],
        'write'  => ['admin', 'headteacher', 'storekeeper'],
        'delete' => ['admin'],
    ],
    'invRequests' => [
        'read'   => ['admin', 'headteacher', 'storekeeper', 'kitchenmanager'],
        'write'  => ['admin', 'headteacher', 'storekeeper', 'kitchenmanager'],
        'delete' => ['admin'],
    ],
    'invSuppliers' => [
        'read'   => ['admin', 'headteacher', 'storekeeper'],
        'write'  => ['admin', 'headteacher', 'storekeeper'],
        'delete' => ['admin'],
    ],
    'invTransfers' => [
        'read'   => ['admin', 'headteacher', 'storekeeper'],
        'write'  => ['admin', 'headteacher', 'storekeeper'],
        'delete' => ['admin'],
    ],
    'notifications' => [
        'read'   => ['admin', 'headteacher', 'secretary', 'teacher'],
        'write'  => ['admin', 'headteacher', 'secretary', 'teacher'],
        'delete' => ['admin'],
    ],
    'notificationSettings' => [
        'read'   => ['admin', 'headteacher', 'secretary'],
        'write'  => ['admin', 'headteacher'],
        'delete' => ['admin'],
    ],
    'messageLog' => [
        'read'   => ['admin', 'headteacher', 'secretary'],
        'write'  => ['admin', 'headteacher', 'secretary'],
        'delete' => ['admin'],
    ],
    'parents' => [
        'read'   => ['admin', 'headteacher', 'secretary', 'teacher'],
        'write'  => ['admin', 'secretary'],
        'delete' => ['admin'],
    ],
    'studentTransfers' => [
        'read'   => ['admin', 'headteacher', 'secretary', 'teacher'],
        'write'  => ['admin', 'headteacher', 'secretary'],
        'delete' => ['admin'],
    ],
    'reportCards' => [
        'read'   => ['admin', 'headteacher', 'secretary', 'teacher'],
        'write'  => ['admin', 'headteacher', 'secretary', 'teacher'],
        'delete' => ['admin'],
    ],
    'auditLog' => [
        'read'   => ['admin'],
        'write'  => ['admin'],
        'delete' => ['admin'],
    ],
    'subCounters' => [
        'read'   => ['admin', 'headteacher', 'secretary', 'teacher'],
        'write'  => ['admin', 'headteacher', 'secretary', 'teacher'],
        'delete' => ['admin'],
    ],
];

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
$domain = isset($_GET['domain']) && is_string($_GET['domain']) ? trim($_GET['domain']) : '';

if (!isset(DOMAIN_PERMISSIONS[$domain]) || Store::spec($domain) === null) {
    Response::json(['ok' => false, 'error' => 'Unknown domain.'], 400);
}

$user = Auth::requireUser([], true);
$role = (string) $user['role'];
$permissions = DOMAIN_PERMISSIONS[$domain];

$canRead = in_array($role, $permissions['read'], true);
$canWrite = in_array($role, $permissions['write'], true);
$canDelete = in_array($role, $permissions['delete'], true);

/* A student account may only read its own student record. */
$isStudent = $role === 'student';
$ownStudentId = (string) ($user['legacy_id'] ?? '');

if ($method === 'GET') {
    if (!$canRead && !($isStudent && $domain === 'students')) {
        Response::json(['ok' => false, 'error' => 'You do not have permission to view this.'], 403);
    }

    $id = isset($_GET['id']) && is_string($_GET['id']) ? trim($_GET['id']) : '';

    if ($id !== '') {
        $records = Store::read($domain);
        $found = null;

        if (is_array($records)) {
            foreach ($records as $record) {
                if (is_array($record) && (string) ($record['id'] ?? '') === $id) {
                    $found = $record;
                    break;
                }
            }
        }

        if ($isStudent && $domain === 'students' && $id !== $ownStudentId) {
            Response::json(['ok' => false, 'error' => 'You may only view your own record.'], 403);
        }

        if ($found === null) {
            Response::json(['ok' => false, 'error' => 'Record not found.'], 404);
        }

        Response::json(['ok' => true, 'domain' => $domain, 'record' => $found]);
    }

    if ($isStudent && $domain === 'students') {
        $records = Store::read($domain);
        $own = [];

        if (is_array($records)) {
            foreach ($records as $record) {
                if (is_array($record) && (string) ($record['id'] ?? '') === $ownStudentId) {
                    $own[] = $record;
                }
            }
        }

        Response::json(['ok' => true, 'domain' => $domain, 'records' => $own]);
    }

    $records = Store::read($domain);

    Response::json([
        'ok'       => true,
        'domain'   => $domain,
        'records'  => is_array($records) ? $records : [],
        'count'    => is_array($records) ? count($records) : 0,
    ]);
}

if ($method === 'POST') {
    $op = isset($_POST['op']) && is_string($_POST['op']) ? trim($_POST['op']) : '';

    /* JSON bodies are accepted too, for the browser API. */
    $body = sta_json_body();
    $raw = file_get_contents('php://input');
    $raw = $raw === false ? '' : $raw;

    if ($raw !== '' && strlen($raw) > 2 * 1024 * 1024) {
        Response::json(['ok' => false, 'error' => 'The request is too large.'], 413);
    }

    if ($body !== []) {
        $op = isset($body['op']) && is_string($body['op']) ? $body['op'] : $op;
    }

    $token = sta_json_header_token();

    if ($token === '' && isset($_POST['csrf_token']) && is_string($_POST['csrf_token'])) {
        $token = $_POST['csrf_token'];
    }

    Csrf::requireValid($token);

    if (!in_array($op, ['create', 'update', 'delete'], true)) {
        Response::json(['ok' => false, 'error' => 'Unknown operation.'], 400);
    }

    if ($op === 'delete' && !$canDelete) {
        Response::json(['ok' => false, 'error' => 'You do not have permission to delete this.'], 403);
    }

    if ($op !== 'delete' && !$canWrite) {
        Response::json(['ok' => false, 'error' => 'You do not have permission to change this.'], 403);
    }

    $record = [];

    if (isset($body['record']) && is_array($body['record'])) {
        $record = $body['record'];
    } elseif (isset($_POST['record']) && is_string($_POST['record'])) {
        $decoded = json_decode($_POST['record'], true);
        $record = is_array($decoded) ? $decoded : [];
    }

    $id = '';

    if (isset($body['id']) && is_string($body['id'])) {
        $id = trim($body['id']);
    } elseif (isset($_POST['id']) && is_string($_POST['id'])) {
        $id = trim($_POST['id']);
    } elseif (isset($record['id']) && is_string($record['id'])) {
        $id = trim($record['id']);
    }

    if ($op === 'create') {
        $result = Store::create($domain, $record);

        if (!$result['ok']) {
            Response::json(['ok' => false, 'error' => $result['error'] ?? 'Could not create the record.'], 400);
        }

        Auth::audit('domain.create', $domain . ' ' . ($result['id'] ?? ''), (int) $user['id']);

        Response::json(['ok' => true, 'domain' => $domain, 'id' => $result['id'] ?? null, 'record' => $record]);
    }

    if ($op === 'update') {
        if ($id === '') {
            Response::json(['ok' => false, 'error' => 'A record id is required.'], 400);
        }

        $result = Store::update($domain, $id, $record);

        if (!$result['ok']) {
            Response::json(['ok' => false, 'error' => $result['error'] ?? 'Could not update the record.'], 404);
        }

        Auth::audit('domain.update', $domain . ' ' . $id, (int) $user['id']);

        Response::json(['ok' => true, 'domain' => $domain, 'id' => $id]);
    }

    $result = Store::delete($domain, $id);

    if (!$result['ok']) {
        Response::json(['ok' => false, 'error' => $result['error'] ?? 'Could not delete the record.'], 404);
    }

    Auth::audit('domain.delete', $domain . ' ' . $id, (int) $user['id']);

    Response::json(['ok' => true, 'domain' => $domain, 'id' => $id, 'deleted' => true]);
}

Response::json(['ok' => false, 'error' => 'Method not allowed.'], 405);
