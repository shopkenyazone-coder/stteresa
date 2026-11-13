-- =================================================================
-- St. Teresa Kanyange Academy - Stage 4B schema
--
-- The remaining browser domains moved into MySQL. Every table keeps
-- the original browser id in legacy_id and the complete original
-- object in record, and nothing is ever destroyed (deleted_at).
--
-- A domain that holds a single object instead of a list (for example
-- notificationSettings) is stored as one row with legacy_id
-- '__document__'. A domain that holds a list is stored one row per
-- record, exactly like the Stage 4A domains.
--
-- Re-runnable: CREATE TABLE IF NOT EXISTS throughout.
-- =================================================================

SET NAMES utf8mb4;
SET time_zone = '+03:00';

-- attendance records
CREATE TABLE IF NOT EXISTS `domain_attendance` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_attendance_legacy (legacy_id),
    KEY idx_domain_attendance_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- audit log entries
CREATE TABLE IF NOT EXISTS `domain_audit_log` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_audit_log_legacy (legacy_id),
    KEY idx_domain_audit_log_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- class to class teacher assignments
CREATE TABLE IF NOT EXISTS `domain_class_assignments` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_class_assignments_legacy (legacy_id),
    KEY idx_domain_class_assignments_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- per class fee structures
CREATE TABLE IF NOT EXISTS `domain_class_fee_structures` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_class_fee_structures_legacy (legacy_id),
    KEY idx_domain_class_fee_structures_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- exam results
CREATE TABLE IF NOT EXISTS `domain_exam_results` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_exam_results_legacy (legacy_id),
    KEY idx_domain_exam_results_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- exams
CREATE TABLE IF NOT EXISTS `domain_exams` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_exams_legacy (legacy_id),
    KEY idx_domain_exams_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- exam schedule
CREATE TABLE IF NOT EXISTS `domain_exam_schedule` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_exam_schedule_legacy (legacy_id),
    KEY idx_domain_exam_schedule_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- fee charges to students
CREATE TABLE IF NOT EXISTS `domain_fee_charges` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_fee_charges_legacy (legacy_id),
    KEY idx_domain_fee_charges_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- fee items catalogue
CREATE TABLE IF NOT EXISTS `domain_fee_items` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_fee_items_legacy (legacy_id),
    KEY idx_domain_fee_items_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- fee notification log
CREATE TABLE IF NOT EXISTS `domain_fee_notification_log` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_fee_notification_log_legacy (legacy_id),
    KEY idx_domain_fee_notification_log_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- homework
CREATE TABLE IF NOT EXISTS `domain_homework` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_homework_legacy (legacy_id),
    KEY idx_domain_homework_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- homework submissions
CREATE TABLE IF NOT EXISTS `domain_homework_submissions` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_homework_submissions_legacy (legacy_id),
    KEY idx_domain_homework_submissions_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- inventory counters
CREATE TABLE IF NOT EXISTS `domain_inv_counters` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_inv_counters_legacy (legacy_id),
    KEY idx_domain_inv_counters_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- inventory items
CREATE TABLE IF NOT EXISTS `domain_inv_items` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_inv_items_legacy (legacy_id),
    KEY idx_domain_inv_items_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- inventory stock movements
CREATE TABLE IF NOT EXISTS `domain_inv_movements` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_inv_movements_legacy (legacy_id),
    KEY idx_domain_inv_movements_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- inventory purchase orders
CREATE TABLE IF NOT EXISTS `domain_inv_orders` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_inv_orders_legacy (legacy_id),
    KEY idx_domain_inv_orders_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- inventory requests
CREATE TABLE IF NOT EXISTS `domain_inv_requests` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_inv_requests_legacy (legacy_id),
    KEY idx_domain_inv_requests_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- inventory suppliers
CREATE TABLE IF NOT EXISTS `domain_inv_suppliers` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_inv_suppliers_legacy (legacy_id),
    KEY idx_domain_inv_suppliers_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- inventory transfers
CREATE TABLE IF NOT EXISTS `domain_inv_transfers` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_inv_transfers_legacy (legacy_id),
    KEY idx_domain_inv_transfers_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- learning materials
CREATE TABLE IF NOT EXISTS `domain_materials` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_materials_legacy (legacy_id),
    KEY idx_domain_materials_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- message log
CREATE TABLE IF NOT EXISTS `domain_message_log` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_message_log_legacy (legacy_id),
    KEY idx_domain_message_log_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- notifications
CREATE TABLE IF NOT EXISTS `domain_notifications` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_notifications_legacy (legacy_id),
    KEY idx_domain_notifications_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- notification settings
CREATE TABLE IF NOT EXISTS `domain_notification_settings` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_notification_settings_legacy (legacy_id),
    KEY idx_domain_notification_settings_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- parent/guardian records
CREATE TABLE IF NOT EXISTS `domain_parents` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_parents_legacy (legacy_id),
    KEY idx_domain_parents_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- fee payments
CREATE TABLE IF NOT EXISTS `domain_payments` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_payments_legacy (legacy_id),
    KEY idx_domain_payments_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- report cards
CREATE TABLE IF NOT EXISTS `domain_report_cards` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_report_cards_legacy (legacy_id),
    KEY idx_domain_report_cards_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- student transfers
CREATE TABLE IF NOT EXISTS `domain_student_transfers` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_student_transfers_legacy (legacy_id),
    KEY idx_domain_student_transfers_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- submission counters
CREATE TABLE IF NOT EXISTS `domain_sub_counters` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_sub_counters_legacy (legacy_id),
    KEY idx_domain_sub_counters_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- exam submissions
CREATE TABLE IF NOT EXISTS `domain_submissions` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_submissions_legacy (legacy_id),
    KEY idx_domain_submissions_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- timetable entries
CREATE TABLE IF NOT EXISTS `domain_timetable` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_timetable_legacy (legacy_id),
    KEY idx_domain_timetable_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- timetable archives
CREATE TABLE IF NOT EXISTS `domain_tt_archive` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_tt_archive_legacy (legacy_id),
    KEY idx_domain_tt_archive_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- timetable classes
CREATE TABLE IF NOT EXISTS `domain_tt_classes` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_tt_classes_legacy (legacy_id),
    KEY idx_domain_tt_classes_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- timetable classrooms
CREATE TABLE IF NOT EXISTS `domain_tt_classrooms` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_tt_classrooms_legacy (legacy_id),
    KEY idx_domain_tt_classrooms_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- timetable configuration
CREATE TABLE IF NOT EXISTS `domain_tt_config` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_tt_config_legacy (legacy_id),
    KEY idx_domain_tt_config_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- timetable constraints
CREATE TABLE IF NOT EXISTS `domain_tt_constraints` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_tt_constraints_legacy (legacy_id),
    KEY idx_domain_tt_constraints_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- timetable divisions
CREATE TABLE IF NOT EXISTS `domain_tt_divisions` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_tt_divisions_legacy (legacy_id),
    KEY idx_domain_tt_divisions_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- timetable subjects
CREATE TABLE IF NOT EXISTS `domain_tt_subjects` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_tt_subjects_legacy (legacy_id),
    KEY idx_domain_tt_subjects_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- timetable teachers
CREATE TABLE IF NOT EXISTS `domain_tt_teachers` (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(255)   NOT NULL,
    record     JSON           NOT NULL,
    created_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME       NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_domain_tt_teachers_legacy (legacy_id),
    KEY idx_domain_tt_teachers_deleted (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Migration bookkeeping
INSERT INTO domain_state (domain_key, table_name, record_count, source)
VALUES
    ('attendance', 'domain_attendance', 0, 'Stage 4B'),
    ('auditLog', 'domain_audit_log', 0, 'Stage 4B'),
    ('classAssignments', 'domain_class_assignments', 0, 'Stage 4B'),
    ('classFeeStructures', 'domain_class_fee_structures', 0, 'Stage 4B'),
    ('examResults', 'domain_exam_results', 0, 'Stage 4B'),
    ('exams', 'domain_exams', 0, 'Stage 4B'),
    ('examSchedule', 'domain_exam_schedule', 0, 'Stage 4B'),
    ('feeCharges', 'domain_fee_charges', 0, 'Stage 4B'),
    ('feeItems', 'domain_fee_items', 0, 'Stage 4B'),
    ('feeNotificationLog', 'domain_fee_notification_log', 0, 'Stage 4B'),
    ('homework', 'domain_homework', 0, 'Stage 4B'),
    ('homeworkSubmissions', 'domain_homework_submissions', 0, 'Stage 4B'),
    ('invCounters', 'domain_inv_counters', 0, 'Stage 4B'),
    ('invItems', 'domain_inv_items', 0, 'Stage 4B'),
    ('invMovements', 'domain_inv_movements', 0, 'Stage 4B'),
    ('invOrders', 'domain_inv_orders', 0, 'Stage 4B'),
    ('invRequests', 'domain_inv_requests', 0, 'Stage 4B'),
    ('invSuppliers', 'domain_inv_suppliers', 0, 'Stage 4B'),
    ('invTransfers', 'domain_inv_transfers', 0, 'Stage 4B'),
    ('materials', 'domain_materials', 0, 'Stage 4B'),
    ('messageLog', 'domain_message_log', 0, 'Stage 4B'),
    ('notifications', 'domain_notifications', 0, 'Stage 4B'),
    ('notificationSettings', 'domain_notification_settings', 0, 'Stage 4B'),
    ('parents', 'domain_parents', 0, 'Stage 4B'),
    ('payments', 'domain_payments', 0, 'Stage 4B'),
    ('reportCards', 'domain_report_cards', 0, 'Stage 4B'),
    ('studentTransfers', 'domain_student_transfers', 0, 'Stage 4B'),
    ('subCounters', 'domain_sub_counters', 0, 'Stage 4B'),
    ('submissions', 'domain_submissions', 0, 'Stage 4B'),
    ('timetable', 'domain_timetable', 0, 'Stage 4B'),
    ('ttArchive', 'domain_tt_archive', 0, 'Stage 4B'),
    ('ttClasses', 'domain_tt_classes', 0, 'Stage 4B'),
    ('ttClassrooms', 'domain_tt_classrooms', 0, 'Stage 4B'),
    ('ttConfig', 'domain_tt_config', 0, 'Stage 4B'),
    ('ttConstraints', 'domain_tt_constraints', 0, 'Stage 4B'),
    ('ttDivisions', 'domain_tt_divisions', 0, 'Stage 4B'),
    ('ttSubjects', 'domain_tt_subjects', 0, 'Stage 4B'),
    ('ttTeachers', 'domain_tt_teachers', 0, 'Stage 4B')
ON DUPLICATE KEY UPDATE table_name = VALUES(table_name);

INSERT INTO schema_migrations (version) VALUES ('stage4b-domains')
ON DUPLICATE KEY UPDATE applied_at = CURRENT_TIMESTAMP;
