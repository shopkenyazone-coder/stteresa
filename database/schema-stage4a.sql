-- =================================================================
-- St. Teresa Kanyange Academy - Stage 4A schema
--
-- The first group of data domains moved out of browser storage and
-- into MySQL:
--
--   students        <- localStorage key "students"
--   staff           <- localStorage key "teachers"
--   classes         <- localStorage key "classes"
--   academic_years  <- localStorage key "academicYears"
--   leadership      <- localStorage key "leadership"
--   slider_slides   <- localStorage key "slider"
--   announcements   <- localStorage key "announcements"
--   content_documents<- localStorage keys "settings" and "logo"
--
-- Design notes
--   * `legacy_id` keeps the original browser id so every record can be
--     traced back to the data it came from. Nothing is ever re-keyed.
--   * `record` holds the complete original JSON object, so a record
--     read back from MySQL is byte-for-byte what the browser had.
--     The named columns are a searchable projection of that same data.
--   * Deletes are soft (deleted_at). A removed record stays in the
--     table so historical data is never lost.
--
-- Run against the sta_school database. Safe to re-run.
-- =================================================================

SET NAMES utf8mb4;
SET time_zone = '+03:00';

-- -----------------------------------------------------------------
-- Which domains have been moved to MySQL, and when.
-- A domain is only served from MySQL once it has been imported and
-- verified; until then the JSON mirror keeps serving it.
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS domain_state (
    domain_key  VARCHAR(64)  NOT NULL,
    table_name  VARCHAR(64)  NOT NULL,
    migrated_at DATETIME     NULL,
    record_count INT         NOT NULL DEFAULT 0,
    source      VARCHAR(255) NULL,
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (domain_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Students
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS students (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id      VARCHAR(64)     NOT NULL,
    admission_no   VARCHAR(64)     NOT NULL DEFAULT '',
    first_name     VARCHAR(120)    NOT NULL DEFAULT '',
    last_name      VARCHAR(120)    NOT NULL DEFAULT '',
    full_name      VARCHAR(255)    NOT NULL DEFAULT '',
    grade          VARCHAR(64)     NOT NULL DEFAULT '',
    class_name     VARCHAR(64)     NOT NULL DEFAULT '',
    gender         VARCHAR(32)     NOT NULL DEFAULT '',
    email          VARCHAR(190)    NOT NULL DEFAULT '',
    phone          VARCHAR(64)     NOT NULL DEFAULT '',
    status         VARCHAR(32)     NOT NULL DEFAULT 'active',
    admission_date DATE            NULL,
    dob            DATE            NULL,
    fee_balance    DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    photo          VARCHAR(255)    NOT NULL DEFAULT '',
    photo_key      VARCHAR(120)    NOT NULL DEFAULT '',
    user_id        BIGINT UNSIGNED NULL,
    record         JSON            NOT NULL,
    created_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at     DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_students_legacy (legacy_id),
    KEY idx_students_class (class_name),
    KEY idx_students_status (status),
    KEY idx_students_admission (admission_no),
    KEY idx_students_user (user_id),
    CONSTRAINT fk_students_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Staff (teachers, office staff, administration)
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS staff (
    id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id     VARCHAR(64)     NOT NULL,
    staff_no      VARCHAR(64)     NOT NULL DEFAULT '',
    first_name    VARCHAR(120)    NOT NULL DEFAULT '',
    last_name     VARCHAR(120)    NOT NULL DEFAULT '',
    full_name     VARCHAR(255)    NOT NULL DEFAULT '',
    email         VARCHAR(190)    NOT NULL DEFAULT '',
    phone         VARCHAR(64)     NOT NULL DEFAULT '',
    subject       VARCHAR(120)    NOT NULL DEFAULT '',
    role          VARCHAR(120)    NOT NULL DEFAULT '',
    qualification VARCHAR(190)    NOT NULL DEFAULT '',
    status        VARCHAR(32)     NOT NULL DEFAULT 'active',
    photo         VARCHAR(255)    NOT NULL DEFAULT '',
    bio           TEXT            NULL,
    user_id       BIGINT UNSIGNED NULL,
    record        JSON            NOT NULL,
    created_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at    DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_staff_legacy (legacy_id),
    KEY idx_staff_status (status),
    KEY idx_staff_subject (subject),
    KEY idx_staff_user (user_id),
    CONSTRAINT fk_staff_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Classes
-- teacher_legacy_id links a class to the staff record that teaches it
-- (the browser used the staff record id for the same purpose).
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS classes (
    id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id        VARCHAR(64)     NOT NULL,
    name             VARCHAR(120)    NOT NULL DEFAULT '',
    level            INT             NOT NULL DEFAULT 0,
    academic_year    VARCHAR(64)     NOT NULL DEFAULT '',
    term             VARCHAR(16)     NOT NULL DEFAULT '',
    teacher_legacy_id VARCHAR(64)    NOT NULL DEFAULT '',
    teacher_name     VARCHAR(190)    NOT NULL DEFAULT '',
    subjects         JSON            NULL,
    status           VARCHAR(32)     NOT NULL DEFAULT 'active',
    record           JSON            NOT NULL,
    created_at       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at       DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_classes_legacy (legacy_id),
    KEY idx_classes_name (name),
    KEY idx_classes_teacher (teacher_legacy_id),
    KEY idx_classes_year (academic_year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Academic years
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS academic_years (
    id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id    VARCHAR(64)     NOT NULL,
    label        VARCHAR(120)    NOT NULL DEFAULT '',
    name         VARCHAR(190)    NOT NULL DEFAULT '',
    start_date   DATE            NULL,
    end_date     DATE            NULL,
    default_term VARCHAR(16)     NOT NULL DEFAULT '',
    status       VARCHAR(32)     NOT NULL DEFAULT 'active',
    archived     TINYINT(1)      NOT NULL DEFAULT 0,
    record       JSON            NOT NULL,
    created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at   DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_years_legacy (legacy_id),
    KEY idx_years_label (label),
    KEY idx_years_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Leadership profiles (public site)
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS leadership (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(64)     NOT NULL,
    name       VARCHAR(190)    NOT NULL DEFAULT '',
    position   VARCHAR(190)    NOT NULL DEFAULT '',
    photo      VARCHAR(255)    NOT NULL DEFAULT '',
    email      VARCHAR(190)    NOT NULL DEFAULT '',
    record     JSON            NOT NULL,
    created_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_leadership_legacy (legacy_id),
    KEY idx_leadership_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Homepage slider
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS slider_slides (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id   VARCHAR(64)     NOT NULL,
    title       VARCHAR(255)    NOT NULL DEFAULT '',
    description TEXT            NULL,
    image_url   VARCHAR(500)    NOT NULL DEFAULT '',
    image_key   VARCHAR(120)    NOT NULL DEFAULT '',
    sort_order  INT             NOT NULL DEFAULT 0,
    record      JSON            NOT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at  DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_slides_legacy (legacy_id),
    KEY idx_slides_sort (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Announcements
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS announcements (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id      VARCHAR(64)     NOT NULL,
    title          VARCHAR(255)    NOT NULL DEFAULT '',
    body           MEDIUMTEXT      NULL,
    audience       VARCHAR(120)    NOT NULL DEFAULT 'all',
    status         VARCHAR(32)     NOT NULL DEFAULT 'published',
    approval_status VARCHAR(64)    NOT NULL DEFAULT '',
    published_at   DATETIME        NULL,
    record         JSON            NOT NULL,
    created_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at     DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_announcements_legacy (legacy_id),
    KEY idx_announcements_status (status),
    KEY idx_announcements_audience (audience)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Single-object documents (site settings, logo)
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS content_documents (
    doc_key   VARCHAR(64)  NOT NULL,
    doc_value JSON         NOT NULL,
    updated_by BIGINT UNSIGNED NULL,
    created_at DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (doc_key),
    CONSTRAINT fk_content_user FOREIGN KEY (updated_by) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Migration bookkeeping
-- -----------------------------------------------------------------
INSERT INTO domain_state (domain_key, table_name, record_count, source)
VALUES
    ('students',       'students',        0, 'Stage 4A'),
    ('teachers',       'staff',           0, 'Stage 4A'),
    ('classes',        'classes',         0, 'Stage 4A'),
    ('academicYears',  'academic_years',  0, 'Stage 4A'),
    ('leadership',     'leadership',      0, 'Stage 4A'),
    ('slider',         'slider_slides',   0, 'Stage 4A'),
    ('announcements',  'announcements',   0, 'Stage 4A'),
    ('settings',       'content_documents', 0, 'Stage 4A'),
    ('logo',           'content_documents', 0, 'Stage 4A')
ON DUPLICATE KEY UPDATE table_name = VALUES(table_name);

INSERT INTO schema_migrations (version) VALUES ('stage4a-domains')
ON DUPLICATE KEY UPDATE applied_at = CURRENT_TIMESTAMP;
