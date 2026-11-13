-- =================================================================
-- St. Teresa Kanyange Academy - MySQL schema
--
-- Stage 1: security, identity, messaging, media and import tables.
-- Domain tables (students, fees, exams, timetable, inventory) are
-- added in later stages; imported legacy data is preserved first in
-- import_staging so nothing can be lost.
--
-- Run against the sta_school database (see database/README-migration.md).
-- =================================================================

SET NAMES utf8mb4;
SET time_zone = '+03:00';

CREATE TABLE IF NOT EXISTS schema_migrations (
    version     VARCHAR(50)  NOT NULL,
    applied_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (version)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Accounts
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id                       BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id                VARCHAR(64)     NULL,
    username                 VARCHAR(64)     NOT NULL,
    email                    VARCHAR(190)    NULL,
    password_hash            VARCHAR(255)    NULL,
    legacy_password_hash     VARCHAR(255)    NULL,
    role                     VARCHAR(32)     NOT NULL DEFAULT 'student',
    status                   VARCHAR(16)     NOT NULL DEFAULT 'active',
    name                     VARCHAR(190)    NOT NULL,
    phone                    VARCHAR(40)     NULL,
    subject                  VARCHAR(120)    NULL,
    grade                    VARCHAR(80)     NULL,
    class_name               VARCHAR(120)    NULL,
    photo                    VARCHAR(255)    NULL,
    must_change_password     TINYINT(1)      NOT NULL DEFAULT 0,
    temp_password_expires_at DATETIME        NULL,
    recovery_question        VARCHAR(255)    NULL,
    recovery_answer_hash     VARCHAR(255)    NULL,
    legacy_recovery_answer_hash VARCHAR(255) NULL,
    failed_login_count       INT UNSIGNED    NOT NULL DEFAULT 0,
    locked_until             DATETIME        NULL,
    last_login_at            DATETIME        NULL,
    password_changed_at      DATETIME        NULL,
    is_demo                  TINYINT(1)      NOT NULL DEFAULT 0,
    created_at               DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_username (username),
    UNIQUE KEY uq_users_email (email),
    UNIQUE KEY uq_users_legacy (legacy_id),
    KEY idx_users_role (role),
    KEY idx_users_status (status),
    KEY idx_users_is_demo (is_demo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Server-side sessions (PHP session id stays in an HttpOnly cookie;
-- this table stores the revocable token + CSRF token).
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(64)        NOT NULL,
    user_id      BIGINT UNSIGNED NOT NULL,
    csrf_token   CHAR(64)        NOT NULL,
    ip           VARCHAR(45)     NULL,
    user_agent   VARCHAR(255)    NULL,
    expires_at   DATETIME        NOT NULL,
    created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_seen_at DATETIME        NULL,
    PRIMARY KEY (id),
    KEY idx_sessions_user (user_id),
    KEY idx_sessions_expiry (expires_at),
    CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Password reset tokens (never stored in clear text).
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS password_resets (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id    BIGINT UNSIGNED NOT NULL,
    token_hash CHAR(64)        NOT NULL,
    expires_at DATETIME        NOT NULL,
    used_at    DATETIME        NULL,
    created_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_password_resets_token (token_hash),
    KEY idx_password_resets_user (user_id),
    CONSTRAINT fk_password_resets_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Login attempt log for rate limiting and auditing.
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS login_attempts (
    id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    username     VARCHAR(64)     NOT NULL,
    ip           VARCHAR(45)     NULL,
    success      TINYINT(1)      NOT NULL DEFAULT 0,
    attempted_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_login_attempts_user_time (username, attempted_at),
    KEY idx_login_attempts_ip_time (ip, attempted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Audit trail (server-side; replaces the old localStorage log).
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS audit_log (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id    BIGINT UNSIGNED NULL,
    action     VARCHAR(100)    NOT NULL,
    detail     TEXT            NULL,
    ip         VARCHAR(45)     NULL,
    user_agent VARCHAR(255)    NULL,
    created_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_audit_user (user_id),
    KEY idx_audit_action (action),
    KEY idx_audit_created (created_at),
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Public contact messages.
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS contact_messages (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    legacy_id  VARCHAR(120)    NULL,
    name       VARCHAR(190)    NOT NULL,
    email      VARCHAR(190)    NOT NULL,
    phone      VARCHAR(40)     NULL,
    interest   VARCHAR(120)    NULL,
    message    TEXT            NOT NULL,
    is_read    TINYINT(1)      NOT NULL DEFAULT 0,
    status     VARCHAR(16)     NOT NULL DEFAULT 'new',
    ip         VARCHAR(45)     NULL,
    is_demo    TINYINT(1)      NOT NULL DEFAULT 0,
    created_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_contact_legacy (legacy_id),
    KEY idx_contact_created (created_at),
    KEY idx_contact_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Uploaded media registry.
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS media (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    filename    VARCHAR(255)    NOT NULL,
    path        VARCHAR(255)    NOT NULL,
    mime        VARCHAR(100)    NOT NULL,
    size        BIGINT UNSIGNED NOT NULL DEFAULT 0,
    kind        VARCHAR(32)     NOT NULL DEFAULT 'image',
    legacy_key  VARCHAR(120)    NULL,
    uploaded_by BIGINT UNSIGNED NULL,
    is_demo     TINYINT(1)      NOT NULL DEFAULT 0,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_media_path (path),
    KEY idx_media_legacy (legacy_key),
    KEY idx_media_uploader (uploaded_by),
    CONSTRAINT fk_media_user FOREIGN KEY (uploaded_by) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Bridge storage for legacy JSON keys while each domain is migrated.
-- Not used for data that already has a proper table.
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS app_state (
    state_key   VARCHAR(64)     NOT NULL,
    state_value LONGTEXT        NULL,
    version     INT UNSIGNED    NOT NULL DEFAULT 1,
    updated_by  BIGINT UNSIGNED NULL,
    updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (state_key),
    CONSTRAINT fk_app_state_user FOREIGN KEY (updated_by) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------
-- Safe import pipeline.
--
-- Imported legacy records that do not yet have a domain table are
-- written here, unchanged, so they can be migrated later without
-- ever being lost. payload_hash makes re-imports idempotent.
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS import_staging (
    id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    source_file  VARCHAR(255)    NOT NULL,
    entity       VARCHAR(64)     NOT NULL,
    legacy_id    VARCHAR(120)    NULL,
    payload_hash CHAR(64)        NOT NULL,
    payload      LONGTEXT        NOT NULL,
    status       VARCHAR(16)     NOT NULL DEFAULT 'staged',
    created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    imported_at  DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_staging_hash (entity, payload_hash),
    KEY idx_staging_entity (entity),
    KEY idx_staging_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS import_runs (
    id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    source_file   VARCHAR(255)    NOT NULL,
    source_hash   CHAR(64)        NULL,
    mode          VARCHAR(16)     NOT NULL DEFAULT 'import',
    status        VARCHAR(16)     NOT NULL DEFAULT 'running',
    entity_counts LONGTEXT        NULL,
    notes         TEXT            NULL,
    started_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finished_at   DATETIME        NULL,
    PRIMARY KEY (id),
    KEY idx_import_runs_started (started_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO schema_migrations (version) VALUES ('0001_core');
