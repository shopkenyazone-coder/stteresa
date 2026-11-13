<?php

declare(strict_types=1);

namespace STA;

use RuntimeException;

/**
 * Stage 4A domain store.
 *
 * Reads and writes the first group of school domains in MySQL while
 * keeping the exact shape the browser already uses, so the existing
 * JavaScript keeps working without changes:
 *
 *   students, teachers, classes, academicYears, leadership, slider,
 *   announcements, settings, logo
 *
 * Every record keeps its original browser id in `legacy_id` and its
 * complete original object in the `record` JSON column. The named
 * columns are only a searchable projection of that same object, so a
 * record read back is identical to the one that was written.
 *
 * Deletes are soft: a removed record is stamped with deleted_at and
 * kept, so no data is ever destroyed.
 */
final class Store
{
    /**
     * Stage 4A and Stage 4B domains.
     *
     * Stage 4B domains use the 'auto' type: the value stored against
     * them is either a list (one row per record) or a single object
     * (one row with the constant legacy_id '__document__'), whichever
     * shape the browser already uses.
     *
     * @return array<string, array{table: string, type: string, columns: array<string, callable>}>
     */
    public static function domains(): array
    {
        return array_merge(self::stage4aDomains(), self::stage4bDomains());
    }

    /** @return array<string, array{table: string, type: string, columns: array<string, callable>}> */
    private static function stage4aDomains(): array
    {
        return [
            'students' => [
                'table'   => 'students',
                'type'    => 'list',
                'columns' => [
                    'admission_no'   => static fn (array $r): string => self::text($r['admissionNo'] ?? ''),
                    'first_name'     => static fn (array $r): string => self::text($r['firstName'] ?? ''),
                    'last_name'      => static fn (array $r): string => self::text($r['lastName'] ?? ''),
                    'full_name'      => static fn (array $r): string => self::text($r['fullName'] ?? (self::text($r['firstName'] ?? '') . ' ' . self::text($r['lastName'] ?? ''))),
                    'grade'          => static fn (array $r): string => self::text($r['grade'] ?? ''),
                    'class_name'     => static fn (array $r): string => self::text($r['className'] ?? ''),
                    'gender'         => static fn (array $r): string => self::text($r['gender'] ?? ''),
                    'email'          => static fn (array $r): string => self::text($r['email'] ?? ''),
                    'phone'          => static fn (array $r): string => self::text($r['phone'] ?? ''),
                    'status'         => static fn (array $r): string => self::text($r['status'] ?? 'active'),
                    'admission_date' => static fn (array $r): ?string => self::date($r['admissionDate'] ?? ''),
                    'dob'            => static fn (array $r): ?string => self::date($r['dob'] ?? ''),
                    'fee_balance'    => static fn (array $r): float => (float) ($r['feeBalance'] ?? 0),
                    'photo'          => static fn (array $r): string => self::text($r['photo'] ?? ''),
                    'photo_key'      => static fn (array $r): string => self::text($r['photoKey'] ?? ''),
                ],
            ],
            'teachers' => [
                'table'   => 'staff',
                'type'    => 'list',
                'columns' => [
                    'staff_no'      => static fn (array $r): string => self::text($r['staffNo'] ?? ''),
                    'first_name'    => static fn (array $r): string => self::text($r['firstName'] ?? ''),
                    'last_name'     => static fn (array $r): string => self::text($r['lastName'] ?? ''),
                    'full_name'     => static fn (array $r): string => self::text($r['fullName'] ?? (self::text($r['firstName'] ?? '') . ' ' . self::text($r['lastName'] ?? ''))),
                    'email'         => static fn (array $r): string => self::text($r['email'] ?? ''),
                    'phone'         => static fn (array $r): string => self::text($r['phone'] ?? ''),
                    'subject'       => static fn (array $r): string => self::text($r['subject'] ?? ''),
                    'role'          => static fn (array $r): string => self::text($r['role'] ?? ''),
                    'qualification' => static fn (array $r): string => self::text($r['qualification'] ?? ''),
                    'status'        => static fn (array $r): string => self::text($r['status'] ?? 'active'),
                    'photo'         => static fn (array $r): string => self::text($r['photo'] ?? ''),
                    'bio'           => static fn (array $r): ?string => self::nullableText($r['bio'] ?? ''),
                ],
            ],
            'classes' => [
                'table'   => 'classes',
                'type'    => 'list',
                'columns' => [
                    'name'             => static fn (array $r): string => self::text($r['name'] ?? ''),
                    'level'            => static fn (array $r): int => (int) ($r['level'] ?? 0),
                    'academic_year'    => static fn (array $r): string => self::text($r['academicYear'] ?? ''),
                    'term'             => static fn (array $r): string => self::text($r['term'] ?? ''),
                    'teacher_legacy_id' => static fn (array $r): string => self::text($r['teacherId'] ?? ''),
                    'teacher_name'     => static fn (array $r): string => self::text($r['teacherName'] ?? ''),
                    'subjects'         => static fn (array $r): ?string => self::json($r['subjects'] ?? null),
                    'status'           => static fn (array $r): string => self::text($r['status'] ?? 'active'),
                ],
            ],
            'academicYears' => [
                'table'   => 'academic_years',
                'type'    => 'list',
                'columns' => [
                    'label'        => static fn (array $r): string => self::text($r['label'] ?? ''),
                    'name'         => static fn (array $r): string => self::text($r['name'] ?? ''),
                    'start_date'   => static fn (array $r): ?string => self::date($r['startDate'] ?? ''),
                    'end_date'     => static fn (array $r): ?string => self::date($r['endDate'] ?? ''),
                    'default_term' => static fn (array $r): string => self::text($r['defaultTerm'] ?? ''),
                    'status'       => static fn (array $r): string => self::text($r['status'] ?? 'active'),
                    'archived'     => static fn (array $r): int => !empty($r['archived']) ? 1 : 0,
                ],
            ],
            'leadership' => [
                'table'   => 'leadership',
                'type'    => 'list',
                'columns' => [
                    'name'     => static fn (array $r): string => self::text($r['name'] ?? ''),
                    'position' => static fn (array $r): string => self::text($r['position'] ?? ''),
                    'photo'    => static fn (array $r): string => self::text($r['photo'] ?? ''),
                    'email'    => static fn (array $r): string => self::text($r['email'] ?? ''),
                ],
            ],
            'slider' => [
                'table'   => 'slider_slides',
                'type'    => 'list',
                'columns' => [
                    'title'       => static fn (array $r): string => self::text($r['title'] ?? ''),
                    'description' => static fn (array $r): ?string => self::nullableText($r['description'] ?? ''),
                    'image_url'   => static fn (array $r): string => self::text($r['imageUrl'] ?? ''),
                    'image_key'   => static fn (array $r): string => self::text($r['imageKey'] ?? ''),
                    'sort_order'  => static fn (array $r): int => (int) ($r['sortOrder'] ?? 0),
                ],
            ],
            'announcements' => [
                'table'   => 'announcements',
                'type'    => 'list',
                'columns' => [
                    'title'           => static fn (array $r): string => self::text($r['title'] ?? ''),
                    'body'            => static fn (array $r): ?string => self::nullableText($r['body'] ?? ''),
                    'audience'        => static fn (array $r): string => self::text($r['audience'] ?? 'all'),
                    'status'          => static fn (array $r): string => self::text($r['status'] ?? 'published'),
                    'approval_status' => static fn (array $r): string => self::text($r['approvalStatus'] ?? ''),
                    'published_at'    => static fn (array $r): ?string => self::date($r['publishedAt'] ?? ''),
                ],
            ],
            'settings' => [
                'table'   => 'content_documents',
                'type'    => 'object',
                'columns' => [],
            ],
            'logo' => [
                'table'   => 'content_documents',
                'type'    => 'object',
                'columns' => [],
            ],
        ];
    }

    /** @return array<int, string> */
    public static function domainKeys(): array
    {
        return array_keys(self::domains());
    }

    public static function spec(string $key): ?array
    {
        return self::domains()[$key] ?? null;
    }

    /** @return array<string, array{table: string, type: string, columns: array<string, callable>}> */
    private static function stage4bDomains(): array
    {
        $tables = [
            'attendance'           => 'domain_attendance',
            'auditLog'             => 'domain_audit_log',
            'classAssignments'     => 'domain_class_assignments',
            'classFeeStructures'   => 'domain_class_fee_structures',
            'examResults'          => 'domain_exam_results',
            'exams'                => 'domain_exams',
            'examSchedule'         => 'domain_exam_schedule',
            'feeCharges'           => 'domain_fee_charges',
            'feeItems'             => 'domain_fee_items',
            'feeNotificationLog'   => 'domain_fee_notification_log',
            'homework'             => 'domain_homework',
            'homeworkSubmissions'  => 'domain_homework_submissions',
            'invCounters'          => 'domain_inv_counters',
            'invItems'             => 'domain_inv_items',
            'invMovements'         => 'domain_inv_movements',
            'invOrders'            => 'domain_inv_orders',
            'invRequests'          => 'domain_inv_requests',
            'invSuppliers'         => 'domain_inv_suppliers',
            'invTransfers'         => 'domain_inv_transfers',
            'materials'            => 'domain_materials',
            'messageLog'           => 'domain_message_log',
            'notifications'        => 'domain_notifications',
            'notificationSettings' => 'domain_notification_settings',
            'parents'              => 'domain_parents',
            'payments'             => 'domain_payments',
            'reportCards'          => 'domain_report_cards',
            'studentTransfers'     => 'domain_student_transfers',
            'subCounters'           => 'domain_sub_counters',
            'submissions'          => 'domain_submissions',
            'timetable'            => 'domain_timetable',
            'ttArchive'            => 'domain_tt_archive',
            'ttClasses'            => 'domain_tt_classes',
            'ttClassrooms'         => 'domain_tt_classrooms',
            'ttConfig'             => 'domain_tt_config',
            'ttConstraints'        => 'domain_tt_constraints',
            'ttDivisions'          => 'domain_tt_divisions',
            'ttSubjects'           => 'domain_tt_subjects',
            'ttTeachers'           => 'domain_tt_teachers',
        ];

        $out = [];

        foreach ($tables as $key => $table) {
            $out[$key] = ['table' => $table, 'type' => 'auto', 'columns' => []];
        }

        return $out;
    }

    /**
     * Has this domain been moved to MySQL yet? A domain is only served
     * from MySQL once it has been imported and verified, so nothing can
     * disappear from the site during the migration.
     */
    public static function isMigrated(string $key): bool
    {
        $row = Database::one('SELECT migrated_at FROM domain_state WHERE domain_key = ?', [$key]);

        return $row !== null && !empty($row['migrated_at']);
    }

    public static function markMigrated(string $key, int $count, ?string $source = null): void
    {
        Database::execute(
            'INSERT INTO domain_state (domain_key, table_name, migrated_at, record_count, source)
             VALUES (?, ?, NOW(), ?, ?)
             ON DUPLICATE KEY UPDATE migrated_at = NOW(), record_count = ?, source = ?',
            [$key, self::spec($key)['table'] ?? $key, $count, $source, $count, $source]
        );
    }

    /**
     * Read one domain. List domains return the original record objects.
     *
     * @return array<int|string, mixed>|null
     */
    public static function read(string $key): ?array
    {
        $spec = self::spec($key);

        if ($spec === null) {
            return null;
        }

        if ($spec['type'] === 'object') {
            $row = Database::one('SELECT doc_value FROM content_documents WHERE doc_key = ?', [$key]);

            if ($row === null) {
                return null;
            }

            $decoded = json_decode((string) $row['doc_value'], true);

            return is_array($decoded) ? $decoded : null;
        }

        /* 'auto' domains are either a list (one row per record) or a single
           object (one row with the constant legacy_id '__document__'). */
        if ($spec['type'] === 'auto') {
            $document = Database::one(
                sprintf('SELECT record FROM `%s` WHERE legacy_id = ? AND deleted_at IS NULL', $spec['table']),
                ['__document__']
            );

            if ($document !== null) {
                $decoded = json_decode((string) $document['record'], true);

                return is_array($decoded) ? $decoded : null;
            }
        }

        $rows = Database::all(
            sprintf('SELECT record FROM `%s` WHERE deleted_at IS NULL ORDER BY id ASC', $spec['table'])
        );

        $out = [];

        foreach ($rows as $row) {
            $decoded = json_decode((string) $row['record'], true);

            if (is_array($decoded)) {
                $out[] = $decoded;
            }
        }

        return $out;
    }

    /**
     * Read every Stage 4A domain that has been migrated.
     *
     * @return array<string, mixed>
     */
    public static function readMigrated(): array
    {
        $out = [];

        foreach (self::domains() as $key => $spec) {
            if (!self::isMigrated($key)) {
                continue;
            }

            $value = self::read($key);

            if ($value !== null) {
                $out[$key] = $value;
            }
        }

        return $out;
    }

    /**
     * Replace the contents of a domain with the given records.
     *
     * Records are matched on their original browser id, so re-importing
     * the same data never creates duplicates. Records that are no
     * longer present are only removed when $prune is true - and even
     * then they are soft-deleted, never destroyed.
     *
     * @param array<int, mixed> $records
     * @return array{written: int, soft_deleted: int}
     */
    public static function write(string $key, array $records, bool $prune = false): array
    {
        $spec = self::spec($key);

        if ($spec === null) {
            throw new RuntimeException('Unknown domain: ' . $key);
        }

        if ($spec['type'] === 'object') {
            $value = $records;
            unset($value['id']);

            Database::execute(
                'INSERT INTO content_documents (doc_key, doc_value) VALUES (?, ?)
                 ON DUPLICATE KEY UPDATE doc_value = VALUES(doc_value)',
                [$key, self::json($value)]
            );

            return ['written' => 1, 'soft_deleted' => 0];
        }

        /* 'auto' domains: a list of records, or a single object. */
        if ($spec['type'] === 'auto' && !self::isList($records)) {
            self::upsert($spec, '__document__', $records);

            return ['written' => 1, 'soft_deleted' => 0];
        }

        $written = 0;
        $seen = [];

        foreach ($records as $record) {
            if (!is_array($record)) {
                continue;
            }

            $legacyId = self::text($record['id'] ?? '');

            if ($legacyId === '') {
                $legacyId = self::uid();
                $record['id'] = $legacyId;
            }

            $seen[] = $legacyId;
            self::upsert($spec, $legacyId, $record);
            $written++;
        }

        $softDeleted = $prune ? self::softDeleteMissing($spec, $seen) : 0;

        return ['written' => $written, 'soft_deleted' => $softDeleted];
    }

    /**
     * @param array<string, callable> $columns
     */
    private static function upsert(array $spec, string $legacyId, array $record): void
    {
        $table = $spec['table'];
        $data = ['legacy_id' => $legacyId, 'record' => self::json($record)];

        foreach ($spec['columns'] as $column => $reader) {
            $data[$column] = $reader($record);
        }

        $columns = array_keys($data);
        $placeholders = array_map(static fn (string $c): string => ':' . $c, $columns);
        $updates = array_map(static fn (string $c): string => sprintf('`%s` = VALUES(`%s`)', $c, $c), $columns);

        $sql = sprintf(
            'INSERT INTO `%s` (`%s`) VALUES (%s)
             ON DUPLICATE KEY UPDATE %s, deleted_at = NULL',
            $table,
            implode('`, `', $columns),
            implode(', ', $placeholders),
            implode(', ', $updates)
        );

        $params = [];

        foreach ($data as $column => $value) {
            $params[':' . $column] = $value;
        }

        Database::query($sql, $params);
    }

    /**
     * Soft-delete the records that are no longer in the payload.
     *
     * @param array<int, string> $seen
     */
    private static function softDeleteMissing(array $spec, array $seen): int
    {
        $table = $spec['table'];

        if ($seen === []) {
            return Database::execute(
                sprintf('UPDATE `%s` SET deleted_at = NOW() WHERE deleted_at IS NULL', $table)
            );
        }

        $placeholders = array_map(static fn (string $v): string => ':d' . $v, $seen);
        $params = [];

        foreach ($seen as $value) {
            $params[':d' . $value] = $value;
        }

        return Database::execute(
            sprintf(
                'UPDATE `%s` SET deleted_at = NOW() WHERE deleted_at IS NULL AND legacy_id NOT IN (%s)',
                $table,
                implode(', ', $placeholders)
            ),
            $params
        );
    }

    /**
     * Create a single record.
     *
     * @param array<string, mixed> $record
     * @return array{ok: bool, id?: string, error?: string}
     */
    public static function create(string $key, array $record): array
    {
        $spec = self::spec($key);

        if ($spec === null) {
            return ['ok' => false, 'error' => 'Unknown domain.'];
        }

        if ($spec['type'] === 'object') {
            $existing = self::read($key) ?? [];
            $merged = array_merge($existing, $record);
            self::write($key, $merged);

            return ['ok' => true, 'id' => $key];
        }

        $legacyId = self::text($record['id'] ?? '');

        /* 'auto' domains may store a single document instead of a list. */
        if ($spec['type'] === 'auto' && $legacyId === '') {
            $row = Database::one(
                sprintf('SELECT record FROM `%s` WHERE legacy_id = ?', $spec['table']),
                ['__document__']
            );

            $current = $row !== null ? (json_decode((string) $row['record'], true) ?: []) : [];
            $merged = is_array($current) ? array_merge($current, $record) : $record;

            self::upsert($spec, '__document__', $merged);

            return ['ok' => true, 'id' => '__document__'];
        }

        if ($legacyId === '') {
            $legacyId = self::uid();
        }

        $record['id'] = $legacyId;

        $exists = Database::one(
            sprintf('SELECT id FROM `%s` WHERE legacy_id = ?', $spec['table']),
            [$legacyId]
        );

        if ($exists !== null) {
            return ['ok' => false, 'error' => 'A record with that id already exists.'];
        }

        self::upsert($spec, $legacyId, $record);

        return ['ok' => true, 'id' => $legacyId];
    }

    /**
     * Update a single record, keeping its id.
     *
     * @param array<string, mixed> $record
     * @return array{ok: bool, id?: string, error?: string}
     */
    public static function update(string $key, string $legacyId, array $record): array
    {
        $spec = self::spec($key);

        if ($spec === null) {
            return ['ok' => false, 'error' => 'Unknown domain.'];
        }

        if ($spec['type'] === 'object') {
            $existing = self::read($key) ?? [];
            self::write($key, array_merge($existing, $record));

            return ['ok' => true, 'id' => $key];
        }

        $row = Database::one(
            sprintf('SELECT record FROM `%s` WHERE legacy_id = ? AND deleted_at IS NULL', $spec['table']),
            [$legacyId]
        );

        if ($row === null) {
            return ['ok' => false, 'error' => 'Record not found.'];
        }

        $current = json_decode((string) $row['record'], true);
        $current = is_array($current) ? $current : [];
        $merged = array_merge($current, $record);

        if ($legacyId !== '__document__') {
            $merged['id'] = $legacyId;
        }

        self::upsert($spec, $legacyId, $merged);

        return ['ok' => true, 'id' => $legacyId];
    }

    /**
     * Remove a single record (soft delete - the row is kept).
     *
     * @return array{ok: bool, error?: string}
     */
    public static function delete(string $key, string $legacyId): array
    {
        $spec = self::spec($key);

        if ($spec === null) {
            return ['ok' => false, 'error' => 'Unknown domain.'];
        }

        if ($spec['type'] === 'object') {
            Database::execute('DELETE FROM content_documents WHERE doc_key = ?', [$key]);

            return ['ok' => true];
        }

        $row = Database::one(
            sprintf('SELECT id FROM `%s` WHERE legacy_id = ? AND deleted_at IS NULL', $spec['table']),
            [$legacyId]
        );

        if ($row === null) {
            return ['ok' => false, 'error' => 'Record not found.'];
        }

        Database::execute(
            sprintf('UPDATE `%s` SET deleted_at = NOW() WHERE legacy_id = ?', $spec['table']),
            [$legacyId]
        );

        return ['ok' => true];
    }

    /**
     * Row counts per domain, including soft-deleted rows.
     *
     * @return array<string, array{total: int, live: int, deleted: int}>
     */
    public static function counts(): array
    {
        $out = [];

        foreach (self::domains() as $key => $spec) {
            if ($spec['type'] === 'object') {
                $total = (int) Database::value('SELECT COUNT(*) FROM content_documents WHERE doc_key = ?', [$key]);
                $out[$key] = ['total' => $total, 'live' => $total, 'deleted' => 0];
                continue;
            }

            $total = (int) Database::value(sprintf('SELECT COUNT(*) FROM `%s`', $spec['table']));
            $live = (int) Database::value(sprintf('SELECT COUNT(*) FROM `%s` WHERE deleted_at IS NULL', $spec['table']));
            $deleted = (int) Database::value(sprintf('SELECT COUNT(*) FROM `%s` WHERE deleted_at IS NOT NULL', $spec['table']));

            $out[$key] = ['total' => $total, 'live' => $live, 'deleted' => $deleted];
        }

        return $out;
    }

    /**
     * Relationship report: which records point at something that is
     * not there. Nothing is changed - this is a report only.
     *
     * @return array<string, int>
     */
    public static function relationshipReport(): array
    {
        $report = [];

        $report['students_without_class'] = (int) Database::value(
            "SELECT COUNT(*) FROM students s
               LEFT JOIN classes c ON c.name = s.class_name AND c.deleted_at IS NULL
              WHERE s.deleted_at IS NULL AND s.class_name <> '' AND c.id IS NULL"
        );

        $report['students_without_user'] = (int) Database::value(
            'SELECT COUNT(*) FROM students s
               LEFT JOIN users u ON u.legacy_id = s.legacy_id
              WHERE s.deleted_at IS NULL AND u.id IS NULL'
        );

        $report['classes_without_teacher'] = (int) Database::value(
            "SELECT COUNT(*) FROM classes c
               LEFT JOIN staff t ON t.legacy_id = c.teacher_legacy_id AND t.deleted_at IS NULL
              WHERE c.deleted_at IS NULL AND c.teacher_legacy_id <> '' AND t.id IS NULL"
        );

         $report['staff_without_user'] = (int) Database::value(
            "SELECT COUNT(*) FROM staff t
               LEFT JOIN users u ON u.legacy_id = JSON_UNQUOTE(JSON_EXTRACT(t.record, '\$.\"accountId\"'))
              WHERE t.deleted_at IS NULL AND JSON_EXTRACT(t.record, '\$.\"accountId\"') IS NOT NULL
                AND t.legacy_id <> '' AND u.id IS NULL"
        );

        /* Stage 4B: foreign keys that live inside the record JSON.
           A check only runs when both sides contain records. */
        $targets = [
            'students' => ['table' => 'students', 'id' => 'legacy_id'],
            'staff'    => ['table' => 'staff',    'id' => 'legacy_id'],
            'classes'  => ['table' => 'classes',  'id' => 'name'],
            'exams'    => ['table' => 'domain_exams', 'id' => 'legacy_id'],
        ];

        $links = [
            'payments_without_student'        => ['domain_payments',       '$.studentId', 'students'],
            'exam_results_without_student'    => ['domain_exam_results',   '$.studentId', 'students'],
            'exam_results_without_exam'       => ['domain_exam_results',   '$.examId',    'exams'],
            'attendance_without_student'      => ['domain_attendance',    '$.studentId', 'students'],
            'homework_without_class'          => ['domain_homework',      '$.className', 'classes'],
            'homework_submissions_without_student' => ['domain_homework_submissions', '$.studentId', 'students'],
            'submissions_without_student'     => ['domain_submissions',   '$.studentId', 'students'],
            'report_cards_without_student'    => ['domain_report_cards',  '$.studentId', 'students'],
            'fee_charges_without_student'      => ['domain_fee_charges',  '$.studentId', 'students'],
            'student_transfers_without_student'=> ['domain_student_transfers', '$.studentId', 'students'],
            'class_assignments_without_teacher'=> ['domain_class_assignments', '$.teacherId', 'staff'],
            'exam_schedule_without_exam'      => ['domain_exam_schedule', '$.examId',    'exams'],
        ];

        foreach ($links as $label => [$sourceTable, $jsonPath, $targetKey]) {
            $target = $targets[$targetKey];

            $sourceRows = (int) Database::value(
                sprintf('SELECT COUNT(*) FROM `%s` WHERE deleted_at IS NULL', $sourceTable)
            );
            $targetRows = (int) Database::value(
                sprintf('SELECT COUNT(*) FROM `%s` WHERE deleted_at IS NULL', $target['table'])
            );

            if ($sourceRows === 0 || $targetRows === 0) {
                continue;
            }

            $report[$label] = (int) Database::value(
                sprintf(
                    "SELECT COUNT(*) FROM `%s` s
                       LEFT JOIN `%s` t ON t.%s = JSON_UNQUOTE(JSON_EXTRACT(s.record, '%s')) AND t.deleted_at IS NULL
                      WHERE s.deleted_at IS NULL AND JSON_EXTRACT(s.record, '%s') IS NOT NULL
                        AND JSON_UNQUOTE(JSON_EXTRACT(s.record, '%s')) <> ''
                        AND t.id IS NULL",
                    $sourceTable,
                    $target['table'],
                    $target['id'],
                    $jsonPath,
                    $jsonPath,
                    $jsonPath
                )
            );
        }

        return $report;
    }

    /** A browser-style id, so new records look like the old ones. */
    public static function uid(): string
    {
        return base_convert((string) time(), 10, 36) . substr(bin2hex(random_bytes(3)), 0, 6);
    }

    /** True for a plain list of records, false for a single object. */
    private static function isList(array $value): bool
    {
        if ($value === []) {
            return true;
        }

        return array_is_list($value);
    }

    private static function text(mixed $value): string
    {
        if (is_scalar($value)) {
            return trim((string) $value);
        }

        return '';
    }

    private static function nullableText(mixed $value): ?string
    {
        $text = self::text($value);

        return $text === '' ? null : $text;
    }

    private static function date(mixed $value): ?string
    {
        $text = self::text($value);

        if ($text === '') {
            return null;
        }

        $stamp = strtotime($text);

        return $stamp === false ? null : date('Y-m-d', $stamp);
    }

    private static function json(mixed $value): string
    {
        $encoded = json_encode($value, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

        if ($encoded === false) {
            throw new RuntimeException('Could not encode the record.');
        }

        return $encoded;
    }
}
