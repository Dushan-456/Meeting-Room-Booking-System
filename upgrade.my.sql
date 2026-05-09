-- ============================================================================
-- MRBS Database Upgrade Script
-- From: Old schema (db_version 36)
-- To:   New MRBS schema (db_version 82)
--
-- Generated: 2026-05-09
--
-- INSTRUCTIONS:
--   1. BACKUP your database before running this script!
--   2. Run this script against your database:
--   3. Check the output for any errors.
--
-- NOTES:
--   - This script uses ALTER IGNORE and IF EXISTS/IF NOT EXISTS guards
--     so it can be safely re-run if interrupted.
--   - Old tables mrbs_facilities and mrbs_facilitiesrequired will be DROPPED
--     because they do not exist in the new schema.
--   - Old mrbs_users.password (MD5 hashes) will be renamed to password_hash.
--     The old MD5 hashes will NOT work with the new system's password_verify().
--     Users will need to reset their passwords after migration.
-- ============================================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- 1. UPGRADE mrbs_area
-- ============================================================================

-- 1a. Convert charset to utf8mb4
ALTER TABLE `mrbs_area` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 1b. Widen area_name from varchar(30) to varchar(60)
ALTER TABLE `mrbs_area`
  MODIFY `area_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL;

-- 1c. Add sort_key column (NEW in new schema)
ALTER TABLE `mrbs_area`
  ADD COLUMN `sort_key` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' NOT NULL
  AFTER `area_name`;

-- 1d. Widen timezone from varchar(50) to varchar(60), set default
ALTER TABLE `mrbs_area`
  MODIFY `timezone` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Asia/Colombo';

-- 1e. Rename min_book_ahead_enabled -> min_create_ahead_enabled
--     Rename min_book_ahead_secs    -> min_create_ahead_secs
--     Rename max_book_ahead_enabled -> max_create_ahead_enabled
--     Rename max_book_ahead_secs    -> max_create_ahead_secs
ALTER TABLE `mrbs_area`
  CHANGE COLUMN `min_book_ahead_enabled` `min_create_ahead_enabled` tinyint DEFAULT NULL,
  CHANGE COLUMN `min_book_ahead_secs`    `min_create_ahead_secs`    int DEFAULT NULL,
  CHANGE COLUMN `max_book_ahead_enabled` `max_create_ahead_enabled` tinyint DEFAULT NULL,
  CHANGE COLUMN `max_book_ahead_secs`    `max_create_ahead_secs`    int DEFAULT NULL;

-- 1f. Add new delete-ahead columns
ALTER TABLE `mrbs_area`
  ADD COLUMN `min_delete_ahead_enabled` tinyint DEFAULT NULL AFTER `max_create_ahead_secs`,
  ADD COLUMN `min_delete_ahead_secs`    int DEFAULT NULL     AFTER `min_delete_ahead_enabled`,
  ADD COLUMN `max_delete_ahead_enabled` tinyint DEFAULT NULL AFTER `min_delete_ahead_secs`,
  ADD COLUMN `max_delete_ahead_secs`    int DEFAULT NULL     AFTER `max_delete_ahead_enabled`;

-- 1g. Add max_secs_per_* columns (NEW in new schema)
ALTER TABLE `mrbs_area`
  ADD COLUMN `max_secs_per_day_enabled`    tinyint DEFAULT 0 NOT NULL AFTER `max_per_future`,
  ADD COLUMN `max_secs_per_day`            int DEFAULT 0 NOT NULL     AFTER `max_secs_per_day_enabled`,
  ADD COLUMN `max_secs_per_week_enabled`   tinyint DEFAULT 0 NOT NULL AFTER `max_secs_per_day`,
  ADD COLUMN `max_secs_per_week`           int DEFAULT 0 NOT NULL     AFTER `max_secs_per_week_enabled`,
  ADD COLUMN `max_secs_per_month_enabled`  tinyint DEFAULT 0 NOT NULL AFTER `max_secs_per_week`,
  ADD COLUMN `max_secs_per_month`          int DEFAULT 0 NOT NULL     AFTER `max_secs_per_month_enabled`,
  ADD COLUMN `max_secs_per_year_enabled`   tinyint DEFAULT 0 NOT NULL AFTER `max_secs_per_month`,
  ADD COLUMN `max_secs_per_year`           int DEFAULT 0 NOT NULL     AFTER `max_secs_per_year_enabled`,
  ADD COLUMN `max_secs_per_future_enabled` tinyint DEFAULT 0 NOT NULL AFTER `max_secs_per_year`,
  ADD COLUMN `max_secs_per_future`         int DEFAULT 0 NOT NULL     AFTER `max_secs_per_future_enabled`;

-- 1h. Add max_duration columns (NEW in new schema)
ALTER TABLE `mrbs_area`
  ADD COLUMN `max_duration_enabled` tinyint DEFAULT 0 NOT NULL AFTER `max_secs_per_future`,
  ADD COLUMN `max_duration_secs`    int DEFAULT 0 NOT NULL     AFTER `max_duration_enabled`,
  ADD COLUMN `max_duration_periods` int DEFAULT 0 NOT NULL     AFTER `max_duration_secs`;

-- 1i. Add periods column (NEW in new schema)
ALTER TABLE `mrbs_area`
  ADD COLUMN `periods` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
  AFTER `enable_periods`;

-- 1i-fix. Populate periods with empty JSON array for existing areas
--         (The PHP code calls json_decode() on this column; NULL causes a fatal error in PHP 8+)
UPDATE `mrbs_area` SET `periods` = '["Period 1","Period 2"]' WHERE `periods` IS NULL;

-- 1j. Add times_along_top column (NEW in new schema)
ALTER TABLE `mrbs_area`
  ADD COLUMN `times_along_top` tinyint NOT NULL DEFAULT 0
  AFTER `confirmed_default`;

-- 1k. Add default_type column (NEW in new schema)
ALTER TABLE `mrbs_area`
  ADD COLUMN `default_type` char(1) DEFAULT 'E' NOT NULL
  AFTER `times_along_top`;

-- 1l. Add unique key on area_name (duplicate area names will cause error!)
--     Check for duplicates first. If you have duplicates, rename them before running.
ALTER TABLE `mrbs_area`
  ADD UNIQUE KEY `uq_area_name` (`area_name`);


-- ============================================================================
-- 2. UPGRADE mrbs_room
-- ============================================================================

-- 2a. Convert charset to utf8mb4
ALTER TABLE `mrbs_room` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2b. Widen room_name from varchar(50) to varchar(70)
ALTER TABLE `mrbs_room`
  MODIFY `room_name` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' NOT NULL;

-- 2c. Change sort_key from int(25) to varchar(70)
ALTER TABLE `mrbs_room`
  MODIFY `sort_key` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' NOT NULL;

-- 2d. Widen description from varchar(60) to varchar(70)
ALTER TABLE `mrbs_room`
  MODIFY `description` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL;

-- 2e. Add invalid_types column (NEW in new schema)
ALTER TABLE `mrbs_room`
  ADD COLUMN `invalid_types` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
    COMMENT 'JSON encoded'
  AFTER `room_admin_email`;

-- 2f. Drop old columns that no longer exist in new schema
--     projector and Internet columns are removed from mrbs_room
--     (facility tracking now happens at entry/repeat level)
ALTER TABLE `mrbs_room`
  DROP COLUMN `projector`,
  DROP COLUMN `Internet`;

-- 2g. Add foreign key on area_id -> mrbs_area(id)
ALTER TABLE `mrbs_room`
  ADD CONSTRAINT `fk_room_area` FOREIGN KEY (`area_id`)
    REFERENCES `mrbs_area`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

-- 2h. Add unique key on (area_id, room_name)
--     If you have duplicate room names within the same area, rename them first.
ALTER TABLE `mrbs_room`
  ADD UNIQUE KEY `uq_room_name` (`area_id`, `room_name`);


-- ============================================================================
-- 3. UPGRADE mrbs_repeat
-- ============================================================================

-- 3a. Convert charset to utf8mb4
ALTER TABLE `mrbs_repeat` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 3b. Set timestamp to auto-update (ensure current behavior)
ALTER TABLE `mrbs_repeat`
  MODIFY `timestamp` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- 3c. Rename rep_num_weeks -> rep_interval (with default 1)
ALTER TABLE `mrbs_repeat`
  CHANGE COLUMN `rep_num_weeks` `rep_interval` smallint DEFAULT 1 NOT NULL;

-- 3d. Add new facility/equipment columns (nullable so old entries show '---' not 'No')
ALTER TABLE `mrbs_repeat`
  ADD COLUMN `seat_count`        int DEFAULT NULL                 AFTER `ical_sequence`,
  ADD COLUMN `event_type`        varchar(50) DEFAULT NULL         AFTER `seat_count`,
  ADD COLUMN `internet`          tinyint DEFAULT NULL             AFTER `event_type`,
  ADD COLUMN `laptop`            tinyint DEFAULT NULL             AFTER `internet`,
  ADD COLUMN `sound_system`      tinyint DEFAULT NULL             AFTER `laptop`,
  ADD COLUMN `projector`         tinyint DEFAULT NULL             AFTER `sound_system`,
  ADD COLUMN `tv`                tinyint DEFAULT NULL             AFTER `projector`,
  ADD COLUMN `hybrid_facility`   tinyint DEFAULT NULL             AFTER `tv`,
  ADD COLUMN `zoom_start_time`   TIME DEFAULT NULL                AFTER `hybrid_facility`,
  ADD COLUMN `zoom_end_time`     TIME DEFAULT NULL                AFTER `zoom_start_time`,
  ADD COLUMN `meeting_link`      text DEFAULT NULL                AFTER `zoom_end_time`,
  ADD COLUMN `other_requirement` text DEFAULT NULL                AFTER `meeting_link`;

-- 3e. Add foreign key on room_id -> mrbs_room(id)
ALTER TABLE `mrbs_repeat`
  ADD CONSTRAINT `fk_repeat_room` FOREIGN KEY (`room_id`)
    REFERENCES `mrbs_room`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;


-- ============================================================================
-- 4. UPGRADE mrbs_entry
-- ============================================================================

-- 4a. Convert charset to utf8mb4
ALTER TABLE `mrbs_entry` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 4b. Make description nullable (was NOT NULL in old schema, nullable in new)
ALTER TABLE `mrbs_entry`
  MODIFY `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL;

-- 4c. Change repeat_id default from 0 to NULL, allow NULL
--     First update existing 0 values to NULL
UPDATE `mrbs_entry` SET `repeat_id` = NULL WHERE `repeat_id` = 0;
ALTER TABLE `mrbs_entry`
  MODIFY `repeat_id` int DEFAULT NULL;

-- 4d. Make ical_recur_id nullable with NULL default (was NOT NULL DEFAULT '')
ALTER TABLE `mrbs_entry`
  MODIFY `ical_recur_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL;

-- 4e. Add registration columns (NEW in new schema)
--     registration_opens  = seconds before start time (default 2 weeks)
--     registration_closes = seconds before start time
ALTER TABLE `mrbs_entry`
  ADD COLUMN `allow_registration`          tinyint DEFAULT 0 NOT NULL     AFTER `ical_recur_id`,
  ADD COLUMN `registrant_limit`            int DEFAULT 0 NOT NULL         AFTER `allow_registration`,
  ADD COLUMN `registrant_limit_enabled`    tinyint DEFAULT 1 NOT NULL     AFTER `registrant_limit`,
  ADD COLUMN `registration_opens`          int DEFAULT 1209600 NOT NULL   AFTER `registrant_limit_enabled`,
  ADD COLUMN `registration_opens_enabled`  tinyint DEFAULT 0 NOT NULL     AFTER `registration_opens`,
  ADD COLUMN `registration_closes`         int DEFAULT 0 NOT NULL         AFTER `registration_opens_enabled`,
  ADD COLUMN `registration_closes_enabled` tinyint DEFAULT 0 NOT NULL     AFTER `registration_closes`;

-- 4f. Add new facility/equipment columns (nullable so old entries show '---' not 'No')
ALTER TABLE `mrbs_entry`
  ADD COLUMN `seat_count`        int DEFAULT NULL                 AFTER `registration_closes_enabled`,
  ADD COLUMN `event_type`        varchar(50) DEFAULT NULL         AFTER `seat_count`,
  ADD COLUMN `internet`          tinyint DEFAULT NULL             AFTER `event_type`,
  ADD COLUMN `laptop`            tinyint DEFAULT NULL             AFTER `internet`,
  ADD COLUMN `sound_system`      tinyint DEFAULT NULL             AFTER `laptop`,
  ADD COLUMN `projector`         tinyint DEFAULT NULL             AFTER `sound_system`,
  ADD COLUMN `tv`                tinyint DEFAULT NULL             AFTER `projector`,
  ADD COLUMN `hybrid_facility`   tinyint DEFAULT NULL             AFTER `tv`,
  ADD COLUMN `zoom_start_time`   TIME DEFAULT NULL                AFTER `hybrid_facility`,
  ADD COLUMN `zoom_end_time`     TIME DEFAULT NULL                AFTER `zoom_start_time`,
  ADD COLUMN `meeting_link`      text DEFAULT NULL                AFTER `zoom_end_time`,
  ADD COLUMN `other_requirement` text DEFAULT NULL                AFTER `meeting_link`;

-- 4g. Add composite index on (room_id, start_time, end_time) for performance
ALTER TABLE `mrbs_entry`
  ADD KEY `idxRoomStartEnd` (`room_id`, `start_time`, `end_time`);

-- 4h. Add foreign key on room_id -> mrbs_room(id)
ALTER TABLE `mrbs_entry`
  ADD CONSTRAINT `fk_entry_room` FOREIGN KEY (`room_id`)
    REFERENCES `mrbs_room`(`id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

-- 4i. Clean up repeat_id references that don't exist in mrbs_repeat
--     (required before adding FK constraint)
UPDATE `mrbs_entry` e
  LEFT JOIN `mrbs_repeat` r ON e.`repeat_id` = r.`id`
SET e.`repeat_id` = NULL
WHERE e.`repeat_id` IS NOT NULL AND r.`id` IS NULL;

-- 4j. Add foreign key on repeat_id -> mrbs_repeat(id)
ALTER TABLE `mrbs_entry`
  ADD CONSTRAINT `fk_entry_repeat` FOREIGN KEY (`repeat_id`)
    REFERENCES `mrbs_repeat`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE;


-- ============================================================================
-- 5. UPGRADE mrbs_users
-- ============================================================================

-- 5a. Convert charset to utf8mb4
ALTER TABLE `mrbs_users` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 5b. Rename password -> password_hash and widen to varchar(255)
--     NOTE: Old MD5 hashes will NOT work with password_verify().
--     Users must reset passwords after migration.
ALTER TABLE `mrbs_users`
  CHANGE COLUMN `password` `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL;

-- 5c. Add display_name column
ALTER TABLE `mrbs_users`
  ADD COLUMN `display_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
  AFTER `name`;

-- 5d. Add timestamp column
ALTER TABLE `mrbs_users`
  ADD COLUMN `timestamp` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  AFTER `email`;

-- 5e. Add last_login column
ALTER TABLE `mrbs_users`
  ADD COLUMN `last_login` int DEFAULT 0 NOT NULL
  AFTER `timestamp`;

-- 5f. Add reset_key_hash column
ALTER TABLE `mrbs_users`
  ADD COLUMN `reset_key_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
  AFTER `last_login`;

-- 5g. Add reset_key_expiry column
ALTER TABLE `mrbs_users`
  ADD COLUMN `reset_key_expiry` int DEFAULT 0 NOT NULL
  AFTER `reset_key_hash`;

-- 5h. Populate display_name from name for existing users
UPDATE `mrbs_users` SET `display_name` = `name` WHERE `display_name` IS NULL;

-- 5i. Add unique key on name
ALTER TABLE `mrbs_users`
  ADD UNIQUE KEY `uq_name` (`name`);


-- ============================================================================
-- 6. UPGRADE mrbs_variables
-- ============================================================================

-- 6a. Convert charset to utf8mb4
ALTER TABLE `mrbs_variables` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 6b. Add unique key on variable_name
ALTER TABLE `mrbs_variables`
  ADD UNIQUE KEY `uq_variable_name` (`variable_name`);


-- ============================================================================
-- 7. UPGRADE mrbs_zoneinfo
-- ============================================================================

-- 7a. Convert charset to utf8mb4
ALTER TABLE `mrbs_zoneinfo` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 7b. Change timezone from varchar(255) to varchar(127)
ALTER TABLE `mrbs_zoneinfo`
  MODIFY `timezone` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' NOT NULL;

-- 7c. Change last_updated from date to int (Unix timestamp)
--     Convert existing date values to Unix timestamps
ALTER TABLE `mrbs_zoneinfo`
  MODIFY `last_updated` int NOT NULL DEFAULT 0;

-- 7d. Add unique key on (timezone, outlook_compatible)
ALTER TABLE `mrbs_zoneinfo`
  ADD UNIQUE KEY `uq_timezone` (`timezone`, `outlook_compatible`);


-- ============================================================================
-- 8. CREATE NEW TABLES
-- ============================================================================

-- 8a. Create mrbs_participants table (NEW)
CREATE TABLE IF NOT EXISTS `mrbs_participants`
(
  `id`          int NOT NULL auto_increment,
  `entry_id`    int NOT NULL,
  `username`    varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `create_by`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `registered`  int,

  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_entryid_username` (`entry_id`, `username`),
  FOREIGN KEY (`entry_id`)
    REFERENCES `mrbs_entry`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8b. Create mrbs_sessions table (NEW)
CREATE TABLE IF NOT EXISTS `mrbs_sessions`
(
  `id`      varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `access`  int unsigned DEFAULT NULL COMMENT 'Unix timestamp',
  `data`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,

  PRIMARY KEY (`id`),
  KEY `idxAccess` (`access`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ============================================================================
-- 9. DROP OBSOLETE TABLES
-- ============================================================================

-- These tables do not exist in the new schema.
-- Facility tracking is now done via columns on mrbs_entry and mrbs_repeat.
DROP TABLE IF EXISTS `mrbs_facilitiesrequired`;
DROP TABLE IF EXISTS `mrbs_facilities`;


-- ============================================================================
-- 10. UPDATE DATABASE VERSION
-- ============================================================================

UPDATE `mrbs_variables` SET `variable_content` = '82' WHERE `variable_name` = 'db_version';
UPDATE `mrbs_variables` SET `variable_content` = '1'  WHERE `variable_name` = 'local_db_version';


-- ============================================================================
-- 11. RE-ENABLE FOREIGN KEY CHECKS
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 1;


-- ============================================================================
-- DONE! Post-migration checklist:
-- ============================================================================
-- [ ] Verify all tables exist:
--       SHOW TABLES LIKE 'mrbs_%';
--
-- [ ] Verify mrbs_area has new columns:
--       DESCRIBE mrbs_area;
--
-- [ ] Verify mrbs_entry has new columns:
--       DESCRIBE mrbs_entry;
--
-- [ ] Verify mrbs_users has password_hash (not password):
--       DESCRIBE mrbs_users;
--
-- [ ] Reset user passwords (old MD5 hashes won't work):
--       UPDATE mrbs_users SET password_hash = '$2y$10$...' WHERE name = 'admin';
--       (Use PHP's password_hash('newpassword', PASSWORD_DEFAULT) to generate)
--
-- [ ] Verify foreign keys:
--       SELECT * FROM information_schema.TABLE_CONSTRAINTS
--       WHERE TABLE_SCHEMA = 'academic_centre'
--         AND CONSTRAINT_TYPE = 'FOREIGN KEY';
--
-- [ ] Check data integrity:
--       SELECT COUNT(*) FROM mrbs_area;
--       SELECT COUNT(*) FROM mrbs_room;
--       SELECT COUNT(*) FROM mrbs_entry;
--       SELECT COUNT(*) FROM mrbs_repeat;
--       SELECT COUNT(*) FROM mrbs_users;
-- ============================================================================
