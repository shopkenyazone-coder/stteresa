/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.16-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: st_teresa_academy
-- ------------------------------------------------------
-- Server version	10.11.16-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `academic_years`
--

DROP TABLE IF EXISTS `academic_years`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_years` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(64) NOT NULL,
  `label` varchar(120) NOT NULL DEFAULT '',
  `name` varchar(190) NOT NULL DEFAULT '',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `default_term` varchar(16) NOT NULL DEFAULT '',
  `status` varchar(32) NOT NULL DEFAULT 'active',
  `archived` tinyint(1) NOT NULL DEFAULT 0,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_years_legacy` (`legacy_id`),
  KEY `idx_years_label` (`label`),
  KEY `idx_years_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_years`
--

LOCK TABLES `academic_years` WRITE;
/*!40000 ALTER TABLE `academic_years` DISABLE KEYS */;
INSERT INTO `academic_years` VALUES
(1,'mw2tk849td74gd','2025','','2025-01-01','2025-12-31','1','active',0,'{\"id\":\"mw2tk849td74gd\",\"label\":\"2025\",\"startDate\":\"2025-01-01\",\"endDate\":\"2025-12-31\",\"terms\":[1,2,3],\"defaultTerm\":1,\"status\":\"active\",\"notes\":\"\",\"createdAt\":\"2026-11-05T00:40:29.721Z\",\"updatedAt\":\"2026-11-05T00:40:29.721Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'mw2tk849i1pspg','2026','','2026-01-01','2026-12-31','1','active',0,'{\"id\":\"mw2tk849i1pspg\",\"label\":\"2026\",\"startDate\":\"2026-01-01\",\"endDate\":\"2026-12-31\",\"terms\":[1,2,3],\"defaultTerm\":1,\"status\":\"active\",\"notes\":\"\",\"createdAt\":\"2026-11-05T00:40:29.721Z\",\"updatedAt\":\"2026-11-05T00:40:29.721Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(3,'mw2tk8493b07nj','2027','','2027-01-01','2027-12-31','1','active',0,'{\"id\":\"mw2tk8493b07nj\",\"label\":\"2027\",\"startDate\":\"2027-01-01\",\"endDate\":\"2027-12-31\",\"terms\":[1,2,3],\"defaultTerm\":1,\"status\":\"active\",\"notes\":\"\",\"createdAt\":\"2026-11-05T00:40:29.721Z\",\"updatedAt\":\"2026-11-05T00:40:29.721Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `academic_years` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcements` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(64) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `body` mediumtext DEFAULT NULL,
  `audience` varchar(120) NOT NULL DEFAULT 'all',
  `status` varchar(32) NOT NULL DEFAULT 'published',
  `approval_status` varchar(64) NOT NULL DEFAULT '',
  `published_at` datetime DEFAULT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_announcements_legacy` (`legacy_id`),
  KEY `idx_announcements_status` (`status`),
  KEY `idx_announcements_audience` (`audience`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_state`
--

DROP TABLE IF EXISTS `app_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_state` (
  `state_key` varchar(64) NOT NULL,
  `state_value` longtext DEFAULT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `updated_by` bigint(20) unsigned DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`state_key`),
  KEY `fk_app_state_user` (`updated_by`),
  CONSTRAINT `fk_app_state_user` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_state`
--

LOCK TABLES `app_state` WRITE;
/*!40000 ALTER TABLE `app_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `app_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `detail` text DEFAULT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_audit_user` (`user_id`),
  KEY `idx_audit_action` (`action`),
  KEY `idx_audit_created` (`created_at`),
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES
(1,1,'auth.login.success','Signed in: admin (admin)','127.0.0.1','curl/8.0.1','2026-11-13 09:03:04'),
(2,1,'auth.login.success','Signed in: admin (admin)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:30'),
(3,2,'auth.login.success','Signed in: headteacher (headteacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:30'),
(4,3,'auth.login.success','Signed in: chiefexaminer (chiefexaminer)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:31'),
(5,4,'auth.login.success','Signed in: secretary (secretary)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:32'),
(6,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:32'),
(7,7,'auth.login.success','Signed in: storekeeper (storekeeper)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:33'),
(8,8,'auth.login.success','Signed in: kitchenmanager (kitchenmanager)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:33'),
(9,6,'auth.login.success','Signed in: student (student)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:34'),
(10,6,'auth.login.fail','Failed sign-in for student','127.0.0.1','curl/8.0.1','2026-11-13 09:22:34'),
(11,6,'auth.login.role_mismatch','Wrong portal for student','127.0.0.1','curl/8.0.1','2026-11-13 09:22:35'),
(12,1,'content.save','Site content saved (139 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:36'),
(13,1,'media.upload','Uploaded img_20261113_092236_b5ffc81c1664cb77b78a.png (68 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:36'),
(14,1,'media.upload','Uploaded img_20261113_092236_d63e96e96caf303a96f8.png (68 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:36'),
(15,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:37'),
(16,5,'auth.logout','Signed out','127.0.0.1','curl/8.0.1','2026-11-13 09:22:37'),
(17,NULL,'auth.login.success','Signed in: stage3check (student)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:38'),
(18,NULL,'auth.password.change.fail','Wrong current password for stage3check','127.0.0.1','curl/8.0.1','2026-11-13 09:22:39'),
(19,NULL,'auth.password.change','Password changed for stage3check','127.0.0.1','curl/8.0.1','2026-11-13 09:22:40'),
(20,NULL,'auth.login.fail','Failed sign-in for stage3check','127.0.0.1','curl/8.0.1','2026-11-13 09:22:40'),
(21,NULL,'auth.login.success','Signed in: stage3check (student)','127.0.0.1','curl/8.0.1','2026-11-13 09:22:41'),
(22,1,'auth.login.success','Signed in: admin (admin)','127.0.0.1','curl/8.0.1','2026-11-13 09:25:13'),
(23,2,'auth.login.success','Signed in: headteacher (headteacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:25:14'),
(24,3,'auth.login.success','Signed in: chiefexaminer (chiefexaminer)','127.0.0.1','curl/8.0.1','2026-11-13 09:25:14'),
(25,4,'auth.login.success','Signed in: secretary (secretary)','127.0.0.1','curl/8.0.1','2026-11-13 09:25:15'),
(26,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:25:15'),
(27,7,'auth.login.success','Signed in: storekeeper (storekeeper)','127.0.0.1','curl/8.0.1','2026-11-13 09:25:15'),
(28,8,'auth.login.success','Signed in: kitchenmanager (kitchenmanager)','127.0.0.1','curl/8.0.1','2026-11-13 09:25:16'),
(29,6,'auth.login.success','Signed in: student (student)','127.0.0.1','curl/8.0.1','2026-11-13 09:25:17'),
(30,6,'auth.login.fail','Failed sign-in for student','127.0.0.1','curl/8.0.1','2026-11-13 09:25:17'),
(31,6,'auth.login.role_mismatch','Wrong portal for student','127.0.0.1','curl/8.0.1','2026-11-13 09:25:18'),
(32,1,'content.save','Site content saved (139 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:25:19'),
(33,1,'media.upload','Uploaded img_20261113_092519_bfae6d044d9f6798eb3d.png (68 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:25:19'),
(34,1,'media.upload','Uploaded img_20261113_092519_649329b8060ce75ebd5c.png (68 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:25:19'),
(35,5,'auth.login.rate_limited','Rate limit hit for: teacher','127.0.0.1','curl/8.0.1','2026-11-13 09:25:20'),
(39,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:30:47'),
(40,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:30:56'),
(41,1,'auth.login.success','Signed in: admin (admin)','127.0.0.1','curl/8.0.1','2026-11-13 09:31:24'),
(42,2,'auth.login.success','Signed in: headteacher (headteacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:31:24'),
(43,3,'auth.login.success','Signed in: chiefexaminer (chiefexaminer)','127.0.0.1','curl/8.0.1','2026-11-13 09:31:25'),
(44,4,'auth.login.success','Signed in: secretary (secretary)','127.0.0.1','curl/8.0.1','2026-11-13 09:31:25'),
(45,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:31:26'),
(46,7,'auth.login.success','Signed in: storekeeper (storekeeper)','127.0.0.1','curl/8.0.1','2026-11-13 09:31:26'),
(47,8,'auth.login.success','Signed in: kitchenmanager (kitchenmanager)','127.0.0.1','curl/8.0.1','2026-11-13 09:31:27'),
(48,6,'auth.login.success','Signed in: student (student)','127.0.0.1','curl/8.0.1','2026-11-13 09:31:27'),
(49,6,'auth.login.fail','Failed sign-in for student','127.0.0.1','curl/8.0.1','2026-11-13 09:31:28'),
(50,6,'auth.login.role_mismatch','Wrong portal for student','127.0.0.1','curl/8.0.1','2026-11-13 09:31:28'),
(51,1,'content.save','Site content saved (139 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:31:30'),
(52,1,'media.upload','Uploaded img_20261113_093130_2f4e3adecbe81266d819.png (68 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:31:30'),
(53,1,'media.upload','Uploaded img_20261113_093130_c2774e6b6d9b70f2d4eb.png (68 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:31:30'),
(54,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:31:31'),
(55,5,'auth.logout','Signed out','127.0.0.1','curl/8.0.1','2026-11-13 09:31:31'),
(61,1,'auth.login.success','Signed in: admin (admin)','127.0.0.1','curl/8.0.1','2026-11-13 09:45:01'),
(62,2,'auth.login.success','Signed in: headteacher (headteacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:45:01'),
(63,3,'auth.login.success','Signed in: chiefexaminer (chiefexaminer)','127.0.0.1','curl/8.0.1','2026-11-13 09:45:02'),
(64,4,'auth.login.success','Signed in: secretary (secretary)','127.0.0.1','curl/8.0.1','2026-11-13 09:45:02'),
(65,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:45:03'),
(66,7,'auth.login.success','Signed in: storekeeper (storekeeper)','127.0.0.1','curl/8.0.1','2026-11-13 09:45:03'),
(67,8,'auth.login.success','Signed in: kitchenmanager (kitchenmanager)','127.0.0.1','curl/8.0.1','2026-11-13 09:45:04'),
(68,6,'auth.login.success','Signed in: student (student)','127.0.0.1','curl/8.0.1','2026-11-13 09:45:04'),
(69,6,'auth.login.fail','Failed sign-in for student','127.0.0.1','curl/8.0.1','2026-11-13 09:45:05'),
(70,6,'auth.login.role_mismatch','Wrong portal for student','127.0.0.1','curl/8.0.1','2026-11-13 09:45:05'),
(71,1,'content.save','Site content saved (139 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:45:07'),
(72,1,'media.upload','Uploaded img_20261113_094507_6c93a06ab07526902dec.png (68 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:45:07'),
(73,1,'media.upload','Uploaded img_20261113_094507_0dbc12e7f14f75a48368.png (68 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:45:07'),
(74,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:45:08'),
(75,5,'auth.logout','Signed out','127.0.0.1','curl/8.0.1','2026-11-13 09:45:08'),
(81,1,'auth.login.success','Signed in: admin (admin)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:21'),
(82,2,'auth.login.success','Signed in: headteacher (headteacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:21'),
(83,3,'auth.login.success','Signed in: chiefexaminer (chiefexaminer)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:22'),
(84,4,'auth.login.success','Signed in: secretary (secretary)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:22'),
(85,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:23'),
(86,7,'auth.login.success','Signed in: storekeeper (storekeeper)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:23'),
(87,8,'auth.login.success','Signed in: kitchenmanager (kitchenmanager)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:24'),
(88,6,'auth.login.success','Signed in: student (student)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:24'),
(89,6,'auth.login.fail','Failed sign-in for student','127.0.0.1','curl/8.0.1','2026-11-13 09:53:25'),
(90,6,'auth.login.role_mismatch','Wrong portal for student','127.0.0.1','curl/8.0.1','2026-11-13 09:53:25'),
(91,1,'content.save','Site content saved (139 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:27'),
(92,1,'media.upload','Uploaded img_20261113_095327_ab9942cc72fcdf2d0438.png (68 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:27'),
(93,1,'media.upload','Uploaded img_20261113_095327_c5cbb5f0a9f12baf2e71.png (68 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:27'),
(94,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:28'),
(95,5,'auth.logout','Signed out','127.0.0.1','curl/8.0.1','2026-11-13 09:53:28'),
(101,1,'auth.login.success','Signed in: admin (admin)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:57'),
(102,2,'auth.login.success','Signed in: headteacher (headteacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:57'),
(103,3,'auth.login.success','Signed in: chiefexaminer (chiefexaminer)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:58'),
(104,4,'auth.login.success','Signed in: secretary (secretary)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:58'),
(105,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:59'),
(106,7,'auth.login.success','Signed in: storekeeper (storekeeper)','127.0.0.1','curl/8.0.1','2026-11-13 09:53:59'),
(107,8,'auth.login.success','Signed in: kitchenmanager (kitchenmanager)','127.0.0.1','curl/8.0.1','2026-11-13 09:54:00'),
(108,6,'auth.login.success','Signed in: student (student)','127.0.0.1','curl/8.0.1','2026-11-13 09:54:00'),
(109,6,'auth.login.fail','Failed sign-in for student','127.0.0.1','curl/8.0.1','2026-11-13 09:54:01'),
(110,6,'auth.login.role_mismatch','Wrong portal for student','127.0.0.1','curl/8.0.1','2026-11-13 09:54:01'),
(111,1,'content.save','Site content saved (139 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:54:03'),
(112,1,'media.upload','Uploaded img_20261113_095403_16f9f8e36872bef40fbb.png (68 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:54:03'),
(113,1,'media.upload','Uploaded img_20261113_095403_3736c4973bf501508cf6.png (68 bytes)','127.0.0.1','curl/8.0.1','2026-11-13 09:54:03'),
(114,5,'auth.login.success','Signed in: teacher (teacher)','127.0.0.1','curl/8.0.1','2026-11-13 09:54:04'),
(115,5,'auth.logout','Signed out','127.0.0.1','curl/8.0.1','2026-11-13 09:54:04'),
(121,1,'auth.login.success','Signed in: admin (admin)','127.0.0.1','curl/8.0.1','2026-11-13 09:54:21'),
(122,1,'auth.login.success','Signed in: admin (admin)','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','2026-11-13 09:56:27'),
(123,1,'content.save','Site content saved (63491 bytes)','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','2026-11-13 09:56:28'),
(124,1,'content.save','Site content saved (64434 bytes)','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','2026-11-13 09:56:29'),
(125,1,'content.save','Site content saved (64203 bytes)','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','2026-11-13 09:56:40'),
(126,1,'content.save','Site content saved (64203 bytes)','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','2026-11-13 10:11:43'),
(127,1,'auth.login.success','Signed in: admin (admin)','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','2026-11-13 10:40:44'),
(128,1,'content.save','Site content saved (64203 bytes)','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','2026-11-13 10:40:45'),
(129,1,'auth.login.success','Signed in: admin (admin)','127.0.0.1','curl/8.0.1','2026-11-13 10:55:04');
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classes`
--

DROP TABLE IF EXISTS `classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `classes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(64) NOT NULL,
  `name` varchar(120) NOT NULL DEFAULT '',
  `level` int(11) NOT NULL DEFAULT 0,
  `academic_year` varchar(64) NOT NULL DEFAULT '',
  `term` varchar(16) NOT NULL DEFAULT '',
  `teacher_legacy_id` varchar(64) NOT NULL DEFAULT '',
  `teacher_name` varchar(190) NOT NULL DEFAULT '',
  `subjects` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`subjects`)),
  `status` varchar(32) NOT NULL DEFAULT 'active',
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_classes_legacy` (`legacy_id`),
  KEY `idx_classes_name` (`name`),
  KEY `idx_classes_teacher` (`teacher_legacy_id`),
  KEY `idx_classes_year` (`academic_year`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classes`
--

LOCK TABLES `classes` WRITE;
/*!40000 ALTER TABLE `classes` DISABLE KEYS */;
INSERT INTO `classes` VALUES
(1,'mw2tk846r75c6s','PG X',1,'2026','1','mw2tk84bm26v5h','Emmah Wanjiru Ndonga','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846r75c6s\",\"name\":\"PG X\",\"level\":1,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84bm26v5h\",\"teacherName\":\"Emmah Wanjiru Ndonga\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'mw2tk8460vsooq','PG Y',2,'2026','1','mw2tk84b80ybup','Grace Wambui Gichuhi','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk8460vsooq\",\"name\":\"PG Y\",\"level\":2,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84b80ybup\",\"teacherName\":\"Grace Wambui Gichuhi\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(3,'mw2tk846ku5gg3','PG W',3,'2026','1','','','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846ku5gg3\",\"name\":\"PG W\",\"level\":3,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"\",\"teacherName\":\"\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(4,'mw2tk846mv9lkf','PP1 X',4,'2026','1','mw2tk84b9geev4','Jacinta Wanjiku Ngunyi','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846mv9lkf\",\"name\":\"PP1 X\",\"level\":4,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84b9geev4\",\"teacherName\":\"Jacinta Wanjiku Ngunyi\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(5,'mw2tk846pc3z8u','PP1 Y',5,'2026','1','mw2tk84byldhf7','Veronicah Wangari Ndiritu','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846pc3z8u\",\"name\":\"PP1 Y\",\"level\":5,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84byldhf7\",\"teacherName\":\"Veronicah Wangari Ndiritu\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(6,'mw2tk846fx83ts','PP1 W',6,'2026','1','mw2tk84b45mfgm','Emmah Nyawira Maina','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846fx83ts\",\"name\":\"PP1 W\",\"level\":6,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84b45mfgm\",\"teacherName\":\"Emmah Nyawira Maina\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(7,'mw2tk846nzxrwr','PP2 X',7,'2026','1','mw2tk84cghtb8n','Joyce Wairimu Nderitu','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846nzxrwr\",\"name\":\"PP2 X\",\"level\":7,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84cghtb8n\",\"teacherName\":\"Joyce Wairimu Nderitu\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(8,'mw2tk846v37dqe','PP2 Y',8,'2026','1','mw2tk84cjifuyk','Laurisia Njeri Gacheru','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846v37dqe\",\"name\":\"PP2 Y\",\"level\":8,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84cjifuyk\",\"teacherName\":\"Laurisia Njeri Gacheru\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(9,'mw2tk846lfx58m','PP2 W',9,'2026','1','mw2tk84ceudo5o','Tabitha Wamuyu Kariuki','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846lfx58m\",\"name\":\"PP2 W\",\"level\":9,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84ceudo5o\",\"teacherName\":\"Tabitha Wamuyu Kariuki\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(10,'mw2tk84615gu3j','Grade 1: Mt. Kenya',10,'2026','1','mw2tk84d56h6q3','Tr. Margaret','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk84615gu3j\",\"name\":\"Grade 1: Mt. Kenya\",\"level\":10,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84d56h6q3\",\"teacherName\":\"Tr. Margaret\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(11,'mw2tk846xem40k','Grade 1: Mt. Ruwenzori',11,'2026','1','mw2tk84d4yb5q4','Tr. Carol','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846xem40k\",\"name\":\"Grade 1: Mt. Ruwenzori\",\"level\":11,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84d4yb5q4\",\"teacherName\":\"Tr. Carol\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(12,'mw2tk846dnewy1','Grade 1: Mt. Kilimanjaro',12,'2026','1','mw2tk84d9nugqg','Tr. Eva','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846dnewy1\",\"name\":\"Grade 1: Mt. Kilimanjaro\",\"level\":12,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84d9nugqg\",\"teacherName\":\"Tr. Eva\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(13,'mw2tk846ln02ke','Grade 2: Mt. Kenya',13,'2026','1','mw2tk84dosz801','Tr. Gladwel','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846ln02ke\",\"name\":\"Grade 2: Mt. Kenya\",\"level\":13,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84dosz801\",\"teacherName\":\"Tr. Gladwel\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(14,'mw2tk846dnn3xg','Grade 2: Mt. Ruwenzori',14,'2026','1','mw2tk84dxo7xgh','Tr. Alice','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846dnn3xg\",\"name\":\"Grade 2: Mt. Ruwenzori\",\"level\":14,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84dxo7xgh\",\"teacherName\":\"Tr. Alice\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(15,'mw2tk8465xm1nj','Grade 2: Mt. Kilimanjaro',15,'2026','1','mw2tk84d2k99ur','Tr. Jacinta','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk8465xm1nj\",\"name\":\"Grade 2: Mt. Kilimanjaro\",\"level\":15,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84d2k99ur\",\"teacherName\":\"Tr. Jacinta\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(16,'mw2tk84675gp93','Grade 3: Mt. Kenya',16,'2026','1','mw2tk84dl9r7wl','Tr. Eliza','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk84675gp93\",\"name\":\"Grade 3: Mt. Kenya\",\"level\":16,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84dl9r7wl\",\"teacherName\":\"Tr. Eliza\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(17,'mw2tk8464dr96k','Grade 3: Mt. Ruwenzori',17,'2026','1','mw2tk84dwhrwrx','Tr. Mary','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk8464dr96k\",\"name\":\"Grade 3: Mt. Ruwenzori\",\"level\":17,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84dwhrwrx\",\"teacherName\":\"Tr. Mary\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(18,'mw2tk846h8oqbo','Grade 3: Mt. Kilimanjaro',18,'2026','1','mw2tk84dbdle7k','Tr. Doris','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846h8oqbo\",\"name\":\"Grade 3: Mt. Kilimanjaro\",\"level\":18,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84dbdle7k\",\"teacherName\":\"Tr. Doris\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(19,'mw2tk846b6xnnd','Grade 4: Mt. Kenya',19,'2026','1','mw2tk84ddkcbb7','Tr. James','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846b6xnnd\",\"name\":\"Grade 4: Mt. Kenya\",\"level\":19,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84ddkcbb7\",\"teacherName\":\"Tr. James\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(20,'mw2tk846396n24','Grade 4: Mt. Ruwenzori',20,'2026','1','mw2tk84d3l5jvg','Tr. Peris','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846396n24\",\"name\":\"Grade 4: Mt. Ruwenzori\",\"level\":20,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84d3l5jvg\",\"teacherName\":\"Tr. Peris\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(21,'mw2tk8468zfsdq','Grade 4: Mt. Kilimanjaro',21,'2026','1','mw2tk846iiet7j','David Chen','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk8468zfsdq\",\"name\":\"Grade 4: Mt. Kilimanjaro\",\"level\":21,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk846iiet7j\",\"teacherName\":\"David Chen\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\",\"updatedAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(22,'mw2tk846tok1vp','Grade 5: Mt. Kenya',22,'2026','1','mw2tk84diabatp','Tr. Fidelis','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846tok1vp\",\"name\":\"Grade 5: Mt. Kenya\",\"level\":22,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84diabatp\",\"teacherName\":\"Tr. Fidelis\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(23,'mw2tk846itvut3','Grade 5: Mt. Ruwenzori',23,'2026','1','mw2tk84ecfc12k','Tr. Doreen','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846itvut3\",\"name\":\"Grade 5: Mt. Ruwenzori\",\"level\":23,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84ecfc12k\",\"teacherName\":\"Tr. Doreen\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(24,'mw2tk8466l4e2i','Grade 5: Mt. Kilimanjaro',24,'2026','1','mw2tk84do4zo99','Mr. Maina','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk8466l4e2i\",\"name\":\"Grade 5: Mt. Kilimanjaro\",\"level\":24,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84do4zo99\",\"teacherName\":\"Mr. Maina\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(25,'mw2tk846s7579u','Grade 6: Mt. Kenya',25,'2026','1','mw2tk84e0bmy51','Tr. Dennis','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846s7579u\",\"name\":\"Grade 6: Mt. Kenya\",\"level\":25,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84e0bmy51\",\"teacherName\":\"Tr. Dennis\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(26,'mw2tk846a8c9t1','Grade 6: Mt. Ruwenzori',26,'2026','1','mw2tk84eqdweo9','Tr. Emmanuel','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846a8c9t1\",\"name\":\"Grade 6: Mt. Ruwenzori\",\"level\":26,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84eqdweo9\",\"teacherName\":\"Tr. Emmanuel\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(27,'mw2tk846jgdz4b','Grade 6: Mt. Kilimanjaro',27,'2026','1','mw2tk84etpi8px','Mr. Macharia','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846jgdz4b\",\"name\":\"Grade 6: Mt. Kilimanjaro\",\"level\":27,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84etpi8px\",\"teacherName\":\"Mr. Macharia\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(28,'mw2tk846axyse0','Grade 7: Mwai Kibaki',28,'2026','1','mw2tk84ej63rr4','Mr. Kisaka','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846axyse0\",\"name\":\"Grade 7: Mwai Kibaki\",\"level\":28,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84ej63rr4\",\"teacherName\":\"Mr. Kisaka\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(29,'mw2tk846gw8u3u','Grade 7: Wangari Maathai',29,'2026','1','mw2tk84ebxbxqo','Tr. Priscilla','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846gw8u3u\",\"name\":\"Grade 7: Wangari Maathai\",\"level\":29,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84ebxbxqo\",\"teacherName\":\"Tr. Priscilla\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(30,'mw2tk846li0j8z','Grade 8: Mwai Kibaki',30,'2026','1','mw2tk84eu86nus','Tr. Gladys W','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846li0j8z\",\"name\":\"Grade 8: Mwai Kibaki\",\"level\":30,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84eu86nus\",\"teacherName\":\"Tr. Gladys W\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(31,'mw2tk84620w2yc','Grade 8: Wangari Maathai',31,'2026','1','mw2tk84ehvim70','Tr. Lewis','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk84620w2yc\",\"name\":\"Grade 8: Wangari Maathai\",\"level\":31,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84ehvim70\",\"teacherName\":\"Tr. Lewis\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(32,'mw2tk8467imy6h','Grade 9: Mwai Kibaki',32,'2026','1','mw2tk84etraavt','Mrs. Mwangi','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk8467imy6h\",\"name\":\"Grade 9: Mwai Kibaki\",\"level\":32,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84etraavt\",\"teacherName\":\"Mrs. Mwangi\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(33,'mw2tk846gf27ez','Grade 9: Wangari Maathai',33,'2026','1','mw2tk84eokjre2','Tr. Korir','[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"]','active','{\"id\":\"mw2tk846gf27ez\",\"name\":\"Grade 9: Wangari Maathai\",\"level\":33,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84eokjre2\",\"teacherName\":\"Tr. Korir\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(120) DEFAULT NULL,
  `name` varchar(190) NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `interest` varchar(120) DEFAULT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `status` varchar(16) NOT NULL DEFAULT 'new',
  `ip` varchar(45) DEFAULT NULL,
  `is_demo` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_contact_legacy` (`legacy_id`),
  KEY `idx_contact_created` (`created_at`),
  KEY `idx_contact_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_messages`
--

LOCK TABLES `contact_messages` WRITE;
/*!40000 ALTER TABLE `contact_messages` DISABLE KEYS */;
INSERT INTO `contact_messages` VALUES
(1,'seed-contact-1','Demo Parent','parent.demo@example.com','+254 700 000 001','Admissions','Sample enquiry created by database/seed.php for local testing only.',0,'new',NULL,1,'2026-11-13 07:42:52','2026-11-13 07:42:52'),
(2,'seed-contact-2','Demo Visitor','visitor.demo@example.com','+254 700 000 002','General','Second sample enquiry created for local testing only.',0,'new',NULL,1,'2026-11-13 07:42:52','2026-11-13 07:42:52');
/*!40000 ALTER TABLE `contact_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_documents`
--

DROP TABLE IF EXISTS `content_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_documents` (
  `doc_key` varchar(64) NOT NULL,
  `doc_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`doc_value`)),
  `updated_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`doc_key`),
  KEY `fk_content_user` (`updated_by`),
  CONSTRAINT `fk_content_user` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_documents`
--

LOCK TABLES `content_documents` WRITE;
/*!40000 ALTER TABLE `content_documents` DISABLE KEYS */;
INSERT INTO `content_documents` VALUES
('logo','{\"name\":\"St. Teresa Kanyange Academy\",\"initials\":\"STK\"}',NULL,'2026-11-13 10:53:59','2026-11-13 10:53:59'),
('settings','{\"schoolName\": \"St. Teresa Kanyange Academy\", \"motto\": \"Unity is Strength\", \"currency\": \"Ksh\", \"academicYear\": \"2026\", \"term\": \"1\", \"timezone\": \"Africa/Nairobi\", \"academicYearId\": \"mw2tk849i1pspg\"}',NULL,'2026-11-13 10:53:59','2026-11-13 10:55:28');
/*!40000 ALTER TABLE `content_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_attendance`
--

DROP TABLE IF EXISTS `domain_attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_attendance` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_attendance_legacy` (`legacy_id`),
  KEY `idx_domain_attendance_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_attendance`
--

LOCK TABLES `domain_attendance` WRITE;
/*!40000 ALTER TABLE `domain_attendance` DISABLE KEYS */;
INSERT INTO `domain_attendance` VALUES
(1,'mw4ipvb80iisc0','{\"id\":\"mw4ipvb80iisc0\",\"classId\":\"mw2tk8468zfsdq\",\"className\":\"Grade 4: Mt. Kilimanjaro\",\"date\":\"2026-11-06\",\"studentId\":\"mw4imn86ijwr30\",\"studentName\":\"Nicholas Ngatia\",\"admissionNo\":\"1111\",\"status\":\"present\",\"arrivalTime\":\"08:12\",\"remarks\":\"\",\"markedBy\":\"David Chen\",\"markedAt\":\"2026-11-06T05:13:44.397Z\",\"auditTrail\":[{\"by\":\"David Chen\",\"at\":\"2026-11-06T05:13:22.084Z\",\"from\":\"present\",\"to\":\"absent\",\"reason\":\"Correction\"},{\"by\":\"David Chen\",\"at\":\"2026-11-06T05:13:35.556Z\",\"from\":\"absent\",\"to\":\"late\",\"reason\":\"Correction\"},{\"by\":\"David Chen\",\"at\":\"2026-11-06T05:13:39.507Z\",\"from\":\"late\",\"to\":\"excused\",\"reason\":\"Correction\"},{\"by\":\"David Chen\",\"at\":\"2026-11-06T05:13:44.397Z\",\"from\":\"excused\",\"to\":\"present\",\"reason\":\"Correction\"}]}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `domain_attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_audit_log`
--

DROP TABLE IF EXISTS `domain_audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_audit_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_audit_log_legacy` (`legacy_id`),
  KEY `idx_domain_audit_log_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_audit_log`
--

LOCK TABLES `domain_audit_log` WRITE;
/*!40000 ALTER TABLE `domain_audit_log` DISABLE KEYS */;
INSERT INTO `domain_audit_log` VALUES
(1,'mw2u3ak9qnqlk3','{\"id\":\"mw2u3ak9qnqlk3\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"timetable.class.seed\",\"details\":\"33 default class(es) added\",\"timestamp\":\"2026-11-05T00:55:19.353Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'mw2u3mb19bp5wa','{\"id\":\"mw2u3mb19bp5wa\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"student.delete\",\"details\":\"Emily Johnson (STA-2025-002) deleted. Reason: Emily Johnson. Preserved history — attendance:0 results:0 payments:1 submissions:0.\",\"timestamp\":\"2026-11-05T00:55:34.573Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(3,'mw2u3t7p44gvl3','{\"id\":\"mw2u3t7p44gvl3\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"student.delete\",\"details\":\"John Smith (STA-2024-001) deleted. Reason: John Smith. Preserved history — attendance:0 results:0 payments:1 submissions:0.\",\"timestamp\":\"2026-11-05T00:55:43.525Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(4,'mw2u5eecyjddy8','{\"id\":\"mw2u5eecyjddy8\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"auth.account.create\",\"details\":\"Account created for nngatiagrade4mtkenya (student)\",\"timestamp\":\"2026-11-05T00:56:57.636Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(5,'mw2u5eeesxoj65','{\"id\":\"mw2u5eeesxoj65\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"student.admit\",\"details\":\"NICHOLAS NGATIA (1111 → Grade 4: Mt. Kenya, 2026 T1)\",\"timestamp\":\"2026-11-05T00:56:57.638Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(6,'mw2u5rybpcuumn','{\"id\":\"mw2u5rybpcuumn\",\"userId\":\"\",\"userName\":\"system\",\"role\":\"system\",\"action\":\"auth.logout\",\"details\":\"Signed out: admin\",\"timestamp\":\"2026-11-05T00:57:15.203Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(7,'mw2u6nxbuv6uyp','{\"id\":\"mw2u6nxbuv6uyp\",\"userId\":\"mw2u5ed9wao2sg\",\"userName\":\"NICHOLAS NGATIA\",\"role\":\"student\",\"action\":\"auth.password.change\",\"details\":\"Password changed for nngatiagrade4mtkenya (student)\",\"timestamp\":\"2026-11-05T00:57:56.639Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(8,'mw2v721yntyy3n','{\"id\":\"mw2v721yntyy3n\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"account.update\",\"details\":\"Updated David → role teacher, status active\",\"timestamp\":\"2026-11-05T01:26:14.566Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(9,'mw2v7zzlx5k2re','{\"id\":\"mw2v7zzlx5k2re\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"auth.password.reset\",\"details\":\"Temporary password issued for David (teacher) — Admin-assisted reset\",\"timestamp\":\"2026-11-05T01:26:58.545Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(10,'mw2v8nntytxwcx','{\"id\":\"mw2v8nntytxwcx\",\"userId\":\"\",\"userName\":\"system\",\"role\":\"system\",\"action\":\"auth.logout\",\"details\":\"Signed out: secretary\",\"timestamp\":\"2026-11-05T01:27:29.225Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(11,'mw2v9eeoohs670','{\"id\":\"mw2v9eeoohs670\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"auth.password.change\",\"details\":\"Password changed for David (teacher)\",\"timestamp\":\"2026-11-05T01:28:03.888Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(12,'mw2vbr3l52w9wp','{\"id\":\"mw2vbr3l52w9wp\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"submission.create\",\"details\":\"STA/SUB/2026/0001 · Math (Homework / Assignment)\",\"timestamp\":\"2026-11-05T01:29:53.649Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(13,'mw2vbr3mtww3ag','{\"id\":\"mw2vbr3mtww3ag\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"homework.create\",\"details\":\"Math (Grade 4: Mt. Kenya) - submitted for approval STA/SUB/2026/0001\",\"timestamp\":\"2026-11-05T01:29:53.650Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(14,'mw2vbw16ggy5u6','{\"id\":\"mw2vbw16ggy5u6\",\"userId\":\"\",\"userName\":\"system\",\"role\":\"system\",\"action\":\"auth.logout\",\"details\":\"Signed out: David\",\"timestamp\":\"2026-11-05T01:30:00.042Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(15,'mw2vcqam5zpdcz','{\"id\":\"mw2vcqam5zpdcz\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"account.update\",\"details\":\"Updated chiefexaminer → role chiefexaminer, status active\",\"timestamp\":\"2026-11-05T01:30:39.262Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(16,'mw2vcrz0rinfhe','{\"id\":\"mw2vcrz0rinfhe\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"auth.password.reset\",\"details\":\"Temporary password issued for chiefexaminer (chiefexaminer) — Admin-assisted reset\",\"timestamp\":\"2026-11-05T01:30:41.436Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(17,'mw2vd9drgnpcc4','{\"id\":\"mw2vd9drgnpcc4\",\"userId\":\"mw2tk845vyp15w\",\"userName\":\"Mr. Anthony Rossi\",\"role\":\"chiefexaminer\",\"action\":\"auth.password.change\",\"details\":\"Password changed for chiefexaminer (chiefexaminer)\",\"timestamp\":\"2026-11-05T01:31:03.999Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(18,'mw2vdgbu2of5sj','{\"id\":\"mw2vdgbu2of5sj\",\"userId\":\"mw2tk845vyp15w\",\"userName\":\"Mr. Anthony Rossi\",\"role\":\"chiefexaminer\",\"action\":\"submission.approve\",\"details\":\"STA/SUB/2026/0001 approved at chiefexaminer by Mr. Anthony Rossi\",\"timestamp\":\"2026-11-05T01:31:13.002Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(19,'mw2veslfw4jvm6','{\"id\":\"mw2veslfw4jvm6\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"account.update\",\"details\":\"Updated headteacher → role headteacher, status active\",\"timestamp\":\"2026-11-05T01:32:15.555Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(20,'mw2vezn78ea29z','{\"id\":\"mw2vezn78ea29z\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"auth.password.reset\",\"details\":\"Temporary password issued for headteacher (headteacher) — Admin-assisted reset\",\"timestamp\":\"2026-11-05T01:32:24.691Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(21,'mw2vfgfyh5jpit','{\"id\":\"mw2vfgfyh5jpit\",\"userId\":\"mw2tk845mk9wnr\",\"userName\":\"Sr. Catherine Marie\",\"role\":\"headteacher\",\"action\":\"auth.password.change\",\"details\":\"Password changed for headteacher (headteacher)\",\"timestamp\":\"2026-11-05T01:32:46.462Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(22,'mw2vfk9uug3px3','{\"id\":\"mw2vfk9uug3px3\",\"userId\":\"mw2tk845mk9wnr\",\"userName\":\"Sr. Catherine Marie\",\"role\":\"headteacher\",\"action\":\"submission.approve\",\"details\":\"STA/SUB/2026/0001 approved at headteacher by Sr. Catherine Marie\",\"timestamp\":\"2026-11-05T01:32:51.426Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(23,'mw2vgdqpdanzzu','{\"id\":\"mw2vgdqpdanzzu\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"submission.approve\",\"details\":\"STA/SUB/2026/0001 approved at secretary by Ms. Linda Vasquez\",\"timestamp\":\"2026-11-05T01:33:29.617Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(24,'mw2vh2wkbae9st','{\"id\":\"mw2vh2wkbae9st\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"submission.publish\",\"details\":\"STA/SUB/2026/0001 published to student portal by Ms. Linda Vasquez\",\"timestamp\":\"2026-11-05T01:34:02.228Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(25,'mw2vjfy4yfbqly','{\"id\":\"mw2vjfy4yfbqly\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"homework.delete\",\"details\":\"Math\",\"timestamp\":\"2026-11-05T01:35:52.445Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(26,'mw2volqpqhmuvm','{\"id\":\"mw2volqpqhmuvm\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"submission.delete\",\"details\":\"STA/SUB/2026/0001 · Math deleted by David Chen (owner)\",\"timestamp\":\"2026-11-05T01:39:53.233Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(27,'mw2vyb0xl1hajn','{\"id\":\"mw2vyb0xl1hajn\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"class.teacher.unassign\",\"details\":\"Grade 4: Mt. Kilimanjaro\",\"timestamp\":\"2026-11-05T01:47:25.905Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(28,'mw2vynhqhez9kq','{\"id\":\"mw2vynhqhez9kq\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"class.update\",\"details\":\"Grade 4: Mt. Kilimanjaro (2026)\",\"timestamp\":\"2026-11-05T01:47:42.062Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(29,'mw2w04p28xgrrm','{\"id\":\"mw2w04p28xgrrm\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"class.teacher.assign\",\"details\":\"David Chen → Grade 4: Mt. Kilimanjaro\",\"timestamp\":\"2026-11-05T01:48:51.014Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(30,'mw4hxfbw5frc0v','{\"id\":\"mw4hxfbw5frc0v\",\"userId\":\"\",\"userName\":\"system\",\"role\":\"system\",\"action\":\"auth.logout\",\"details\":\"Signed out: David\",\"timestamp\":\"2026-11-06T04:50:22.556Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(31,'mw4ibs71509dis','{\"id\":\"mw4ibs71509dis\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"student.update\",\"details\":\"NICHOLAS NGATIA (1111)\",\"timestamp\":\"2026-11-06T05:01:32.413Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(32,'mw4ie41g0tygdn','{\"id\":\"mw4ie41g0tygdn\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"student.update\",\"details\":\"NICHOLAS NGATIA (1111)\",\"timestamp\":\"2026-11-06T05:03:21.076Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(33,'mw4if60u7h88ik','{\"id\":\"mw4if60u7h88ik\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"student.delete\",\"details\":\"NICHOLAS NGATIA (1111) deleted. Reason: NICHOLAS NGATIA. Preserved history — attendance:0 results:0 payments:0 submissions:0.\",\"timestamp\":\"2026-11-06T05:04:10.302Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(34,'mw4imn9ifhggv8','{\"id\":\"mw4imn9ifhggv8\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"auth.account.create\",\"details\":\"Account created for nngatiagrade4mtkilimanjaro (student)\",\"timestamp\":\"2026-11-06T05:09:59.238Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(35,'mw4imn9mmqc4p1','{\"id\":\"mw4imn9mmqc4p1\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"student.admit\",\"details\":\"Nicholas Ngatia (1111 → Grade 4: Mt. Kilimanjaro, 2026 T1)\",\"timestamp\":\"2026-11-06T05:09:59.242Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(36,'mw4inthk15t4y4','{\"id\":\"mw4inthk15t4y4\",\"userId\":\"mw4imn86ijwr30\",\"userName\":\"Nicholas Ngatia\",\"role\":\"student\",\"action\":\"auth.password.change\",\"details\":\"Password changed for nngatiagrade4mtkilimanjaro (student)\",\"timestamp\":\"2026-11-06T05:10:53.960Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(37,'mw4ipvb9ppugcz','{\"id\":\"mw4ipvb9ppugcz\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"attendance.save\",\"details\":\"Grade 4: Mt. Kilimanjaro 2026-11-06 (1 new, 0 corrected)\",\"timestamp\":\"2026-11-06T05:12:29.637Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(38,'mw4iqzs405wbaz','{\"id\":\"mw4iqzs405wbaz\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"attendance.save\",\"details\":\"Grade 4: Mt. Kilimanjaro 2026-11-06 (0 new, 1 corrected)\",\"timestamp\":\"2026-11-06T05:13:22.084Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(39,'mw4ira6d5xibge','{\"id\":\"mw4ira6d5xibge\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"attendance.save\",\"details\":\"Grade 4: Mt. Kilimanjaro 2026-11-06 (0 new, 1 corrected)\",\"timestamp\":\"2026-11-06T05:13:35.557Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(40,'mw4ird84pik3jx','{\"id\":\"mw4ird84pik3jx\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"attendance.save\",\"details\":\"Grade 4: Mt. Kilimanjaro 2026-11-06 (0 new, 1 corrected)\",\"timestamp\":\"2026-11-06T05:13:39.508Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(41,'mw4irgzxe8m8iu','{\"id\":\"mw4irgzxe8m8iu\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"attendance.save\",\"details\":\"Grade 4: Mt. Kilimanjaro 2026-11-06 (0 new, 1 corrected)\",\"timestamp\":\"2026-11-06T05:13:44.397Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(42,'mw4it0rkyh9bq0','{\"id\":\"mw4it0rkyh9bq0\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"auth.account.create\",\"details\":\"Account created for nngatiagrade4mtkenya (student)\",\"timestamp\":\"2026-11-06T05:14:56.672Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(43,'mw4it0rllj7tm8','{\"id\":\"mw4it0rllj7tm8\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"student.admit\",\"details\":\"Nicholas Ngatia (1112 → Grade 4: Mt. Kenya, 2026 T1)\",\"timestamp\":\"2026-11-06T05:14:56.673Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(44,'mw4it9qzxikb50','{\"id\":\"mw4it9qzxikb50\",\"userId\":\"\",\"userName\":\"system\",\"role\":\"system\",\"action\":\"auth.logout\",\"details\":\"Signed out: nngatiagrade4mtkilimanjaro\",\"timestamp\":\"2026-11-06T05:15:08.315Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(45,'mw4iuapgoae6gl','{\"id\":\"mw4iuapgoae6gl\",\"userId\":\"mw4it0qblwy2r7\",\"userName\":\"Nicholas Ngatia\",\"role\":\"student\",\"action\":\"auth.password.change\",\"details\":\"Password changed for nngatiagrade4mtkenya (student)\",\"timestamp\":\"2026-11-06T05:15:56.212Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(46,'mw4jiiqrdvep56','{\"id\":\"mw4jiiqrdvep56\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"payment.delete\",\"details\":\"RCP-1001 · Ksh 4,200.00 · John Smith · balance now Ksh 0.00\",\"timestamp\":\"2026-11-06T05:34:46.371Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(47,'mw4jimaqaei6j2','{\"id\":\"mw4jimaqaei6j2\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"payment.delete\",\"details\":\"RCP-1002 · Ksh 300.00 · Emily Johnson · balance now Ksh 0.00\",\"timestamp\":\"2026-11-06T05:34:50.978Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(48,'mw4jld09euhh16','{\"id\":\"mw4jld09euhh16\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"payment.record\",\"details\":\"RCP-1003 · Nicholas Ngatia · Ksh 2,000.00 · actual 2026-11-02 · recorded 2026-11-06 08:36:58 (Africa/Nairobi) · Equity Bank · term 1 2026 · balance now Ksh 0.00\",\"timestamp\":\"2026-11-06T05:36:58.905Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `domain_audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_class_assignments`
--

DROP TABLE IF EXISTS `domain_class_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_class_assignments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_class_assignments_legacy` (`legacy_id`),
  KEY `idx_domain_class_assignments_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_class_assignments`
--

LOCK TABLES `domain_class_assignments` WRITE;
/*!40000 ALTER TABLE `domain_class_assignments` DISABLE KEYS */;
INSERT INTO `domain_class_assignments` VALUES
(1,'mw2w04p287f8hd','{\"id\":\"mw2w04p287f8hd\",\"classId\":\"mw2tk8468zfsdq\",\"className\":\"Grade 4: Mt. Kilimanjaro\",\"teacherId\":\"mw2tk846iiet7j\",\"teacherName\":\"David Chen\",\"assignedAt\":\"2026-11-05\",\"assignedBy\":\"System Administrator\",\"replacedAt\":\"\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `domain_class_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_class_fee_structures`
--

DROP TABLE IF EXISTS `domain_class_fee_structures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_class_fee_structures` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_class_fee_structures_legacy` (`legacy_id`),
  KEY `idx_domain_class_fee_structures_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_class_fee_structures`
--

LOCK TABLES `domain_class_fee_structures` WRITE;
/*!40000 ALTER TABLE `domain_class_fee_structures` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_class_fee_structures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_exam_results`
--

DROP TABLE IF EXISTS `domain_exam_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_exam_results` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_exam_results_legacy` (`legacy_id`),
  KEY `idx_domain_exam_results_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_exam_results`
--

LOCK TABLES `domain_exam_results` WRITE;
/*!40000 ALTER TABLE `domain_exam_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_exam_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_exam_schedule`
--

DROP TABLE IF EXISTS `domain_exam_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_exam_schedule` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_exam_schedule_legacy` (`legacy_id`),
  KEY `idx_domain_exam_schedule_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_exam_schedule`
--

LOCK TABLES `domain_exam_schedule` WRITE;
/*!40000 ALTER TABLE `domain_exam_schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_exam_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_exams`
--

DROP TABLE IF EXISTS `domain_exams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_exams` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_exams_legacy` (`legacy_id`),
  KEY `idx_domain_exams_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_exams`
--

LOCK TABLES `domain_exams` WRITE;
/*!40000 ALTER TABLE `domain_exams` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_exams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_fee_charges`
--

DROP TABLE IF EXISTS `domain_fee_charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_fee_charges` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_fee_charges_legacy` (`legacy_id`),
  KEY `idx_domain_fee_charges_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_fee_charges`
--

LOCK TABLES `domain_fee_charges` WRITE;
/*!40000 ALTER TABLE `domain_fee_charges` DISABLE KEYS */;
INSERT INTO `domain_fee_charges` VALUES
(1,'mw2tkdyydk1dns','{\"id\":\"mw2tkdyydk1dns\",\"studentId\":\"mw2tk846ea2dbz\",\"className\":\"Grade 9\",\"academicYear\":\"2024\",\"term\":\"1\",\"source\":\"legacy\",\"item\":\"Opening balance brought forward\",\"amount\":4200,\"reason\":\"Migrated from the pre-existing fee balance — no balance was reset or re-charged.\",\"createdAt\":\"2026-11-05T00:40:37.306Z\",\"reversed\":false,\"createdBy\":\"migration\",\"createdByRole\":\"admin\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'mw2tkdyybjid5y','{\"id\":\"mw2tkdyybjid5y\",\"studentId\":\"mw2tk846aia0iv\",\"className\":\"Grade 9\",\"academicYear\":\"2025\",\"term\":\"1\",\"source\":\"legacy\",\"item\":\"Opening balance brought forward\",\"amount\":12800,\"reason\":\"Migrated from the pre-existing fee balance — no balance was reset or re-charged.\",\"createdAt\":\"2026-11-05T00:40:37.306Z\",\"reversed\":false,\"createdBy\":\"migration\",\"createdByRole\":\"admin\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(3,'mw2u5eedv9f6hn','{\"id\":\"mw2u5eedv9f6hn\",\"createdAt\":\"2026-11-05T00:56:57.637Z\",\"reversed\":false,\"createdBy\":\"Ms. Linda Vasquez\",\"createdByRole\":\"secretary\",\"studentId\":\"mw2u5ed9wao2sg\",\"className\":\"Grade 4: Mt. Kenya\",\"academicYear\":\"2026\",\"term\":\"1\",\"source\":\"legacy\",\"item\":\"Opening balance\",\"amount\":2000,\"reason\":\"Balance carried into the fee ledger at admission.\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(4,'mw4imn9lcvzihj','{\"id\":\"mw4imn9lcvzihj\",\"createdAt\":\"2026-11-06T05:09:59.241Z\",\"reversed\":false,\"createdBy\":\"Ms. Linda Vasquez\",\"createdByRole\":\"secretary\",\"studentId\":\"mw4imn86ijwr30\",\"className\":\"Grade 4: Mt. Kilimanjaro\",\"academicYear\":\"2026\",\"term\":\"1\",\"source\":\"legacy\",\"item\":\"Opening balance\",\"amount\":2000,\"reason\":\"Balance carried into the fee ledger at admission.\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `domain_fee_charges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_fee_items`
--

DROP TABLE IF EXISTS `domain_fee_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_fee_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_fee_items_legacy` (`legacy_id`),
  KEY `idx_domain_fee_items_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_fee_items`
--

LOCK TABLES `domain_fee_items` WRITE;
/*!40000 ALTER TABLE `domain_fee_items` DISABLE KEYS */;
INSERT INTO `domain_fee_items` VALUES
(1,'tuition','{\"id\":\"tuition\",\"name\":\"Tuition Fee\",\"price\":4200,\"icon\":\"fa-graduation-cap\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'admission','{\"id\":\"admission\",\"name\":\"Admission Fee\",\"price\":500,\"icon\":\"fa-file-signature\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(3,'lab','{\"id\":\"lab\",\"name\":\"Laboratory Fee\",\"price\":300,\"icon\":\"fa-flask\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(4,'library','{\"id\":\"library\",\"name\":\"Library Fee\",\"price\":150,\"icon\":\"fa-book\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(5,'transport','{\"id\":\"transport\",\"name\":\"Transport Fee\",\"price\":800,\"icon\":\"fa-bus\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(6,'uniform','{\"id\":\"uniform\",\"name\":\"Uniform Fee\",\"price\":220,\"icon\":\"fa-tshirt\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(7,'sports','{\"id\":\"sports\",\"name\":\"Sports Fee\",\"price\":180,\"icon\":\"fa-futbol\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(8,'exam','{\"id\":\"exam\",\"name\":\"Exam Fee\",\"price\":120,\"icon\":\"fa-pen\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(9,'activity','{\"id\":\"activity\",\"name\":\"Activity Fee\",\"price\":250,\"icon\":\"fa-palette\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(10,'meal','{\"id\":\"meal\",\"name\":\"Meal Plan\",\"price\":650,\"icon\":\"fa-utensils\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `domain_fee_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_fee_notification_log`
--

DROP TABLE IF EXISTS `domain_fee_notification_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_fee_notification_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_fee_notification_log_legacy` (`legacy_id`),
  KEY `idx_domain_fee_notification_log_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_fee_notification_log`
--

LOCK TABLES `domain_fee_notification_log` WRITE;
/*!40000 ALTER TABLE `domain_fee_notification_log` DISABLE KEYS */;
INSERT INTO `domain_fee_notification_log` VALUES
(1,'mw2tkf523fvgt7','{\"id\":\"mw2tkf523fvgt7\",\"key\":\"fee:first_outstanding:mw2tk846aia0iv:2025:1\",\"rule\":\"first_outstanding\",\"studentId\":\"mw2tk846aia0iv\",\"at\":\"2026-11-05T00:40:38.822Z\",\"meta\":{\"balance\":12500,\"year\":\"2025\",\"term\":\"1\"}}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'mw2u5ma3bvnuh6','{\"id\":\"mw2u5ma3bvnuh6\",\"key\":\"fee:first_outstanding:mw2u5ed9wao2sg:2026:1\",\"rule\":\"first_outstanding\",\"studentId\":\"mw2u5ed9wao2sg\",\"at\":\"2026-11-05T00:57:07.851Z\",\"meta\":{\"balance\":2000,\"year\":\"2026\",\"term\":\"1\"}}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(3,'mw4jiqwpx9n1ao','{\"id\":\"mw4jiqwpx9n1ao\",\"key\":\"fee:first_outstanding:mw4imn86ijwr30:2026:1\",\"rule\":\"first_outstanding\",\"studentId\":\"mw4imn86ijwr30\",\"at\":\"2026-11-06T05:34:56.953Z\",\"meta\":{\"balance\":2000,\"year\":\"2026\",\"term\":\"1\"}}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(4,'mw4jld0ci7qbli','{\"id\":\"mw4jld0ci7qbli\",\"key\":\"fee:cleared:mw4imn86ijwr30:2026:1\",\"rule\":\"cleared\",\"studentId\":\"mw4imn86ijwr30\",\"at\":\"2026-11-06T05:36:58.908Z\",\"meta\":{\"balance\":0,\"year\":\"2026\",\"term\":\"1\"}}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `domain_fee_notification_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_homework`
--

DROP TABLE IF EXISTS `domain_homework`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_homework` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_homework_legacy` (`legacy_id`),
  KEY `idx_domain_homework_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_homework`
--

LOCK TABLES `domain_homework` WRITE;
/*!40000 ALTER TABLE `domain_homework` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_homework` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_homework_submissions`
--

DROP TABLE IF EXISTS `domain_homework_submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_homework_submissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_homework_submissions_legacy` (`legacy_id`),
  KEY `idx_domain_homework_submissions_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_homework_submissions`
--

LOCK TABLES `domain_homework_submissions` WRITE;
/*!40000 ALTER TABLE `domain_homework_submissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_homework_submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_inv_counters`
--

DROP TABLE IF EXISTS `domain_inv_counters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_inv_counters` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_inv_counters_legacy` (`legacy_id`),
  KEY `idx_domain_inv_counters_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_inv_counters`
--

LOCK TABLES `domain_inv_counters` WRITE;
/*!40000 ALTER TABLE `domain_inv_counters` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_inv_counters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_inv_items`
--

DROP TABLE IF EXISTS `domain_inv_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_inv_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_inv_items_legacy` (`legacy_id`),
  KEY `idx_domain_inv_items_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_inv_items`
--

LOCK TABLES `domain_inv_items` WRITE;
/*!40000 ALTER TABLE `domain_inv_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_inv_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_inv_movements`
--

DROP TABLE IF EXISTS `domain_inv_movements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_inv_movements` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_inv_movements_legacy` (`legacy_id`),
  KEY `idx_domain_inv_movements_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_inv_movements`
--

LOCK TABLES `domain_inv_movements` WRITE;
/*!40000 ALTER TABLE `domain_inv_movements` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_inv_movements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_inv_orders`
--

DROP TABLE IF EXISTS `domain_inv_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_inv_orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_inv_orders_legacy` (`legacy_id`),
  KEY `idx_domain_inv_orders_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_inv_orders`
--

LOCK TABLES `domain_inv_orders` WRITE;
/*!40000 ALTER TABLE `domain_inv_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_inv_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_inv_requests`
--

DROP TABLE IF EXISTS `domain_inv_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_inv_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_inv_requests_legacy` (`legacy_id`),
  KEY `idx_domain_inv_requests_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_inv_requests`
--

LOCK TABLES `domain_inv_requests` WRITE;
/*!40000 ALTER TABLE `domain_inv_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_inv_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_inv_suppliers`
--

DROP TABLE IF EXISTS `domain_inv_suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_inv_suppliers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_inv_suppliers_legacy` (`legacy_id`),
  KEY `idx_domain_inv_suppliers_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_inv_suppliers`
--

LOCK TABLES `domain_inv_suppliers` WRITE;
/*!40000 ALTER TABLE `domain_inv_suppliers` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_inv_suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_inv_transfers`
--

DROP TABLE IF EXISTS `domain_inv_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_inv_transfers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_inv_transfers_legacy` (`legacy_id`),
  KEY `idx_domain_inv_transfers_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_inv_transfers`
--

LOCK TABLES `domain_inv_transfers` WRITE;
/*!40000 ALTER TABLE `domain_inv_transfers` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_inv_transfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_materials`
--

DROP TABLE IF EXISTS `domain_materials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_materials` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_materials_legacy` (`legacy_id`),
  KEY `idx_domain_materials_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_materials`
--

LOCK TABLES `domain_materials` WRITE;
/*!40000 ALTER TABLE `domain_materials` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_materials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_message_log`
--

DROP TABLE IF EXISTS `domain_message_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_message_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_message_log_legacy` (`legacy_id`),
  KEY `idx_domain_message_log_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_message_log`
--

LOCK TABLES `domain_message_log` WRITE;
/*!40000 ALTER TABLE `domain_message_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_message_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_notification_settings`
--

DROP TABLE IF EXISTS `domain_notification_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_notification_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_notification_settings_legacy` (`legacy_id`),
  KEY `idx_domain_notification_settings_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_notification_settings`
--

LOCK TABLES `domain_notification_settings` WRITE;
/*!40000 ALTER TABLE `domain_notification_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_notification_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_notifications`
--

DROP TABLE IF EXISTS `domain_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_notifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_notifications_legacy` (`legacy_id`),
  KEY `idx_domain_notifications_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_notifications`
--

LOCK TABLES `domain_notifications` WRITE;
/*!40000 ALTER TABLE `domain_notifications` DISABLE KEYS */;
INSERT INTO `domain_notifications` VALUES
(1,'mw2tkf51etlimz','{\"id\":\"mw2tkf51etlimz\",\"userId\":\"mw2tk846aia0iv\",\"role\":\"student\",\"title\":\"ST. TERESA ACADEMY SCHOOL — School Fees Reminder\",\"message\":\"Dear Parent/Guardian,\\n\\nOur records indicate that your child, Emily Johnson, has an outstanding school fee balance of Ksh 12,500.00 for Term 1, Academic Year 2025.\\n\\nPlease contact the school office if you require clarification or have already made a payment that has not yet been recorded.\\n\\nThank you for your cooperation.\\n\\nST. TERESA ACADEMY SCHOOL\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-05T00:40:38.821Z\",\"meta\":{\"category\":\"fee\",\"rule\":\"first_outstanding\",\"relatedStudentId\":\"mw2tk846aia0iv\",\"relatedYear\":\"2025\",\"relatedTerm\":\"1\",\"balance\":12500}}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'mw2u5eeeitobal','{\"id\":\"mw2u5eeeitobal\",\"userId\":\"mw2u5ed9wao2sg\",\"role\":\"student\",\"title\":\"Welcome to St. Teresa Academy\",\"message\":\"Your admission is complete. Class: Grade 4: Mt. Kenya. Your portal username is \\\"nngatiagrade4mtkenya\\\". Use the temporary password issued by the school office, then set your own password at first sign-in.\",\"type\":\"info\",\"read\":true,\"createdAt\":\"2026-11-05T00:56:57.638Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(3,'mw2u5ma2mr4xjt','{\"id\":\"mw2u5ma2mr4xjt\",\"userId\":\"mw2u5ed9wao2sg\",\"role\":\"student\",\"title\":\"ST. TERESA ACADEMY SCHOOL — School Fees Reminder\",\"message\":\"Dear Parent/Guardian,\\n\\nOur records indicate that your child, NICHOLAS NGATIA, has an outstanding school fee balance of Ksh 2,000.00 for Term 1, Academic Year 2026.\\n\\nPlease contact the school office if you require clarification or have already made a payment that has not yet been recorded.\\n\\nThank you for your cooperation.\\n\\nST. TERESA ACADEMY SCHOOL\",\"type\":\"info\",\"read\":true,\"createdAt\":\"2026-11-05T00:57:07.850Z\",\"meta\":{\"category\":\"fee\",\"rule\":\"first_outstanding\",\"relatedStudentId\":\"mw2u5ed9wao2sg\",\"relatedYear\":\"2026\",\"relatedTerm\":\"1\",\"balance\":2000}}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(4,'mw2vbr3l0p7dn7','{\"id\":\"mw2vbr3l0p7dn7\",\"userId\":\"mw2tk845vyp15w\",\"role\":\"chiefexaminer\",\"title\":\"Submission received — awaiting Chief Examiner review\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) was submitted by David Chen and is now awaiting Chief Examiner review.\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-05T01:29:53.649Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(5,'mw2vbr3lys5vt5','{\"id\":\"mw2vbr3lys5vt5\",\"userId\":\"mw2tk84grlyvn3\",\"role\":\"teacher\",\"title\":\"Submission Received\",\"message\":\"Your document \\\"Math\\\" (STA/SUB/2026/0001) has been received and is awaiting Chief Examiner review. Next action: Chief Examiner review.\",\"type\":\"success\",\"read\":false,\"createdAt\":\"2026-11-05T01:29:53.649Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(6,'mw2vdgbumqavrb','{\"id\":\"mw2vdgbumqavrb\",\"userId\":\"mw2tk845mk9wnr\",\"role\":\"headteacher\",\"title\":\"Submission forwarded to the Headteacher\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) was approved by the chiefexaminer and is now awaiting Headteacher review.\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-05T01:31:13.002Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(7,'mw2vdgbvt9yp9u','{\"id\":\"mw2vdgbvt9yp9u\",\"userId\":\"mw2tk84grlyvn3\",\"role\":\"teacher\",\"title\":\"Approved by the Chief Examiner\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) was approved and forwarded to the Headteacher. Next action: Headteacher review.\",\"type\":\"success\",\"read\":false,\"createdAt\":\"2026-11-05T01:31:13.003Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(8,'mw2vfk9ufoqn6j','{\"id\":\"mw2vfk9ufoqn6j\",\"userId\":\"mw2tk845ub1opf\",\"role\":\"secretary\",\"title\":\"Submission forwarded to the Secretary\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) was approved by the headteacher and is now awaiting Secretary review.\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-05T01:32:51.426Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(9,'mw2vfk9u5wj6pq','{\"id\":\"mw2vfk9u5wj6pq\",\"userId\":\"mw2tk84grlyvn3\",\"role\":\"teacher\",\"title\":\"Approved by the Headteacher\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) was approved and forwarded to the Secretary for final review. Next action: Secretary final review.\",\"type\":\"success\",\"read\":false,\"createdAt\":\"2026-11-05T01:32:51.426Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(10,'mw2vgdqpqgzdcr','{\"id\":\"mw2vgdqpqgzdcr\",\"userId\":\"mw2tk84grlyvn3\",\"role\":\"teacher\",\"title\":\"Approved — Final\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) has completed all three approval stages and is marked Approved — Final. Next action: Secretary publication.\",\"type\":\"success\",\"read\":false,\"createdAt\":\"2026-11-05T01:33:29.617Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(11,'mw2vh2wjbc8rci','{\"id\":\"mw2vh2wjbc8rci\",\"userId\":\"mw2u5ed9wao2sg\",\"role\":\"student\",\"title\":\"New Homework: Math\",\"message\":\"Mathematics - due soon.\",\"type\":\"info\",\"read\":true,\"createdAt\":\"2026-11-05T01:34:02.227Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(12,'mw2vh2wkymbxcm','{\"id\":\"mw2vh2wkymbxcm\",\"userId\":\"mw2tk84grlyvn3\",\"role\":\"teacher\",\"title\":\"Document Published\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) has been published to the student portal.\",\"type\":\"success\",\"read\":false,\"createdAt\":\"2026-11-05T01:34:02.228Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(13,'mw2vh2wkumxy5k','{\"id\":\"mw2vh2wkumxy5k\",\"userId\":\"mw2u5ed9wao2sg\",\"role\":\"student\",\"title\":\"New School Document Published\",\"message\":\"\\\"Math\\\" (Mathematics) is now available under School Documents.\",\"type\":\"info\",\"read\":true,\"createdAt\":\"2026-11-05T01:34:02.229Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(14,'mw4imn9mpkgqem','{\"id\":\"mw4imn9mpkgqem\",\"userId\":\"mw4imn86ijwr30\",\"role\":\"student\",\"title\":\"Welcome to St. Teresa Academy\",\"message\":\"Your admission is complete. Class: Grade 4: Mt. Kilimanjaro. Your portal username is \\\"nngatiagrade4mtkilimanjaro\\\". Use the temporary password issued by the school office, then set your own password at first sign-in.\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-06T05:09:59.242Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(15,'mw4it0rmom9a7d','{\"id\":\"mw4it0rmom9a7d\",\"userId\":\"mw4it0qblwy2r7\",\"role\":\"student\",\"title\":\"Welcome to St. Teresa Academy\",\"message\":\"Your admission is complete. Class: Grade 4: Mt. Kenya. Your portal username is \\\"nngatiagrade4mtkenya\\\". Use the temporary password issued by the school office, then set your own password at first sign-in.\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-06T05:14:56.674Z\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(16,'mw4jiqwoe5ytjo','{\"id\":\"mw4jiqwoe5ytjo\",\"userId\":\"mw4imn86ijwr30\",\"role\":\"student\",\"title\":\"ST. TERESA ACADEMY SCHOOL — School Fees Reminder\",\"message\":\"Dear Parent/Guardian,\\n\\nOur records indicate that your child, Nicholas Ngatia, has an outstanding school fee balance of Ksh 2,000.00 for Term 1, Academic Year 2026.\\n\\nPlease contact the school office if you require clarification or have already made a payment that has not yet been recorded.\\n\\nThank you for your cooperation.\\n\\nST. TERESA ACADEMY SCHOOL\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-06T05:34:56.952Z\",\"meta\":{\"category\":\"fee\",\"rule\":\"first_outstanding\",\"relatedStudentId\":\"mw4imn86ijwr30\",\"relatedYear\":\"2026\",\"relatedTerm\":\"1\",\"balance\":2000}}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(17,'mw4jld0cm6y2u1','{\"id\":\"mw4jld0cm6y2u1\",\"userId\":\"mw4imn86ijwr30\",\"role\":\"student\",\"title\":\"ST. TERESA ACADEMY SCHOOL — School Fees Cleared\",\"message\":\"Dear Parent/Guardian,\\n\\nWe confirm that Nicholas Ngatia\'s school fee balance for Term 1, Academic Year 2026 has been fully cleared. Thank you for your payment.\\n\\nST. TERESA ACADEMY SCHOOL\",\"type\":\"success\",\"read\":false,\"createdAt\":\"2026-11-06T05:36:58.908Z\",\"meta\":{\"category\":\"fee\",\"rule\":\"cleared\",\"relatedStudentId\":\"mw4imn86ijwr30\",\"relatedYear\":\"2026\",\"relatedTerm\":\"1\",\"balance\":0}}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `domain_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_parents`
--

DROP TABLE IF EXISTS `domain_parents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_parents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_parents_legacy` (`legacy_id`),
  KEY `idx_domain_parents_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_parents`
--

LOCK TABLES `domain_parents` WRITE;
/*!40000 ALTER TABLE `domain_parents` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_parents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_payments`
--

DROP TABLE IF EXISTS `domain_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_payments_legacy` (`legacy_id`),
  KEY `idx_domain_payments_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_payments`
--

LOCK TABLES `domain_payments` WRITE;
/*!40000 ALTER TABLE `domain_payments` DISABLE KEYS */;
INSERT INTO `domain_payments` VALUES
(1,'mw2tk8478xqkpu','{\"id\":\"mw2tk8478xqkpu\",\"receiptNo\":\"RCP-1001\",\"studentName\":\"John Smith\",\"studentId\":\"mw2tk846ea2dbz\",\"amount\":4200,\"item\":\"Tuition Installment (Q1)\",\"method\":\"Card\",\"date\":\"2026-09-05\",\"recordedBy\":\"secretary\",\"academicYear\":\"2024\",\"term\":\"1\",\"paymentDate\":\"2026-09-05\",\"recordedAt\":\"2026-09-05T12:00:00.000Z\",\"systemRecordedDate\":\"2026-09-05\",\"status\":\"confirmed\",\"deleted\":true,\"deletedById\":\"mw2tk845ub1opf\",\"deletedBy\":\"Ms. Linda Vasquez\",\"deletedByRole\":\"secretary\",\"deletedAt\":\"2026-11-06T05:34:46.371Z\",\"deleteReason\":\"\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'mw2tk8475c7jmp','{\"id\":\"mw2tk8475c7jmp\",\"receiptNo\":\"RCP-1002\",\"studentName\":\"Emily Johnson\",\"studentId\":\"mw2tk846aia0iv\",\"amount\":300,\"item\":\"Laboratory Fee\",\"method\":\"Cash\",\"date\":\"2026-09-12\",\"recordedBy\":\"secretary\",\"academicYear\":\"2025\",\"term\":\"1\",\"paymentDate\":\"2026-09-12\",\"recordedAt\":\"2026-09-12T12:00:00.000Z\",\"systemRecordedDate\":\"2026-09-12\",\"status\":\"confirmed\",\"deleted\":true,\"deletedById\":\"mw2tk845ub1opf\",\"deletedBy\":\"Ms. Linda Vasquez\",\"deletedByRole\":\"secretary\",\"deletedAt\":\"2026-11-06T05:34:50.978Z\",\"deleteReason\":\"\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(3,'mw4jld077ywh94','{\"id\":\"mw4jld077ywh94\",\"receiptNo\":\"RCP-1003\",\"studentId\":\"mw4imn86ijwr30\",\"studentName\":\"Nicholas Ngatia\",\"item\":\"Fee payment\",\"amount\":2000,\"method\":\"Equity Bank\",\"date\":\"2026-11-02\",\"paymentDate\":\"2026-11-02\",\"academicYear\":\"2026\",\"term\":\"1\",\"allocations\":[{\"academicYear\":\"2026\",\"term\":\"1\",\"amount\":2000}],\"reference\":\"\",\"recordedById\":\"mw2tk845ub1opf\",\"recordedByName\":\"Ms. Linda Vasquez\",\"recordedByRole\":\"secretary\",\"recordedBy\":\"secretary\",\"recordedAt\":\"2026-11-06T05:36:58.902Z\",\"systemRecordedDate\":\"2026-11-06\",\"systemRecordedTime\":\"08:36:58\",\"timezone\":\"Africa/Nairobi\",\"dateHistory\":[{\"at\":\"2026-11-06T05:36:58.902Z\",\"byId\":\"mw2tk845ub1opf\",\"byName\":\"Ms. Linda Vasquez\",\"from\":\"2026-11-02\",\"to\":\"2026-11-02\",\"reason\":\"Initial recording\",\"initial\":true}],\"status\":\"confirmed\",\"reversed\":false,\"deleted\":false,\"clientToken\":\"sp_mw4jkzwybdd2oh\",\"verifyRef\":\"STA-18T25LE\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `domain_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_report_cards`
--

DROP TABLE IF EXISTS `domain_report_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_report_cards` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_report_cards_legacy` (`legacy_id`),
  KEY `idx_domain_report_cards_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_report_cards`
--

LOCK TABLES `domain_report_cards` WRITE;
/*!40000 ALTER TABLE `domain_report_cards` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_report_cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_state`
--

DROP TABLE IF EXISTS `domain_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_state` (
  `domain_key` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `migrated_at` datetime DEFAULT NULL,
  `record_count` int(11) NOT NULL DEFAULT 0,
  `source` varchar(255) DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`domain_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_state`
--

LOCK TABLES `domain_state` WRITE;
/*!40000 ALTER TABLE `domain_state` DISABLE KEYS */;
INSERT INTO `domain_state` VALUES
('academicYears','academic_years','2026-11-13 10:53:59',3,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('announcements','announcements',NULL,0,'Stage 4A','2026-11-13 09:01:53'),
('attendance','domain_attendance','2026-11-13 10:53:59',1,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('auditLog','domain_audit_log','2026-11-13 10:53:59',48,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('classAssignments','domain_class_assignments','2026-11-13 10:53:59',1,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('classes','classes','2026-11-13 10:53:59',33,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('classFeeStructures','domain_class_fee_structures',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('examResults','domain_exam_results',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('exams','domain_exams',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('examSchedule','domain_exam_schedule',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('feeCharges','domain_fee_charges','2026-11-13 10:53:59',4,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('feeItems','domain_fee_items','2026-11-13 10:53:59',10,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('feeNotificationLog','domain_fee_notification_log','2026-11-13 10:53:59',4,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('homework','domain_homework',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('homeworkSubmissions','domain_homework_submissions',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('invCounters','domain_inv_counters',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('invItems','domain_inv_items',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('invMovements','domain_inv_movements',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('invOrders','domain_inv_orders',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('invRequests','domain_inv_requests',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('invSuppliers','domain_inv_suppliers',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('invTransfers','domain_inv_transfers',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('leadership','leadership','2026-11-13 10:53:59',1,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('logo','content_documents','2026-11-13 10:53:59',1,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('materials','domain_materials',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('messageLog','domain_message_log',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('notifications','domain_notifications','2026-11-13 10:53:59',17,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('notificationSettings','domain_notification_settings',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('parents','domain_parents',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('payments','domain_payments','2026-11-13 10:53:59',3,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('reportCards','domain_report_cards',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('settings','content_documents','2026-11-13 10:53:59',1,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('slider','slider_slides','2026-11-13 10:53:59',2,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('students','students','2026-11-13 10:53:59',2,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('studentTransfers','domain_student_transfers','2026-11-13 10:53:59',3,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('subCounters','domain_sub_counters','2026-11-13 10:53:59',1,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('submissions','domain_submissions',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('teachers','staff','2026-11-13 10:53:59',47,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:53:59'),
('timetable','domain_timetable',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('ttArchive','domain_tt_archive',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('ttClasses','domain_tt_classes','2026-11-13 10:54:00',33,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:54:00'),
('ttClassrooms','domain_tt_classrooms',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('ttConfig','domain_tt_config','2026-11-13 10:54:00',1,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:54:00'),
('ttConstraints','domain_tt_constraints',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('ttDivisions','domain_tt_divisions',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('ttSubjects','domain_tt_subjects',NULL,0,'Stage 4B','2026-11-13 09:46:29'),
('ttTeachers','domain_tt_teachers','2026-11-13 10:54:00',39,'import: st-teresa-backup-2026-11-12.json','2026-11-13 10:54:00');
/*!40000 ALTER TABLE `domain_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_student_transfers`
--

DROP TABLE IF EXISTS `domain_student_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_student_transfers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_student_transfers_legacy` (`legacy_id`),
  KEY `idx_domain_student_transfers_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_student_transfers`
--

LOCK TABLES `domain_student_transfers` WRITE;
/*!40000 ALTER TABLE `domain_student_transfers` DISABLE KEYS */;
INSERT INTO `domain_student_transfers` VALUES
(1,'mw2u5eecqt7hqe','{\"id\":\"mw2u5eecqt7hqe\",\"studentId\":\"mw2u5ed9wao2sg\",\"action\":\"admit\",\"byId\":\"mw2tk845ub1opf\",\"byName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"at\":\"2026-11-05T00:56:57.636Z\",\"className\":\"Grade 4: Mt. Kenya\",\"admissionNo\":\"1111\",\"academicYear\":\"2026\",\"term\":\"1\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'mw4imn9j4wi3vp','{\"id\":\"mw4imn9j4wi3vp\",\"studentId\":\"mw4imn86ijwr30\",\"action\":\"admit\",\"byId\":\"mw2tk845ub1opf\",\"byName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"at\":\"2026-11-06T05:09:59.239Z\",\"className\":\"Grade 4: Mt. Kilimanjaro\",\"admissionNo\":\"1111\",\"academicYear\":\"2026\",\"term\":\"1\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(3,'mw4it0rkqj66se','{\"id\":\"mw4it0rkqj66se\",\"studentId\":\"mw4it0qblwy2r7\",\"action\":\"admit\",\"byId\":\"mw2tk845ub1opf\",\"byName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"at\":\"2026-11-06T05:14:56.673Z\",\"className\":\"Grade 4: Mt. Kenya\",\"admissionNo\":\"1112\",\"academicYear\":\"2026\",\"term\":\"1\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `domain_student_transfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_sub_counters`
--

DROP TABLE IF EXISTS `domain_sub_counters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_sub_counters` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_sub_counters_legacy` (`legacy_id`),
  KEY `idx_domain_sub_counters_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_sub_counters`
--

LOCK TABLES `domain_sub_counters` WRITE;
/*!40000 ALTER TABLE `domain_sub_counters` DISABLE KEYS */;
INSERT INTO `domain_sub_counters` VALUES
(1,'__document__','{\"2026\":1}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `domain_sub_counters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_submissions`
--

DROP TABLE IF EXISTS `domain_submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_submissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_submissions_legacy` (`legacy_id`),
  KEY `idx_domain_submissions_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_submissions`
--

LOCK TABLES `domain_submissions` WRITE;
/*!40000 ALTER TABLE `domain_submissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_timetable`
--

DROP TABLE IF EXISTS `domain_timetable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_timetable` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_timetable_legacy` (`legacy_id`),
  KEY `idx_domain_timetable_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_timetable`
--

LOCK TABLES `domain_timetable` WRITE;
/*!40000 ALTER TABLE `domain_timetable` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_timetable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_tt_archive`
--

DROP TABLE IF EXISTS `domain_tt_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_tt_archive` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_tt_archive_legacy` (`legacy_id`),
  KEY `idx_domain_tt_archive_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_tt_archive`
--

LOCK TABLES `domain_tt_archive` WRITE;
/*!40000 ALTER TABLE `domain_tt_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_tt_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_tt_classes`
--

DROP TABLE IF EXISTS `domain_tt_classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_tt_classes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_tt_classes_legacy` (`legacy_id`),
  KEY `idx_domain_tt_classes_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_tt_classes`
--

LOCK TABLES `domain_tt_classes` WRITE;
/*!40000 ALTER TABLE `domain_tt_classes` DISABLE KEYS */;
INSERT INTO `domain_tt_classes` VALUES
(1,'mw2u3ak8wv9f9v','{\"id\":\"mw2u3ak8wv9f9v\",\"name\":\"PG X\",\"shortName\":\"PG X\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84bm26v5h\",\"teacherName\":\"Emmah Wanjiru Ndonga\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PG X\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'mw2u3ak8fcz5sp','{\"id\":\"mw2u3ak8fcz5sp\",\"name\":\"PG Y\",\"shortName\":\"PG Y\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84b80ybup\",\"teacherName\":\"Grace Wambui Gichuhi\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PG Y\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(3,'mw2u3ak85tgj9j','{\"id\":\"mw2u3ak85tgj9j\",\"name\":\"PG W\",\"shortName\":\"PG W\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"\",\"teacherName\":\"\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PG W\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(4,'mw2u3ak87zknir','{\"id\":\"mw2u3ak87zknir\",\"name\":\"PP1 X\",\"shortName\":\"PP1 X\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84b9geev4\",\"teacherName\":\"Jacinta Wanjiku Ngunyi\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PP1 X\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(5,'mw2u3ak8j9t8hx','{\"id\":\"mw2u3ak8j9t8hx\",\"name\":\"PP1 Y\",\"shortName\":\"PP1 Y\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84byldhf7\",\"teacherName\":\"Veronicah Wangari Ndiritu\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PP1 Y\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(6,'mw2u3ak8juff51','{\"id\":\"mw2u3ak8juff51\",\"name\":\"PP1 W\",\"shortName\":\"PP1 W\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84b45mfgm\",\"teacherName\":\"Emmah Nyawira Maina\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PP1 W\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(7,'mw2u3ak8bi0u8d','{\"id\":\"mw2u3ak8bi0u8d\",\"name\":\"PP2 X\",\"shortName\":\"PP2 X\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84cghtb8n\",\"teacherName\":\"Joyce Wairimu Nderitu\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PP2 X\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(8,'mw2u3ak821qd79','{\"id\":\"mw2u3ak821qd79\",\"name\":\"PP2 Y\",\"shortName\":\"PP2 Y\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84cjifuyk\",\"teacherName\":\"Laurisia Njeri Gacheru\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PP2 Y\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(9,'mw2u3ak8j2t02m','{\"id\":\"mw2u3ak8j2t02m\",\"name\":\"PP2 W\",\"shortName\":\"PP2 W\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84ceudo5o\",\"teacherName\":\"Tabitha Wamuyu Kariuki\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PP2 W\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(10,'mw2u3ak8cjctnb','{\"id\":\"mw2u3ak8cjctnb\",\"name\":\"Grade 1: Mt. Kenya\",\"shortName\":\"1M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84d56h6q3\",\"teacherName\":\"Tr. Margaret\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 1: Mt. Kenya\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(11,'mw2u3ak8kg7n1f','{\"id\":\"mw2u3ak8kg7n1f\",\"name\":\"Grade 1: Mt. Ruwenzori\",\"shortName\":\"1R\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84d4yb5q4\",\"teacherName\":\"Tr. Carol\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 1: Mt. Ruwenzori\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(12,'mw2u3ak8nozwnk','{\"id\":\"mw2u3ak8nozwnk\",\"name\":\"Grade 1: Mt. Kilimanjaro\",\"shortName\":\"1K\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84d9nugqg\",\"teacherName\":\"Tr. Eva\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 1: Mt. Kilimanjaro\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(13,'mw2u3ak8lpz95f','{\"id\":\"mw2u3ak8lpz95f\",\"name\":\"Grade 2: Mt. Kenya\",\"shortName\":\"2M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84dosz801\",\"teacherName\":\"Tr. Gladwel\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 2: Mt. Kenya\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(14,'mw2u3ak8uc4h5k','{\"id\":\"mw2u3ak8uc4h5k\",\"name\":\"Grade 2: Mt. Ruwenzori\",\"shortName\":\"2R\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84dxo7xgh\",\"teacherName\":\"Tr. Alice\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 2: Mt. Ruwenzori\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(15,'mw2u3ak8p018j6','{\"id\":\"mw2u3ak8p018j6\",\"name\":\"Grade 2: Mt. Kilimanjaro\",\"shortName\":\"2K\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84d2k99ur\",\"teacherName\":\"Tr. Jacinta\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 2: Mt. Kilimanjaro\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(16,'mw2u3ak8nct63c','{\"id\":\"mw2u3ak8nct63c\",\"name\":\"Grade 3: Mt. Kenya\",\"shortName\":\"3M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84dl9r7wl\",\"teacherName\":\"Tr. Eliza\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 3: Mt. Kenya\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(17,'mw2u3ak92xufxf','{\"id\":\"mw2u3ak92xufxf\",\"name\":\"Grade 3: Mt. Ruwenzori\",\"shortName\":\"3R\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84dwhrwrx\",\"teacherName\":\"Tr. Mary\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 3: Mt. Ruwenzori\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(18,'mw2u3ak9162aim','{\"id\":\"mw2u3ak9162aim\",\"name\":\"Grade 3: Mt. Kilimanjaro\",\"shortName\":\"3K\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84dbdle7k\",\"teacherName\":\"Tr. Doris\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 3: Mt. Kilimanjaro\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(19,'mw2u3ak9w6eauc','{\"id\":\"mw2u3ak9w6eauc\",\"name\":\"Grade 4: Mt. Kenya\",\"shortName\":\"4M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84ddkcbb7\",\"teacherName\":\"Tr. James\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 4: Mt. Kenya\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(20,'mw2u3ak90h7lsk','{\"id\":\"mw2u3ak90h7lsk\",\"name\":\"Grade 4: Mt. Ruwenzori\",\"shortName\":\"4R\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84d3l5jvg\",\"teacherName\":\"Tr. Peris\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 4: Mt. Ruwenzori\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(21,'mw2u3ak99yp9c6','{\"id\":\"mw2u3ak99yp9c6\",\"name\":\"Grade 4: Mt. Kilimanjaro\",\"shortName\":\"4K\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84dkdo1w0\",\"teacherName\":\"Tr. Elvis\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 4: Mt. Kilimanjaro\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(22,'mw2u3ak9l4k347','{\"id\":\"mw2u3ak9l4k347\",\"name\":\"Grade 5: Mt. Kenya\",\"shortName\":\"5M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84diabatp\",\"teacherName\":\"Tr. Fidelis\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 5: Mt. Kenya\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(23,'mw2u3ak96u7xe5','{\"id\":\"mw2u3ak96u7xe5\",\"name\":\"Grade 5: Mt. Ruwenzori\",\"shortName\":\"5R\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84ecfc12k\",\"teacherName\":\"Tr. Doreen\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 5: Mt. Ruwenzori\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(24,'mw2u3ak9j9fsw2','{\"id\":\"mw2u3ak9j9fsw2\",\"name\":\"Grade 5: Mt. Kilimanjaro\",\"shortName\":\"5K\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84do4zo99\",\"teacherName\":\"Mr. Maina\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 5: Mt. Kilimanjaro\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(25,'mw2u3ak9yna4d0','{\"id\":\"mw2u3ak9yna4d0\",\"name\":\"Grade 6: Mt. Kenya\",\"shortName\":\"6M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84e0bmy51\",\"teacherName\":\"Tr. Dennis\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 6: Mt. Kenya\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(26,'mw2u3ak94ofby7','{\"id\":\"mw2u3ak94ofby7\",\"name\":\"Grade 6: Mt. Ruwenzori\",\"shortName\":\"6R\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84eqdweo9\",\"teacherName\":\"Tr. Emmanuel\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 6: Mt. Ruwenzori\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(27,'mw2u3ak91inev4','{\"id\":\"mw2u3ak91inev4\",\"name\":\"Grade 6: Mt. Kilimanjaro\",\"shortName\":\"6K\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84etpi8px\",\"teacherName\":\"Mr. Macharia\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 6: Mt. Kilimanjaro\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(28,'mw2u3ak92pasx3','{\"id\":\"mw2u3ak92pasx3\",\"name\":\"Grade 7: Mwai Kibaki\",\"shortName\":\"7M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84ej63rr4\",\"teacherName\":\"Mr. Kisaka\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 7: Mwai Kibaki\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(29,'mw2u3ak9wj2xjt','{\"id\":\"mw2u3ak9wj2xjt\",\"name\":\"Grade 7: Wangari Maathai\",\"shortName\":\"7W\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84ebxbxqo\",\"teacherName\":\"Tr. Priscilla\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 7: Wangari Maathai\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(30,'mw2u3ak9aik4iu','{\"id\":\"mw2u3ak9aik4iu\",\"name\":\"Grade 8: Mwai Kibaki\",\"shortName\":\"8M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84eu86nus\",\"teacherName\":\"Tr. Gladys W\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 8: Mwai Kibaki\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(31,'mw2u3ak9li1xjt','{\"id\":\"mw2u3ak9li1xjt\",\"name\":\"Grade 8: Wangari Maathai\",\"shortName\":\"8W\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84ehvim70\",\"teacherName\":\"Tr. Lewis\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 8: Wangari Maathai\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(32,'mw2u3ak96tanth','{\"id\":\"mw2u3ak96tanth\",\"name\":\"Grade 9: Mwai Kibaki\",\"shortName\":\"9M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84etraavt\",\"teacherName\":\"Mrs. Mwangi\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 9: Mwai Kibaki\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(33,'mw2u3ak946axqa','{\"id\":\"mw2u3ak946axqa\",\"name\":\"Grade 9: Wangari Maathai\",\"shortName\":\"9W\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84eokjre2\",\"teacherName\":\"Tr. Korir\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 9: Wangari Maathai\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `domain_tt_classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_tt_classrooms`
--

DROP TABLE IF EXISTS `domain_tt_classrooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_tt_classrooms` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_tt_classrooms_legacy` (`legacy_id`),
  KEY `idx_domain_tt_classrooms_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_tt_classrooms`
--

LOCK TABLES `domain_tt_classrooms` WRITE;
/*!40000 ALTER TABLE `domain_tt_classrooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_tt_classrooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_tt_config`
--

DROP TABLE IF EXISTS `domain_tt_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_tt_config` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_tt_config_legacy` (`legacy_id`),
  KEY `idx_domain_tt_config_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_tt_config`
--

LOCK TABLES `domain_tt_config` WRITE;
/*!40000 ALTER TABLE `domain_tt_config` DISABLE KEYS */;
INSERT INTO `domain_tt_config` VALUES
(1,'__document__','{\"days\":[\"Monday\",\"Tuesday\",\"Wednesday\",\"Thursday\",\"Friday\"],\"periods\":[{\"id\":\"p1\",\"label\":\"Lesson 1\",\"time\":\"8:15-8:55\",\"kind\":\"lesson\"},{\"id\":\"p2\",\"label\":\"Lesson 2\",\"time\":\"8:55-9:35\",\"kind\":\"lesson\"},{\"id\":\"p3\",\"label\":\"Lesson 3\",\"time\":\"9:35-10:15\",\"kind\":\"lesson\"},{\"id\":\"p4\",\"label\":\"Lesson 4\",\"time\":\"10:15-10:45\",\"kind\":\"lesson\"},{\"id\":\"p5\",\"label\":\"Lesson 5\",\"time\":\"10:45-11:25\",\"kind\":\"lesson\"},{\"id\":\"p6\",\"label\":\"Lesson 6\",\"time\":\"11:25-12:05\",\"kind\":\"lesson\"},{\"id\":\"p7\",\"label\":\"Lesson 7\",\"time\":\"12:05-12:45\",\"kind\":\"lesson\"},{\"id\":\"p8\",\"label\":\"Lesson 8\",\"time\":\"12:45-13:25\",\"kind\":\"lesson\"},{\"id\":\"b1\",\"label\":\"Lunch\",\"time\":\"13:25-14:00\",\"kind\":\"break\"},{\"id\":\"p9\",\"label\":\"Lesson 9\",\"time\":\"14:00-14:40\",\"kind\":\"lesson\"},{\"id\":\"p10\",\"label\":\"Lesson 10\",\"time\":\"14:40-15:20\",\"kind\":\"lesson\"}],\"published\":false,\"version\":0,\"updatedAt\":1793840119352,\"saturday\":false}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL);
/*!40000 ALTER TABLE `domain_tt_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_tt_constraints`
--

DROP TABLE IF EXISTS `domain_tt_constraints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_tt_constraints` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_tt_constraints_legacy` (`legacy_id`),
  KEY `idx_domain_tt_constraints_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_tt_constraints`
--

LOCK TABLES `domain_tt_constraints` WRITE;
/*!40000 ALTER TABLE `domain_tt_constraints` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_tt_constraints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_tt_divisions`
--

DROP TABLE IF EXISTS `domain_tt_divisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_tt_divisions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_tt_divisions_legacy` (`legacy_id`),
  KEY `idx_domain_tt_divisions_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_tt_divisions`
--

LOCK TABLES `domain_tt_divisions` WRITE;
/*!40000 ALTER TABLE `domain_tt_divisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_tt_divisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_tt_subjects`
--

DROP TABLE IF EXISTS `domain_tt_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_tt_subjects` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_tt_subjects_legacy` (`legacy_id`),
  KEY `idx_domain_tt_subjects_deleted` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_tt_subjects`
--

LOCK TABLES `domain_tt_subjects` WRITE;
/*!40000 ALTER TABLE `domain_tt_subjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `domain_tt_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `domain_tt_teachers`
--

DROP TABLE IF EXISTS `domain_tt_teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `domain_tt_teachers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(255) NOT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_domain_tt_teachers_legacy` (`legacy_id`),
  KEY `idx_domain_tt_teachers_deleted` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `domain_tt_teachers`
--

LOCK TABLES `domain_tt_teachers` WRITE;
/*!40000 ALTER TABLE `domain_tt_teachers` DISABLE KEYS */;
INSERT INTO `domain_tt_teachers` VALUES
(1,'mw2tk84b0xh4wh','{\"id\":\"mw2tk84b0xh4wh\",\"name\":\"Emmah Wanjiru Ndonga\",\"shortName\":\"E. Ndonga\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PG X\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PG X\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84bm26v5h\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(2,'mw2tk84ba5pp5p','{\"id\":\"mw2tk84ba5pp5p\",\"name\":\"Irene Wambui Gachichio\",\"shortName\":\"I. Gachichio\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PG X\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84b3clybf\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(3,'mw2tk84bzk4orl','{\"id\":\"mw2tk84bzk4orl\",\"name\":\"Grace Wambui Gichuhi\",\"shortName\":\"G. Gichuhi\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PG Y\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PG Y\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84b80ybup\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(4,'mw2tk84b5hk1zv','{\"id\":\"mw2tk84b5hk1zv\",\"name\":\"Pamela Muyoka Masinde\",\"shortName\":\"P. Masinde\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PG Y\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84bco4sq9\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(5,'mw2tk84b3r5dlg','{\"id\":\"mw2tk84b3r5dlg\",\"name\":\"Emmah Nyawira Maina\",\"shortName\":\"E. Maina\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PP1 W\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP1 W\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84b45mfgm\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(6,'mw2tk84bfazq4g','{\"id\":\"mw2tk84bfazq4g\",\"name\":\"Purity Muthoni Kabiru\",\"shortName\":\"P. Kabiru\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP1 W\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84b927otd\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(7,'mw2tk84bgty5gw','{\"id\":\"mw2tk84bgty5gw\",\"name\":\"Jacinta Wanjiku Ngunyi\",\"shortName\":\"J. Ngunyi\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PP1 X\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP1 X\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84b9geev4\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(8,'mw2tk84bwhd3bl','{\"id\":\"mw2tk84bwhd3bl\",\"name\":\"Lucy Wanjiru Miano\",\"shortName\":\"L. Miano\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP1 X\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84boh40el\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(9,'mw2tk84byew6tu','{\"id\":\"mw2tk84byew6tu\",\"name\":\"Veronicah Wangari Ndiritu\",\"shortName\":\"V. Ndiritu\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PP1 Y\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP1 Y\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84byldhf7\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(10,'mw2tk84ch912ko','{\"id\":\"mw2tk84ch912ko\",\"name\":\"Isabel Mumbi Macharia\",\"shortName\":\"I. Macharia\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP1 Y\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84cx9lzyb\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(11,'mw2tk84c1oivqk','{\"id\":\"mw2tk84c1oivqk\",\"name\":\"Tabitha Wamuyu Kariuki\",\"shortName\":\"T. Kariuki\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PP2 W\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP2 W\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84ceudo5o\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(12,'mw2tk84ct7lff7','{\"id\":\"mw2tk84ct7lff7\",\"name\":\"Joyce Wairimu Nderitu\",\"shortName\":\"J. Nderitu\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PP2 X\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP2 X\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84cghtb8n\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(13,'mw2tk84c6j4enf','{\"id\":\"mw2tk84c6j4enf\",\"name\":\"Grace Wanjiku Gitau\",\"shortName\":\"G. Gitau\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP2 X\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84cmkg6s0\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(14,'mw2tk84c7vnxsk','{\"id\":\"mw2tk84c7vnxsk\",\"name\":\"Laurisia Njeri Gacheru\",\"shortName\":\"L. Gacheru\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PP2 Y\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP2 Y\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84cjifuyk\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(15,'mw2tk84c9byry8','{\"id\":\"mw2tk84c9byry8\",\"name\":\"Emma Muthoni Muriuki\",\"shortName\":\"E. Muriuki\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP2 Y\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84crgenbq\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(16,'mw2tk84davx3ag','{\"id\":\"mw2tk84davx3ag\",\"name\":\"Tr. Eva\",\"shortName\":\"Tr. Eva\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 1: Mt. Kilimanjaro\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 1: Mt. Kilimanjaro\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84d9nugqg\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(17,'mw2tk84d0u8d2y','{\"id\":\"mw2tk84d0u8d2y\",\"name\":\"Tr. Margaret\",\"shortName\":\"Tr. Margaret\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 1: Mt. Kenya\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 1: Mt. Kenya\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84d56h6q3\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(18,'mw2tk84dmnpn27','{\"id\":\"mw2tk84dmnpn27\",\"name\":\"Tr. Carol\",\"shortName\":\"Tr. Carol\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 1: Mt. Ruwenzori\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 1: Mt. Ruwenzori\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84d4yb5q4\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(19,'mw2tk84dqy4lc1','{\"id\":\"mw2tk84dqy4lc1\",\"name\":\"Tr. Jacinta\",\"shortName\":\"Tr. Jacinta\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 2: Mt. Kilimanjaro\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 2: Mt. Kilimanjaro\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84d2k99ur\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(20,'mw2tk84d32vs10','{\"id\":\"mw2tk84d32vs10\",\"name\":\"Tr. Gladwel\",\"shortName\":\"Tr. Gladwel\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 2: Mt. Kenya\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 2: Mt. Kenya\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84dosz801\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(21,'mw2tk84d43womx','{\"id\":\"mw2tk84d43womx\",\"name\":\"Tr. Alice\",\"shortName\":\"Tr. Alice\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 2: Mt. Ruwenzori\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 2: Mt. Ruwenzori\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84dxo7xgh\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(22,'mw2tk84ddrolu6','{\"id\":\"mw2tk84ddrolu6\",\"name\":\"Tr. Doris\",\"shortName\":\"Tr. Doris\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 3: Mt. Kilimanjaro\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 3: Mt. Kilimanjaro\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84dbdle7k\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(23,'mw2tk84dlo5aqf','{\"id\":\"mw2tk84dlo5aqf\",\"name\":\"Tr. Eliza\",\"shortName\":\"Tr. Eliza\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 3: Mt. Kenya\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 3: Mt. Kenya\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84dl9r7wl\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(24,'mw2tk84d4p23sa','{\"id\":\"mw2tk84d4p23sa\",\"name\":\"Tr. Mary\",\"shortName\":\"Tr. Mary\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 3: Mt. Ruwenzori\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 3: Mt. Ruwenzori\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84dwhrwrx\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(25,'mw2tk84dqot6ah','{\"id\":\"mw2tk84dqot6ah\",\"name\":\"Tr. Elvis\",\"shortName\":\"Tr. Elvis\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 4: Mt. Kilimanjaro\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 4: Mt. Kilimanjaro\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84dkdo1w0\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(26,'mw2tk84dvzo6nj','{\"id\":\"mw2tk84dvzo6nj\",\"name\":\"Tr. James\",\"shortName\":\"Tr. James\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 4: Mt. Kenya\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 4: Mt. Kenya\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84ddkcbb7\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(27,'mw2tk84d2umncv','{\"id\":\"mw2tk84d2umncv\",\"name\":\"Tr. Peris\",\"shortName\":\"Tr. Peris\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 4: Mt. Ruwenzori\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 4: Mt. Ruwenzori\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84d3l5jvg\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(28,'mw2tk84dtiu2so','{\"id\":\"mw2tk84dtiu2so\",\"name\":\"Mr. Maina\",\"shortName\":\"Mr. Maina\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 5: Mt. Kilimanjaro\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 5: Mt. Kilimanjaro\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84do4zo99\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(29,'mw2tk84dl8qtbm','{\"id\":\"mw2tk84dl8qtbm\",\"name\":\"Tr. Fidelis\",\"shortName\":\"Tr. Fidelis\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 5: Mt. Kenya\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 5: Mt. Kenya\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84diabatp\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(30,'mw2tk84e4vxtqr','{\"id\":\"mw2tk84e4vxtqr\",\"name\":\"Tr. Doreen\",\"shortName\":\"Tr. Doreen\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 5: Mt. Ruwenzori\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 5: Mt. Ruwenzori\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84ecfc12k\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(31,'mw2tk84esln2gr','{\"id\":\"mw2tk84esln2gr\",\"name\":\"Mr. Macharia\",\"shortName\":\"Mr. Macharia\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 6: Mt. Kilimanjaro\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 6: Mt. Kilimanjaro\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84etpi8px\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(32,'mw2tk84e54zocg','{\"id\":\"mw2tk84e54zocg\",\"name\":\"Tr. Dennis\",\"shortName\":\"Tr. Dennis\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 6: Mt. Kenya\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 6: Mt. Kenya\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84e0bmy51\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(33,'mw2tk84excopxz','{\"id\":\"mw2tk84excopxz\",\"name\":\"Tr. Emmanuel\",\"shortName\":\"Tr. Emmanuel\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 6: Mt. Ruwenzori\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 6: Mt. Ruwenzori\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84eqdweo9\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(34,'mw2tk84e8p0kez','{\"id\":\"mw2tk84e8p0kez\",\"name\":\"Tr. Priscilla\",\"shortName\":\"Tr. Priscilla\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 7: Wangari Maathai\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Junior Secondary\"],\"classes\":[\"Grade 7: Wangari Maathai\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84ebxbxqo\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(35,'mw2tk84exdf7ug','{\"id\":\"mw2tk84exdf7ug\",\"name\":\"Mr. Kisaka\",\"shortName\":\"Mr. Kisaka\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 7: Mwai Kibaki\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Junior Secondary\"],\"classes\":[\"Grade 7: Mwai Kibaki\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84ej63rr4\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(36,'mw2tk84e3jskbt','{\"id\":\"mw2tk84e3jskbt\",\"name\":\"Tr. Lewis\",\"shortName\":\"Tr. Lewis\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 8: Wangari Maathai\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Junior Secondary\"],\"classes\":[\"Grade 8: Wangari Maathai\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84ehvim70\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(37,'mw2tk84eegpmcl','{\"id\":\"mw2tk84eegpmcl\",\"name\":\"Tr. Gladys W\",\"shortName\":\"Tr. Gladys W\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 8: Mwai Kibaki\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Junior Secondary\"],\"classes\":[\"Grade 8: Mwai Kibaki\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84eu86nus\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(38,'mw2tk84ecfc561','{\"id\":\"mw2tk84ecfc561\",\"name\":\"Tr. Korir\",\"shortName\":\"Tr. Korir\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 9: Wangari Maathai\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Junior Secondary\"],\"classes\":[\"Grade 9: Wangari Maathai\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84eokjre2\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL),
(39,'mw2tk84evros9r','{\"id\":\"mw2tk84evros9r\",\"name\":\"Mrs. Mwangi\",\"shortName\":\"Mrs. Mwangi\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 9: Mwai Kibaki\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Junior Secondary\"],\"classes\":[\"Grade 9: Mwai Kibaki\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84etraavt\",\"createdAt\":\"2026-11-05\"}','2026-11-13 10:54:00','2026-11-13 10:54:00',NULL);
/*!40000 ALTER TABLE `domain_tt_teachers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_runs`
--

DROP TABLE IF EXISTS `import_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_runs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `source_file` varchar(255) NOT NULL,
  `source_hash` char(64) DEFAULT NULL,
  `mode` varchar(16) NOT NULL DEFAULT 'import',
  `status` varchar(16) NOT NULL DEFAULT 'running',
  `entity_counts` longtext DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `started_at` datetime NOT NULL DEFAULT current_timestamp(),
  `finished_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_import_runs_started` (`started_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_runs`
--

LOCK TABLES `import_runs` WRITE;
/*!40000 ALTER TABLE `import_runs` DISABLE KEYS */;
INSERT INTO `import_runs` VALUES
(1,'st-teresa-backup-2026-11-12.json','014e642bc1316d28d5bf27d8f500ea42a423fd0fec37e03ba426638041950cc4','import','completed','{\"users_inserted\":45,\"users_updated\":0,\"users_skipped\":9,\"messages_inserted\":0,\"messages_skipped\":0,\"staged_inserted\":260,\"staged_skipped\":0,\"photos_copied\":0,\"photos_skipped\":0}','non-destructive defaults','2026-11-13 10:53:55','2026-11-13 10:53:55');
/*!40000 ALTER TABLE `import_runs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_staging`
--

DROP TABLE IF EXISTS `import_staging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_staging` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `source_file` varchar(255) NOT NULL,
  `entity` varchar(64) NOT NULL,
  `legacy_id` varchar(120) DEFAULT NULL,
  `payload_hash` char(64) NOT NULL,
  `payload` longtext NOT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'staged',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `imported_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_staging_hash` (`entity`,`payload_hash`),
  KEY `idx_staging_entity` (`entity`),
  KEY `idx_staging_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=261 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_staging`
--

LOCK TABLES `import_staging` WRITE;
/*!40000 ALTER TABLE `import_staging` DISABLE KEYS */;
INSERT INTO `import_staging` VALUES
(1,'st-teresa-backup-2026-11-12.json','ttLessonLabels','ttLessonLabels-0','6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b','1','staged','2026-11-13 10:53:55',NULL),
(2,'st-teresa-backup-2026-11-12.json','officialClassesSeeded','officialClassesSeeded-0','6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b','1','staged','2026-11-13 10:53:55',NULL),
(3,'st-teresa-backup-2026-11-12.json','payments','mw2tk8478xqkpu','30aec3aaa6a23ac75e5d3a62738704544fc0023d237f5c25c092849b46fbd035','{\"id\":\"mw2tk8478xqkpu\",\"receiptNo\":\"RCP-1001\",\"studentName\":\"John Smith\",\"studentId\":\"mw2tk846ea2dbz\",\"amount\":4200,\"item\":\"Tuition Installment (Q1)\",\"method\":\"Card\",\"date\":\"2026-09-05\",\"recordedBy\":\"secretary\",\"academicYear\":\"2024\",\"term\":\"1\",\"paymentDate\":\"2026-09-05\",\"recordedAt\":\"2026-09-05T12:00:00.000Z\",\"systemRecordedDate\":\"2026-09-05\",\"status\":\"confirmed\",\"deleted\":true,\"deletedById\":\"mw2tk845ub1opf\",\"deletedBy\":\"Ms. Linda Vasquez\",\"deletedByRole\":\"secretary\",\"deletedAt\":\"2026-11-06T05:34:46.371Z\",\"deleteReason\":\"\"}','staged','2026-11-13 10:53:55',NULL),
(4,'st-teresa-backup-2026-11-12.json','payments','mw2tk8475c7jmp','32d4b6e9775fee2e83aaff8147aa82ce46ad800746607ff38d4a4c0ee740d6c0','{\"id\":\"mw2tk8475c7jmp\",\"receiptNo\":\"RCP-1002\",\"studentName\":\"Emily Johnson\",\"studentId\":\"mw2tk846aia0iv\",\"amount\":300,\"item\":\"Laboratory Fee\",\"method\":\"Cash\",\"date\":\"2026-09-12\",\"recordedBy\":\"secretary\",\"academicYear\":\"2025\",\"term\":\"1\",\"paymentDate\":\"2026-09-12\",\"recordedAt\":\"2026-09-12T12:00:00.000Z\",\"systemRecordedDate\":\"2026-09-12\",\"status\":\"confirmed\",\"deleted\":true,\"deletedById\":\"mw2tk845ub1opf\",\"deletedBy\":\"Ms. Linda Vasquez\",\"deletedByRole\":\"secretary\",\"deletedAt\":\"2026-11-06T05:34:50.978Z\",\"deleteReason\":\"\"}','staged','2026-11-13 10:53:55',NULL),
(5,'st-teresa-backup-2026-11-12.json','payments','mw4jld077ywh94','fd419134f1cd9bbff6f99bd95f156babd601b302dbf4cfece7167537b9696fd6','{\"id\":\"mw4jld077ywh94\",\"receiptNo\":\"RCP-1003\",\"studentId\":\"mw4imn86ijwr30\",\"studentName\":\"Nicholas Ngatia\",\"item\":\"Fee payment\",\"amount\":2000,\"method\":\"Equity Bank\",\"date\":\"2026-11-02\",\"paymentDate\":\"2026-11-02\",\"academicYear\":\"2026\",\"term\":\"1\",\"allocations\":[{\"academicYear\":\"2026\",\"term\":\"1\",\"amount\":2000}],\"reference\":\"\",\"recordedById\":\"mw2tk845ub1opf\",\"recordedByName\":\"Ms. Linda Vasquez\",\"recordedByRole\":\"secretary\",\"recordedBy\":\"secretary\",\"recordedAt\":\"2026-11-06T05:36:58.902Z\",\"systemRecordedDate\":\"2026-11-06\",\"systemRecordedTime\":\"08:36:58\",\"timezone\":\"Africa/Nairobi\",\"dateHistory\":[{\"at\":\"2026-11-06T05:36:58.902Z\",\"byId\":\"mw2tk845ub1opf\",\"byName\":\"Ms. Linda Vasquez\",\"from\":\"2026-11-02\",\"to\":\"2026-11-02\",\"reason\":\"Initial recording\",\"initial\":true}],\"status\":\"confirmed\",\"reversed\":false,\"deleted\":false,\"clientToken\":\"sp_mw4jkzwybdd2oh\",\"verifyRef\":\"STA-18T25LE\"}','staged','2026-11-13 10:53:55',NULL),
(6,'st-teresa-backup-2026-11-12.json','academicYears','mw2tk849td74gd','c13b6a1f5635350aa68776293d8526efe0e29823168a00917191c2e10c64a04f','{\"id\":\"mw2tk849td74gd\",\"label\":\"2025\",\"startDate\":\"2025-01-01\",\"endDate\":\"2025-12-31\",\"terms\":[1,2,3],\"defaultTerm\":1,\"status\":\"active\",\"notes\":\"\",\"createdAt\":\"2026-11-05T00:40:29.721Z\",\"updatedAt\":\"2026-11-05T00:40:29.721Z\"}','staged','2026-11-13 10:53:55',NULL),
(7,'st-teresa-backup-2026-11-12.json','academicYears','mw2tk849i1pspg','90a8a681fb56df71be791753813897240efab414e026584e96b0dc2d14ef643a','{\"id\":\"mw2tk849i1pspg\",\"label\":\"2026\",\"startDate\":\"2026-01-01\",\"endDate\":\"2026-12-31\",\"terms\":[1,2,3],\"defaultTerm\":1,\"status\":\"active\",\"notes\":\"\",\"createdAt\":\"2026-11-05T00:40:29.721Z\",\"updatedAt\":\"2026-11-05T00:40:29.721Z\"}','staged','2026-11-13 10:53:55',NULL),
(8,'st-teresa-backup-2026-11-12.json','academicYears','mw2tk8493b07nj','6f9d758db74a8b472d9d005ccd4b206e806c3b1fb75c06e729afa97556050477','{\"id\":\"mw2tk8493b07nj\",\"label\":\"2027\",\"startDate\":\"2027-01-01\",\"endDate\":\"2027-12-31\",\"terms\":[1,2,3],\"defaultTerm\":1,\"status\":\"active\",\"notes\":\"\",\"createdAt\":\"2026-11-05T00:40:29.721Z\",\"updatedAt\":\"2026-11-05T00:40:29.721Z\"}','staged','2026-11-13 10:53:55',NULL),
(9,'st-teresa-backup-2026-11-12.json','auditLog','mw2u3ak9qnqlk3','15412c078c0d84ddb90c79713d2f65546ba8b217e8403960c0b0d7bc0323637d','{\"id\":\"mw2u3ak9qnqlk3\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"timetable.class.seed\",\"details\":\"33 default class(es) added\",\"timestamp\":\"2026-11-05T00:55:19.353Z\"}','staged','2026-11-13 10:53:55',NULL),
(10,'st-teresa-backup-2026-11-12.json','auditLog','mw2u3mb19bp5wa','ccede6021fd8efa8d0a08b69af8648f6e01ffe06586ead617234897965805aec','{\"id\":\"mw2u3mb19bp5wa\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"student.delete\",\"details\":\"Emily Johnson (STA-2025-002) deleted. Reason: Emily Johnson. Preserved history — attendance:0 results:0 payments:1 submissions:0.\",\"timestamp\":\"2026-11-05T00:55:34.573Z\"}','staged','2026-11-13 10:53:55',NULL),
(11,'st-teresa-backup-2026-11-12.json','auditLog','mw2u3t7p44gvl3','68ad76b1147e71047acfa9f0c08d40a9980d2bd1ee6854fa25f7642e88afd72f','{\"id\":\"mw2u3t7p44gvl3\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"student.delete\",\"details\":\"John Smith (STA-2024-001) deleted. Reason: John Smith. Preserved history — attendance:0 results:0 payments:1 submissions:0.\",\"timestamp\":\"2026-11-05T00:55:43.525Z\"}','staged','2026-11-13 10:53:55',NULL),
(12,'st-teresa-backup-2026-11-12.json','auditLog','mw2u5eecyjddy8','fcf5df6485ffa0136cba3932c52ecc298fe763a07aee8611768511762e0f1118','{\"id\":\"mw2u5eecyjddy8\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"auth.account.create\",\"details\":\"Account created for nngatiagrade4mtkenya (student)\",\"timestamp\":\"2026-11-05T00:56:57.636Z\"}','staged','2026-11-13 10:53:55',NULL),
(13,'st-teresa-backup-2026-11-12.json','auditLog','mw2u5eeesxoj65','8cf44fa375eb50b5c7faeb626656fca8fa94c226312ee3bf59bf7ed35b03779e','{\"id\":\"mw2u5eeesxoj65\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"student.admit\",\"details\":\"NICHOLAS NGATIA (1111 → Grade 4: Mt. Kenya, 2026 T1)\",\"timestamp\":\"2026-11-05T00:56:57.638Z\"}','staged','2026-11-13 10:53:55',NULL),
(14,'st-teresa-backup-2026-11-12.json','auditLog','mw2u5rybpcuumn','ce3264ab9146540e27ca0dec9c3f6089589af943a49a303124c27efa5c336331','{\"id\":\"mw2u5rybpcuumn\",\"userId\":\"\",\"userName\":\"system\",\"role\":\"system\",\"action\":\"auth.logout\",\"details\":\"Signed out: admin\",\"timestamp\":\"2026-11-05T00:57:15.203Z\"}','staged','2026-11-13 10:53:55',NULL),
(15,'st-teresa-backup-2026-11-12.json','auditLog','mw2u6nxbuv6uyp','53ec106b031a9130f55ac7cd2ebefa2449c5782067acca5bbd158d05d563f5ca','{\"id\":\"mw2u6nxbuv6uyp\",\"userId\":\"mw2u5ed9wao2sg\",\"userName\":\"NICHOLAS NGATIA\",\"role\":\"student\",\"action\":\"auth.password.change\",\"details\":\"Password changed for nngatiagrade4mtkenya (student)\",\"timestamp\":\"2026-11-05T00:57:56.639Z\"}','staged','2026-11-13 10:53:55',NULL),
(16,'st-teresa-backup-2026-11-12.json','auditLog','mw2v721yntyy3n','1fd9677dd48cd73a1e05d5f61743463773534092a8adf12786dcb27a06c7c1b1','{\"id\":\"mw2v721yntyy3n\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"account.update\",\"details\":\"Updated David → role teacher, status active\",\"timestamp\":\"2026-11-05T01:26:14.566Z\"}','staged','2026-11-13 10:53:55',NULL),
(17,'st-teresa-backup-2026-11-12.json','auditLog','mw2v7zzlx5k2re','9fee131fa46cecac54deed6adafa9ca2166354888f5cfc2843e2b7a3aeee2bd5','{\"id\":\"mw2v7zzlx5k2re\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"auth.password.reset\",\"details\":\"Temporary password issued for David (teacher) — Admin-assisted reset\",\"timestamp\":\"2026-11-05T01:26:58.545Z\"}','staged','2026-11-13 10:53:55',NULL),
(18,'st-teresa-backup-2026-11-12.json','auditLog','mw2v8nntytxwcx','c32f156311681f835b7cf9d6bdbeaf1a367f8e12a258a8b9876d868b19ad8a53','{\"id\":\"mw2v8nntytxwcx\",\"userId\":\"\",\"userName\":\"system\",\"role\":\"system\",\"action\":\"auth.logout\",\"details\":\"Signed out: secretary\",\"timestamp\":\"2026-11-05T01:27:29.225Z\"}','staged','2026-11-13 10:53:55',NULL),
(19,'st-teresa-backup-2026-11-12.json','auditLog','mw2v9eeoohs670','96679f735e9303072f0715eeac34ae2686bb8e85ff444a792696fd89e30481a2','{\"id\":\"mw2v9eeoohs670\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"auth.password.change\",\"details\":\"Password changed for David (teacher)\",\"timestamp\":\"2026-11-05T01:28:03.888Z\"}','staged','2026-11-13 10:53:55',NULL),
(20,'st-teresa-backup-2026-11-12.json','auditLog','mw2vbr3l52w9wp','d045490985cf06584f3d1339ea2cfb7665f9df7213d092be56fb8ff66d63430e','{\"id\":\"mw2vbr3l52w9wp\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"submission.create\",\"details\":\"STA/SUB/2026/0001 · Math (Homework / Assignment)\",\"timestamp\":\"2026-11-05T01:29:53.649Z\"}','staged','2026-11-13 10:53:55',NULL),
(21,'st-teresa-backup-2026-11-12.json','auditLog','mw2vbr3mtww3ag','ce2df8e79d56606444ff72ee411594d7724ebecbfaa477fc3d9245ffa29ee36d','{\"id\":\"mw2vbr3mtww3ag\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"homework.create\",\"details\":\"Math (Grade 4: Mt. Kenya) - submitted for approval STA/SUB/2026/0001\",\"timestamp\":\"2026-11-05T01:29:53.650Z\"}','staged','2026-11-13 10:53:55',NULL),
(22,'st-teresa-backup-2026-11-12.json','auditLog','mw2vbw16ggy5u6','051eab1f9bd94f4fe9c6dddfb47d64f85b4f759484f1720bd97c70c625864757','{\"id\":\"mw2vbw16ggy5u6\",\"userId\":\"\",\"userName\":\"system\",\"role\":\"system\",\"action\":\"auth.logout\",\"details\":\"Signed out: David\",\"timestamp\":\"2026-11-05T01:30:00.042Z\"}','staged','2026-11-13 10:53:55',NULL),
(23,'st-teresa-backup-2026-11-12.json','auditLog','mw2vcqam5zpdcz','efdc358953ae352f6faec17ea9b85705eb258ac1ae9f2045cba8356e699d1df2','{\"id\":\"mw2vcqam5zpdcz\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"account.update\",\"details\":\"Updated chiefexaminer → role chiefexaminer, status active\",\"timestamp\":\"2026-11-05T01:30:39.262Z\"}','staged','2026-11-13 10:53:55',NULL),
(24,'st-teresa-backup-2026-11-12.json','auditLog','mw2vcrz0rinfhe','f12326e7300b8a4314373c0e1d0ab9ce9eb414cc1cbb8156a50595ffed910b59','{\"id\":\"mw2vcrz0rinfhe\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"auth.password.reset\",\"details\":\"Temporary password issued for chiefexaminer (chiefexaminer) — Admin-assisted reset\",\"timestamp\":\"2026-11-05T01:30:41.436Z\"}','staged','2026-11-13 10:53:55',NULL),
(25,'st-teresa-backup-2026-11-12.json','auditLog','mw2vd9drgnpcc4','67267bcc78a8d887330e86b2b909b4312b89591ebf6deb93d8ebc34711003056','{\"id\":\"mw2vd9drgnpcc4\",\"userId\":\"mw2tk845vyp15w\",\"userName\":\"Mr. Anthony Rossi\",\"role\":\"chiefexaminer\",\"action\":\"auth.password.change\",\"details\":\"Password changed for chiefexaminer (chiefexaminer)\",\"timestamp\":\"2026-11-05T01:31:03.999Z\"}','staged','2026-11-13 10:53:55',NULL),
(26,'st-teresa-backup-2026-11-12.json','auditLog','mw2vdgbu2of5sj','1ffdec5f746642dd782603145f482660890fac609ffa9402f0088127ef8bc8ed','{\"id\":\"mw2vdgbu2of5sj\",\"userId\":\"mw2tk845vyp15w\",\"userName\":\"Mr. Anthony Rossi\",\"role\":\"chiefexaminer\",\"action\":\"submission.approve\",\"details\":\"STA/SUB/2026/0001 approved at chiefexaminer by Mr. Anthony Rossi\",\"timestamp\":\"2026-11-05T01:31:13.002Z\"}','staged','2026-11-13 10:53:55',NULL),
(27,'st-teresa-backup-2026-11-12.json','auditLog','mw2veslfw4jvm6','c75820b9c0acc59fd3fd10d9c9688792197d9b12d46ddc92963b40f87e65deb2','{\"id\":\"mw2veslfw4jvm6\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"account.update\",\"details\":\"Updated headteacher → role headteacher, status active\",\"timestamp\":\"2026-11-05T01:32:15.555Z\"}','staged','2026-11-13 10:53:55',NULL),
(28,'st-teresa-backup-2026-11-12.json','auditLog','mw2vezn78ea29z','7bc6ed2ceeb82f4b5a6b2ddda27099ef4f21f5bc8ce418efd680b1f7555eda51','{\"id\":\"mw2vezn78ea29z\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"auth.password.reset\",\"details\":\"Temporary password issued for headteacher (headteacher) — Admin-assisted reset\",\"timestamp\":\"2026-11-05T01:32:24.691Z\"}','staged','2026-11-13 10:53:55',NULL),
(29,'st-teresa-backup-2026-11-12.json','auditLog','mw2vfgfyh5jpit','1b561a6b7e434f3cbd6d1885788dbc194d44de8e70ba53208826906c5a577a53','{\"id\":\"mw2vfgfyh5jpit\",\"userId\":\"mw2tk845mk9wnr\",\"userName\":\"Sr. Catherine Marie\",\"role\":\"headteacher\",\"action\":\"auth.password.change\",\"details\":\"Password changed for headteacher (headteacher)\",\"timestamp\":\"2026-11-05T01:32:46.462Z\"}','staged','2026-11-13 10:53:55',NULL),
(30,'st-teresa-backup-2026-11-12.json','auditLog','mw2vfk9uug3px3','e2c6265a7dbbc529fc03988ce35047df0f78608e5cdf3491f1dae15ea25dfe72','{\"id\":\"mw2vfk9uug3px3\",\"userId\":\"mw2tk845mk9wnr\",\"userName\":\"Sr. Catherine Marie\",\"role\":\"headteacher\",\"action\":\"submission.approve\",\"details\":\"STA/SUB/2026/0001 approved at headteacher by Sr. Catherine Marie\",\"timestamp\":\"2026-11-05T01:32:51.426Z\"}','staged','2026-11-13 10:53:55',NULL),
(31,'st-teresa-backup-2026-11-12.json','auditLog','mw2vgdqpdanzzu','05616243d06a4835bfed4c0bc257ca614d7b7472920d7fb4360f4e7d1180a9d8','{\"id\":\"mw2vgdqpdanzzu\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"submission.approve\",\"details\":\"STA/SUB/2026/0001 approved at secretary by Ms. Linda Vasquez\",\"timestamp\":\"2026-11-05T01:33:29.617Z\"}','staged','2026-11-13 10:53:55',NULL),
(32,'st-teresa-backup-2026-11-12.json','auditLog','mw2vh2wkbae9st','5115219c81c2f6d4edc2502c0f4e04b98a8a91b43ee0f9f6978ee49c759f2835','{\"id\":\"mw2vh2wkbae9st\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"submission.publish\",\"details\":\"STA/SUB/2026/0001 published to student portal by Ms. Linda Vasquez\",\"timestamp\":\"2026-11-05T01:34:02.228Z\"}','staged','2026-11-13 10:53:55',NULL),
(33,'st-teresa-backup-2026-11-12.json','auditLog','mw2vjfy4yfbqly','0f09ef366e4c97a728d513ed4bcb64ff1bad094074671b8b540a52f621da97e0','{\"id\":\"mw2vjfy4yfbqly\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"homework.delete\",\"details\":\"Math\",\"timestamp\":\"2026-11-05T01:35:52.445Z\"}','staged','2026-11-13 10:53:55',NULL),
(34,'st-teresa-backup-2026-11-12.json','auditLog','mw2volqpqhmuvm','b4dd3a81aa0bccfe98c002a67c19f7adb0609aa6bf8f1c70a337ff3e9a7cc79e','{\"id\":\"mw2volqpqhmuvm\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"submission.delete\",\"details\":\"STA/SUB/2026/0001 · Math deleted by David Chen (owner)\",\"timestamp\":\"2026-11-05T01:39:53.233Z\"}','staged','2026-11-13 10:53:55',NULL),
(35,'st-teresa-backup-2026-11-12.json','auditLog','mw2vyb0xl1hajn','5c98014ddca22a56f095c86adc0bba17f61dd7c8fca272dab3eb27634dbc576b','{\"id\":\"mw2vyb0xl1hajn\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"class.teacher.unassign\",\"details\":\"Grade 4: Mt. Kilimanjaro\",\"timestamp\":\"2026-11-05T01:47:25.905Z\"}','staged','2026-11-13 10:53:55',NULL),
(36,'st-teresa-backup-2026-11-12.json','auditLog','mw2vynhqhez9kq','8bc073a3beda94c9f896bec72a57003f76ee3c7bea578655eba08a696ac85a5d','{\"id\":\"mw2vynhqhez9kq\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"class.update\",\"details\":\"Grade 4: Mt. Kilimanjaro (2026)\",\"timestamp\":\"2026-11-05T01:47:42.062Z\"}','staged','2026-11-13 10:53:55',NULL),
(37,'st-teresa-backup-2026-11-12.json','auditLog','mw2w04p28xgrrm','35bc9ff8efa39a397cbf98f59fe5b8baf76ef0e25db7c4eff225f5cc0055835b','{\"id\":\"mw2w04p28xgrrm\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"class.teacher.assign\",\"details\":\"David Chen → Grade 4: Mt. Kilimanjaro\",\"timestamp\":\"2026-11-05T01:48:51.014Z\"}','staged','2026-11-13 10:53:55',NULL),
(38,'st-teresa-backup-2026-11-12.json','auditLog','mw4hxfbw5frc0v','a89427afa072e57a746d26e80eb81895bab26cb8c57da4799e97e35637c5f476','{\"id\":\"mw4hxfbw5frc0v\",\"userId\":\"\",\"userName\":\"system\",\"role\":\"system\",\"action\":\"auth.logout\",\"details\":\"Signed out: David\",\"timestamp\":\"2026-11-06T04:50:22.556Z\"}','staged','2026-11-13 10:53:55',NULL),
(39,'st-teresa-backup-2026-11-12.json','auditLog','mw4ibs71509dis','a93cb7aeffb49f6d59dd433349f154d0c9fd0f1e68ed1d90f6876d5b328a016e','{\"id\":\"mw4ibs71509dis\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"student.update\",\"details\":\"NICHOLAS NGATIA (1111)\",\"timestamp\":\"2026-11-06T05:01:32.413Z\"}','staged','2026-11-13 10:53:55',NULL),
(40,'st-teresa-backup-2026-11-12.json','auditLog','mw4ie41g0tygdn','121e4a59a1e84da369366c086ac7beb9c39ee906d23a91503e39b4c8af221c38','{\"id\":\"mw4ie41g0tygdn\",\"userId\":\"mw2tk845zb7xtt\",\"userName\":\"System Administrator\",\"role\":\"admin\",\"action\":\"student.update\",\"details\":\"NICHOLAS NGATIA (1111)\",\"timestamp\":\"2026-11-06T05:03:21.076Z\"}','staged','2026-11-13 10:53:55',NULL),
(41,'st-teresa-backup-2026-11-12.json','auditLog','mw4if60u7h88ik','1a7d6d043132c0be7c88bf41fb15166422b15f5852df2e7a5cc8d70b850f1310','{\"id\":\"mw4if60u7h88ik\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"student.delete\",\"details\":\"NICHOLAS NGATIA (1111) deleted. Reason: NICHOLAS NGATIA. Preserved history — attendance:0 results:0 payments:0 submissions:0.\",\"timestamp\":\"2026-11-06T05:04:10.302Z\"}','staged','2026-11-13 10:53:55',NULL),
(42,'st-teresa-backup-2026-11-12.json','auditLog','mw4imn9ifhggv8','c87219410a5966c14d74e6e70563cc45b1d5c94635be9e6288a0a2d11e6b561f','{\"id\":\"mw4imn9ifhggv8\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"auth.account.create\",\"details\":\"Account created for nngatiagrade4mtkilimanjaro (student)\",\"timestamp\":\"2026-11-06T05:09:59.238Z\"}','staged','2026-11-13 10:53:55',NULL),
(43,'st-teresa-backup-2026-11-12.json','auditLog','mw4imn9mmqc4p1','61d0d9165171122905eb60c32f7b9eb245abc134fca7673a81127d02cb508647','{\"id\":\"mw4imn9mmqc4p1\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"student.admit\",\"details\":\"Nicholas Ngatia (1111 → Grade 4: Mt. Kilimanjaro, 2026 T1)\",\"timestamp\":\"2026-11-06T05:09:59.242Z\"}','staged','2026-11-13 10:53:55',NULL),
(44,'st-teresa-backup-2026-11-12.json','auditLog','mw4inthk15t4y4','c98eb4bdf4ff8307cfcc8689fd1112fc29294c107ddee581e7fcedd094710153','{\"id\":\"mw4inthk15t4y4\",\"userId\":\"mw4imn86ijwr30\",\"userName\":\"Nicholas Ngatia\",\"role\":\"student\",\"action\":\"auth.password.change\",\"details\":\"Password changed for nngatiagrade4mtkilimanjaro (student)\",\"timestamp\":\"2026-11-06T05:10:53.960Z\"}','staged','2026-11-13 10:53:55',NULL),
(45,'st-teresa-backup-2026-11-12.json','auditLog','mw4ipvb9ppugcz','8e6de52676e3b977f0ac3e1929ecb1b3146d18f3749c1cf637f599846206a80f','{\"id\":\"mw4ipvb9ppugcz\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"attendance.save\",\"details\":\"Grade 4: Mt. Kilimanjaro 2026-11-06 (1 new, 0 corrected)\",\"timestamp\":\"2026-11-06T05:12:29.637Z\"}','staged','2026-11-13 10:53:55',NULL),
(46,'st-teresa-backup-2026-11-12.json','auditLog','mw4iqzs405wbaz','bb6b873336df669259a5cf6ba7b3ae91de4cb6fa7c4b15c87c9beb21362303a9','{\"id\":\"mw4iqzs405wbaz\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"attendance.save\",\"details\":\"Grade 4: Mt. Kilimanjaro 2026-11-06 (0 new, 1 corrected)\",\"timestamp\":\"2026-11-06T05:13:22.084Z\"}','staged','2026-11-13 10:53:55',NULL),
(47,'st-teresa-backup-2026-11-12.json','auditLog','mw4ira6d5xibge','22a20d320239050a7f8a2c67feb0fc1f4c8a9588e06d39b3ca2d35af532801f2','{\"id\":\"mw4ira6d5xibge\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"attendance.save\",\"details\":\"Grade 4: Mt. Kilimanjaro 2026-11-06 (0 new, 1 corrected)\",\"timestamp\":\"2026-11-06T05:13:35.557Z\"}','staged','2026-11-13 10:53:55',NULL),
(48,'st-teresa-backup-2026-11-12.json','auditLog','mw4ird84pik3jx','4dcf3036c366ee7bc0a5dfbfd1cd4e0d0124562e653acf9f9a8cf949d416be9b','{\"id\":\"mw4ird84pik3jx\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"attendance.save\",\"details\":\"Grade 4: Mt. Kilimanjaro 2026-11-06 (0 new, 1 corrected)\",\"timestamp\":\"2026-11-06T05:13:39.508Z\"}','staged','2026-11-13 10:53:55',NULL),
(49,'st-teresa-backup-2026-11-12.json','auditLog','mw4irgzxe8m8iu','95cf8fec8584bd84ea51e611d9f71a09b7c1306f723a5f4480d42151728ff5bf','{\"id\":\"mw4irgzxe8m8iu\",\"userId\":\"mw2tk84grlyvn3\",\"userName\":\"David Chen\",\"role\":\"teacher\",\"action\":\"attendance.save\",\"details\":\"Grade 4: Mt. Kilimanjaro 2026-11-06 (0 new, 1 corrected)\",\"timestamp\":\"2026-11-06T05:13:44.397Z\"}','staged','2026-11-13 10:53:55',NULL),
(50,'st-teresa-backup-2026-11-12.json','auditLog','mw4it0rkyh9bq0','adf9a9be64cab17e69dd68ad94e4c6a9ac137dc03e829c3eb3a6e0ea5c1381bc','{\"id\":\"mw4it0rkyh9bq0\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"auth.account.create\",\"details\":\"Account created for nngatiagrade4mtkenya (student)\",\"timestamp\":\"2026-11-06T05:14:56.672Z\"}','staged','2026-11-13 10:53:55',NULL),
(51,'st-teresa-backup-2026-11-12.json','auditLog','mw4it0rllj7tm8','2f9d6a6056baec5517ff250783604d78bd953150fca6c0a65a4313de98b10ebc','{\"id\":\"mw4it0rllj7tm8\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"student.admit\",\"details\":\"Nicholas Ngatia (1112 → Grade 4: Mt. Kenya, 2026 T1)\",\"timestamp\":\"2026-11-06T05:14:56.673Z\"}','staged','2026-11-13 10:53:55',NULL),
(52,'st-teresa-backup-2026-11-12.json','auditLog','mw4it9qzxikb50','75e30be27a30edfd054cfc1596c041ad9ddb93ff468a6202bd6328625f4b5116','{\"id\":\"mw4it9qzxikb50\",\"userId\":\"\",\"userName\":\"system\",\"role\":\"system\",\"action\":\"auth.logout\",\"details\":\"Signed out: nngatiagrade4mtkilimanjaro\",\"timestamp\":\"2026-11-06T05:15:08.315Z\"}','staged','2026-11-13 10:53:55',NULL),
(53,'st-teresa-backup-2026-11-12.json','auditLog','mw4iuapgoae6gl','4023d083cbdc1d067b41c8c342d16998fc60717c405bf60862dda09abc04bc10','{\"id\":\"mw4iuapgoae6gl\",\"userId\":\"mw4it0qblwy2r7\",\"userName\":\"Nicholas Ngatia\",\"role\":\"student\",\"action\":\"auth.password.change\",\"details\":\"Password changed for nngatiagrade4mtkenya (student)\",\"timestamp\":\"2026-11-06T05:15:56.212Z\"}','staged','2026-11-13 10:53:55',NULL),
(54,'st-teresa-backup-2026-11-12.json','auditLog','mw4jiiqrdvep56','34005a6db025abada9cc15d45123531da1c26f441fccf3412b0ffac1678816c0','{\"id\":\"mw4jiiqrdvep56\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"payment.delete\",\"details\":\"RCP-1001 · Ksh 4,200.00 · John Smith · balance now Ksh 0.00\",\"timestamp\":\"2026-11-06T05:34:46.371Z\"}','staged','2026-11-13 10:53:55',NULL),
(55,'st-teresa-backup-2026-11-12.json','auditLog','mw4jimaqaei6j2','4e27120ad4c245fbf42d8cecb98942c97d2182bebb2a75ca132ba1c2a40da9f6','{\"id\":\"mw4jimaqaei6j2\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"payment.delete\",\"details\":\"RCP-1002 · Ksh 300.00 · Emily Johnson · balance now Ksh 0.00\",\"timestamp\":\"2026-11-06T05:34:50.978Z\"}','staged','2026-11-13 10:53:55',NULL),
(56,'st-teresa-backup-2026-11-12.json','auditLog','mw4jld09euhh16','4d3389eb0c1afbb89d43c197305a06ec15142fdc68ec641acba4f64b58ebd201','{\"id\":\"mw4jld09euhh16\",\"userId\":\"mw2tk845ub1opf\",\"userName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"action\":\"payment.record\",\"details\":\"RCP-1003 · Nicholas Ngatia · Ksh 2,000.00 · actual 2026-11-02 · recorded 2026-11-06 08:36:58 (Africa/Nairobi) · Equity Bank · term 1 2026 · balance now Ksh 0.00\",\"timestamp\":\"2026-11-06T05:36:58.905Z\"}','staged','2026-11-13 10:53:55',NULL),
(57,'st-teresa-backup-2026-11-12.json','studentTransfers','mw2u5eecqt7hqe','b1045d2467b06d30d22240a13605f93c5a3e74ea5f41ed643c5906260bc2b28a','{\"id\":\"mw2u5eecqt7hqe\",\"studentId\":\"mw2u5ed9wao2sg\",\"action\":\"admit\",\"byId\":\"mw2tk845ub1opf\",\"byName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"at\":\"2026-11-05T00:56:57.636Z\",\"className\":\"Grade 4: Mt. Kenya\",\"admissionNo\":\"1111\",\"academicYear\":\"2026\",\"term\":\"1\"}','staged','2026-11-13 10:53:55',NULL),
(58,'st-teresa-backup-2026-11-12.json','studentTransfers','mw4imn9j4wi3vp','70b1fbabcf063a0ed2cf1127be30e0f800c5fc3b3668734d61094f75a203fbcc','{\"id\":\"mw4imn9j4wi3vp\",\"studentId\":\"mw4imn86ijwr30\",\"action\":\"admit\",\"byId\":\"mw2tk845ub1opf\",\"byName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"at\":\"2026-11-06T05:09:59.239Z\",\"className\":\"Grade 4: Mt. Kilimanjaro\",\"admissionNo\":\"1111\",\"academicYear\":\"2026\",\"term\":\"1\"}','staged','2026-11-13 10:53:55',NULL),
(59,'st-teresa-backup-2026-11-12.json','studentTransfers','mw4it0rkqj66se','4790d309877b0c3021f3ca47414e15556d7974d699a49b6f64863611c60d881e','{\"id\":\"mw4it0rkqj66se\",\"studentId\":\"mw4it0qblwy2r7\",\"action\":\"admit\",\"byId\":\"mw2tk845ub1opf\",\"byName\":\"Ms. Linda Vasquez\",\"role\":\"secretary\",\"at\":\"2026-11-06T05:14:56.673Z\",\"className\":\"Grade 4: Mt. Kenya\",\"admissionNo\":\"1112\",\"academicYear\":\"2026\",\"term\":\"1\"}','staged','2026-11-13 10:53:55',NULL),
(60,'st-teresa-backup-2026-11-12.json','ttConfigV2','ttConfigV2-0','6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b','1','staged','2026-11-13 10:53:55',NULL),
(61,'st-teresa-backup-2026-11-12.json','feeCharges','mw2tkdyydk1dns','0e350d23b21706cf8ac653835f567dad764a57142be83ef3729fe64e55176cec','{\"id\":\"mw2tkdyydk1dns\",\"studentId\":\"mw2tk846ea2dbz\",\"className\":\"Grade 9\",\"academicYear\":\"2024\",\"term\":\"1\",\"source\":\"legacy\",\"item\":\"Opening balance brought forward\",\"amount\":4200,\"reason\":\"Migrated from the pre-existing fee balance — no balance was reset or re-charged.\",\"createdAt\":\"2026-11-05T00:40:37.306Z\",\"reversed\":false,\"createdBy\":\"migration\",\"createdByRole\":\"admin\"}','staged','2026-11-13 10:53:55',NULL),
(62,'st-teresa-backup-2026-11-12.json','feeCharges','mw2tkdyybjid5y','4c209e0c49f365016d62d4261adface5898c17571a4437ba0578525a68818137','{\"id\":\"mw2tkdyybjid5y\",\"studentId\":\"mw2tk846aia0iv\",\"className\":\"Grade 9\",\"academicYear\":\"2025\",\"term\":\"1\",\"source\":\"legacy\",\"item\":\"Opening balance brought forward\",\"amount\":12800,\"reason\":\"Migrated from the pre-existing fee balance — no balance was reset or re-charged.\",\"createdAt\":\"2026-11-05T00:40:37.306Z\",\"reversed\":false,\"createdBy\":\"migration\",\"createdByRole\":\"admin\"}','staged','2026-11-13 10:53:55',NULL),
(63,'st-teresa-backup-2026-11-12.json','feeCharges','mw2u5eedv9f6hn','2255d7f3cd2d94a786894096b80f6208a53a2dbe61d89565fa7ca5780ae14497','{\"id\":\"mw2u5eedv9f6hn\",\"createdAt\":\"2026-11-05T00:56:57.637Z\",\"reversed\":false,\"createdBy\":\"Ms. Linda Vasquez\",\"createdByRole\":\"secretary\",\"studentId\":\"mw2u5ed9wao2sg\",\"className\":\"Grade 4: Mt. Kenya\",\"academicYear\":\"2026\",\"term\":\"1\",\"source\":\"legacy\",\"item\":\"Opening balance\",\"amount\":2000,\"reason\":\"Balance carried into the fee ledger at admission.\"}','staged','2026-11-13 10:53:55',NULL),
(64,'st-teresa-backup-2026-11-12.json','feeCharges','mw4imn9lcvzihj','9bf175aff2c1c73f4b8dec651ac1179f65275f35e0ea9a04b6c9f07755139ed8','{\"id\":\"mw4imn9lcvzihj\",\"createdAt\":\"2026-11-06T05:09:59.241Z\",\"reversed\":false,\"createdBy\":\"Ms. Linda Vasquez\",\"createdByRole\":\"secretary\",\"studentId\":\"mw4imn86ijwr30\",\"className\":\"Grade 4: Mt. Kilimanjaro\",\"academicYear\":\"2026\",\"term\":\"1\",\"source\":\"legacy\",\"item\":\"Opening balance\",\"amount\":2000,\"reason\":\"Balance carried into the fee ledger at admission.\"}','staged','2026-11-13 10:53:55',NULL),
(65,'st-teresa-backup-2026-11-12.json','feeNotificationLog','mw2tkf523fvgt7','b2bc14d13bf08746a5cef0598bd5e80664213d419ed915a2b2f15d1c8105158b','{\"id\":\"mw2tkf523fvgt7\",\"key\":\"fee:first_outstanding:mw2tk846aia0iv:2025:1\",\"rule\":\"first_outstanding\",\"studentId\":\"mw2tk846aia0iv\",\"at\":\"2026-11-05T00:40:38.822Z\",\"meta\":{\"balance\":12500,\"year\":\"2025\",\"term\":\"1\"}}','staged','2026-11-13 10:53:55',NULL),
(66,'st-teresa-backup-2026-11-12.json','feeNotificationLog','mw2u5ma3bvnuh6','9fcf70bf2dabd6426ee848263a9d01b2c081d8de710f1c3df0612542e1cc216d','{\"id\":\"mw2u5ma3bvnuh6\",\"key\":\"fee:first_outstanding:mw2u5ed9wao2sg:2026:1\",\"rule\":\"first_outstanding\",\"studentId\":\"mw2u5ed9wao2sg\",\"at\":\"2026-11-05T00:57:07.851Z\",\"meta\":{\"balance\":2000,\"year\":\"2026\",\"term\":\"1\"}}','staged','2026-11-13 10:53:55',NULL),
(67,'st-teresa-backup-2026-11-12.json','feeNotificationLog','mw4jiqwpx9n1ao','0eb4b7649b8a6016280852cc8d04e46925dce04ffe69e69a6b0a302faf8c643c','{\"id\":\"mw4jiqwpx9n1ao\",\"key\":\"fee:first_outstanding:mw4imn86ijwr30:2026:1\",\"rule\":\"first_outstanding\",\"studentId\":\"mw4imn86ijwr30\",\"at\":\"2026-11-06T05:34:56.953Z\",\"meta\":{\"balance\":2000,\"year\":\"2026\",\"term\":\"1\"}}','staged','2026-11-13 10:53:55',NULL),
(68,'st-teresa-backup-2026-11-12.json','feeNotificationLog','mw4jld0ci7qbli','827e27cb854e3c5ca14f0c3aedf0e7669e3f614a384be152b1d6f42674a13e11','{\"id\":\"mw4jld0ci7qbli\",\"key\":\"fee:cleared:mw4imn86ijwr30:2026:1\",\"rule\":\"cleared\",\"studentId\":\"mw4imn86ijwr30\",\"at\":\"2026-11-06T05:36:58.908Z\",\"meta\":{\"balance\":0,\"year\":\"2026\",\"term\":\"1\"}}','staged','2026-11-13 10:53:55',NULL),
(69,'st-teresa-backup-2026-11-12.json','leadership','mwdl424ojh9way','ca4b063009262589af8b438121571b251d81b272c14f745d1a78b18b5b6147c1','{\"id\":\"mwdl424ojh9way\",\"position\":\"director1\",\"name\":\"John\",\"title\":\"School Director\",\"bio\":\"A dedicated and visionary leader committed to providing quality education, promoting academic excellence, nurturing talents, and ensuring a safe, supportive, and inspiring learning environment for all students.\",\"status\":\"active\",\"published\":true,\"photo\":\"data:image/jpeg;base64,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\",\"createdAt\":\"2026-11-12\"}','staged','2026-11-13 10:53:55',NULL),
(70,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8wv9f9v','bac80cf0af3edfd0c6267122f5f63e972e3101fff59b64c24edb27d459adcf53','{\"id\":\"mw2u3ak8wv9f9v\",\"name\":\"PG X\",\"shortName\":\"PG X\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84bm26v5h\",\"teacherName\":\"Emmah Wanjiru Ndonga\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PG X\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(71,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8fcz5sp','98fb9678083b245143d5887f0bd52c90cdfbb5e40336f71abd06eceb3f4d6fe8','{\"id\":\"mw2u3ak8fcz5sp\",\"name\":\"PG Y\",\"shortName\":\"PG Y\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84b80ybup\",\"teacherName\":\"Grace Wambui Gichuhi\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PG Y\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(72,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak85tgj9j','922499e59ffc04aa49c64b324bc37004612b94c98bb83d649c539af21b25688b','{\"id\":\"mw2u3ak85tgj9j\",\"name\":\"PG W\",\"shortName\":\"PG W\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"\",\"teacherName\":\"\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PG W\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(73,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak87zknir','83b3b14805263c588d6f358682ca9c1a4e7af84a68bba1e7c34eca8345050ecd','{\"id\":\"mw2u3ak87zknir\",\"name\":\"PP1 X\",\"shortName\":\"PP1 X\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84b9geev4\",\"teacherName\":\"Jacinta Wanjiku Ngunyi\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PP1 X\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(74,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8j9t8hx','ee1ecc9ae16fa8d71b6200c7fce9c9a877e0821f36a986b2a83c93ef49b366f1','{\"id\":\"mw2u3ak8j9t8hx\",\"name\":\"PP1 Y\",\"shortName\":\"PP1 Y\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84byldhf7\",\"teacherName\":\"Veronicah Wangari Ndiritu\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PP1 Y\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(75,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8juff51','1d5c0e706f2ce2f4df780b6cc2709be99aa2734b1234ba94a930314b27d5d5e0','{\"id\":\"mw2u3ak8juff51\",\"name\":\"PP1 W\",\"shortName\":\"PP1 W\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84b45mfgm\",\"teacherName\":\"Emmah Nyawira Maina\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PP1 W\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(76,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8bi0u8d','4e3a6c2c4d5a7bcad6972fafcf509c3034cc82313de3e68946c9437f18ff09c3','{\"id\":\"mw2u3ak8bi0u8d\",\"name\":\"PP2 X\",\"shortName\":\"PP2 X\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84cghtb8n\",\"teacherName\":\"Joyce Wairimu Nderitu\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PP2 X\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(77,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak821qd79','1b5f91ac6faa937f71899b3052d36c39a889172bb6d88f215e78c6638c22c7a7','{\"id\":\"mw2u3ak821qd79\",\"name\":\"PP2 Y\",\"shortName\":\"PP2 Y\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84cjifuyk\",\"teacherName\":\"Laurisia Njeri Gacheru\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PP2 Y\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(78,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8j2t02m','034fbd5943fda813f02d3b851817616f4989ee6de859ac3eaeb6ecbf539bbe8c','{\"id\":\"mw2u3ak8j2t02m\",\"name\":\"PP2 W\",\"shortName\":\"PP2 W\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84ceudo5o\",\"teacherName\":\"Tabitha Wamuyu Kariuki\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"PP2 W\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(79,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8cjctnb','f8ab3ccf9eae31602d327dab0d157f08c316836168d9e75eaa39f3bb194a3930','{\"id\":\"mw2u3ak8cjctnb\",\"name\":\"Grade 1: Mt. Kenya\",\"shortName\":\"1M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84d56h6q3\",\"teacherName\":\"Tr. Margaret\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 1: Mt. Kenya\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(80,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8kg7n1f','713d0e766fa3da6096a6649f16033bd5bcced0ff972fb104a6134d619aab4875','{\"id\":\"mw2u3ak8kg7n1f\",\"name\":\"Grade 1: Mt. Ruwenzori\",\"shortName\":\"1R\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84d4yb5q4\",\"teacherName\":\"Tr. Carol\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 1: Mt. Ruwenzori\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(81,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8nozwnk','e77d3fbc9210b4a7f3ac9946d091dd4b890bad25e1e0568f2bbbd1cdd083dcc8','{\"id\":\"mw2u3ak8nozwnk\",\"name\":\"Grade 1: Mt. Kilimanjaro\",\"shortName\":\"1K\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84d9nugqg\",\"teacherName\":\"Tr. Eva\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 1: Mt. Kilimanjaro\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(82,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8lpz95f','58cf77e0393a8ab6d765e548c335801712dc7d10759b45d7be2eda0e49ca5189','{\"id\":\"mw2u3ak8lpz95f\",\"name\":\"Grade 2: Mt. Kenya\",\"shortName\":\"2M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84dosz801\",\"teacherName\":\"Tr. Gladwel\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 2: Mt. Kenya\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(83,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8uc4h5k','644d826146563fef5944d808f704d9133848f71948f795abab86e7f872d9b82d','{\"id\":\"mw2u3ak8uc4h5k\",\"name\":\"Grade 2: Mt. Ruwenzori\",\"shortName\":\"2R\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84dxo7xgh\",\"teacherName\":\"Tr. Alice\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 2: Mt. Ruwenzori\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(84,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8p018j6','0c5e847c59aa1264911611e54ba750dc71831e50d621a405a830d770e965101f','{\"id\":\"mw2u3ak8p018j6\",\"name\":\"Grade 2: Mt. Kilimanjaro\",\"shortName\":\"2K\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84d2k99ur\",\"teacherName\":\"Tr. Jacinta\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 2: Mt. Kilimanjaro\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(85,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak8nct63c','1b01414035b6bd3974998070bdb40fdca441f7a42bea51cb1c1e2dd2f5173471','{\"id\":\"mw2u3ak8nct63c\",\"name\":\"Grade 3: Mt. Kenya\",\"shortName\":\"3M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84dl9r7wl\",\"teacherName\":\"Tr. Eliza\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 3: Mt. Kenya\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(86,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak92xufxf','2771ae16ede14a308d121733cb4642e641b4d0db00a8283d76b3f82daf25e026','{\"id\":\"mw2u3ak92xufxf\",\"name\":\"Grade 3: Mt. Ruwenzori\",\"shortName\":\"3R\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84dwhrwrx\",\"teacherName\":\"Tr. Mary\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 3: Mt. Ruwenzori\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(87,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak9162aim','44bfda712773777e9907cfd0c48a8fe93af1b6cdba41f8b6a7840b9fb6a71edd','{\"id\":\"mw2u3ak9162aim\",\"name\":\"Grade 3: Mt. Kilimanjaro\",\"shortName\":\"3K\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84dbdle7k\",\"teacherName\":\"Tr. Doris\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 3: Mt. Kilimanjaro\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(88,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak9w6eauc','cc255bae0e1a3bdbca10465b8455d98d8173aafa1d3b8c75bb0580b9928dff7a','{\"id\":\"mw2u3ak9w6eauc\",\"name\":\"Grade 4: Mt. Kenya\",\"shortName\":\"4M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84ddkcbb7\",\"teacherName\":\"Tr. James\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 4: Mt. Kenya\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(89,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak90h7lsk','27c7167661f3cb120b658d8e0cb8b15d906b3100a59c68deb049ad2c1cdf30ab','{\"id\":\"mw2u3ak90h7lsk\",\"name\":\"Grade 4: Mt. Ruwenzori\",\"shortName\":\"4R\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84d3l5jvg\",\"teacherName\":\"Tr. Peris\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 4: Mt. Ruwenzori\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(90,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak99yp9c6','96093092e7ee4c076917b492796f799e3a24affcb58e783d6b6db322e9329a30','{\"id\":\"mw2u3ak99yp9c6\",\"name\":\"Grade 4: Mt. Kilimanjaro\",\"shortName\":\"4K\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84dkdo1w0\",\"teacherName\":\"Tr. Elvis\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 4: Mt. Kilimanjaro\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(91,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak9l4k347','50681b980e63c6f19ff2b9b39aa91d65ea9848134484336bf42c8eca9e2420ee','{\"id\":\"mw2u3ak9l4k347\",\"name\":\"Grade 5: Mt. Kenya\",\"shortName\":\"5M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84diabatp\",\"teacherName\":\"Tr. Fidelis\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 5: Mt. Kenya\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(92,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak96u7xe5','ba3f0e247fdf8e5fc689e6ec71644ccdec2f37f01f2b0cccb3907a7e8261e88b','{\"id\":\"mw2u3ak96u7xe5\",\"name\":\"Grade 5: Mt. Ruwenzori\",\"shortName\":\"5R\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84ecfc12k\",\"teacherName\":\"Tr. Doreen\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 5: Mt. Ruwenzori\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(93,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak9j9fsw2','eeaa703b16a8a73a83fa2132d404c75fd3c595cd1d9793c8dee6662811bd8087','{\"id\":\"mw2u3ak9j9fsw2\",\"name\":\"Grade 5: Mt. Kilimanjaro\",\"shortName\":\"5K\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84do4zo99\",\"teacherName\":\"Mr. Maina\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 5: Mt. Kilimanjaro\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(94,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak9yna4d0','fa9cd0be4b4d2817339e4b9b0a252b5a274b63a72ce120516329268080118472','{\"id\":\"mw2u3ak9yna4d0\",\"name\":\"Grade 6: Mt. Kenya\",\"shortName\":\"6M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84e0bmy51\",\"teacherName\":\"Tr. Dennis\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 6: Mt. Kenya\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(95,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak94ofby7','318473bd33a8e12a0e6528e88383dc59ffd0d7052f7dd55f3ccd07a865b89137','{\"id\":\"mw2u3ak94ofby7\",\"name\":\"Grade 6: Mt. Ruwenzori\",\"shortName\":\"6R\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84eqdweo9\",\"teacherName\":\"Tr. Emmanuel\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 6: Mt. Ruwenzori\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(96,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak91inev4','18d3a5f01633a7f597a8993c4bb8c2cbc1be56932440744ed1640cb8821b4dff','{\"id\":\"mw2u3ak91inev4\",\"name\":\"Grade 6: Mt. Kilimanjaro\",\"shortName\":\"6K\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84etpi8px\",\"teacherName\":\"Mr. Macharia\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 6: Mt. Kilimanjaro\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(97,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak92pasx3','4508283f97ad8e0489f5abec37d51473b77a88af75e40a2664dc7fcd723ead27','{\"id\":\"mw2u3ak92pasx3\",\"name\":\"Grade 7: Mwai Kibaki\",\"shortName\":\"7M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84ej63rr4\",\"teacherName\":\"Mr. Kisaka\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 7: Mwai Kibaki\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(98,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak9wj2xjt','d96eff9ca875e7df57c9adf424a663e2a0e653b869febb8e33010f5b3fa5f3f6','{\"id\":\"mw2u3ak9wj2xjt\",\"name\":\"Grade 7: Wangari Maathai\",\"shortName\":\"7W\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84ebxbxqo\",\"teacherName\":\"Tr. Priscilla\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 7: Wangari Maathai\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(99,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak9aik4iu','b4eff097c91b99a2be21b9406f8eb44e952ae03bafb1133a43a699e5d0cb4f64','{\"id\":\"mw2u3ak9aik4iu\",\"name\":\"Grade 8: Mwai Kibaki\",\"shortName\":\"8M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84eu86nus\",\"teacherName\":\"Tr. Gladys W\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 8: Mwai Kibaki\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(100,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak9li1xjt','56d011fe327943e4c32fd9dec2ca27e7f13612dc48189b4a61b204afbffc685a','{\"id\":\"mw2u3ak9li1xjt\",\"name\":\"Grade 8: Wangari Maathai\",\"shortName\":\"8W\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84ehvim70\",\"teacherName\":\"Tr. Lewis\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 8: Wangari Maathai\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(101,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak96tanth','6952ea3d448373349a50d3b4cc7da3fb3a734da78dab2becb1bdb710dc55ba76','{\"id\":\"mw2u3ak96tanth\",\"name\":\"Grade 9: Mwai Kibaki\",\"shortName\":\"9M\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84etraavt\",\"teacherName\":\"Mrs. Mwangi\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 9: Mwai Kibaki\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(102,'st-teresa-backup-2026-11-12.json','ttClasses','mw2u3ak946axqa','a631b620f54e07e4145ca4fdde9ad59dfc7627ba8344624154a415bf730d00a0','{\"id\":\"mw2u3ak946axqa\",\"name\":\"Grade 9: Wangari Maathai\",\"shortName\":\"9W\",\"count\":0,\"timeOff\":[],\"arriveSecondPeriod\":false,\"prepRequired\":false,\"sameFinish\":false,\"lunchBreak\":\"\",\"maxQuestionMarking\":0,\"teacherId\":\"mw2tk84eokjre2\",\"teacherName\":\"Tr. Korir\",\"fixedClassTeacherTime\":\"\",\"startPeriod\":\"\",\"endPeriod\":\"\",\"minPerDay\":1,\"maxPerDay\":6,\"lessonInterval\":0,\"daysPerWeek\":5,\"customText\":\"\",\"grade\":\"Grade 9: Wangari Maathai\",\"subjectIds\":[],\"size\":0,\"updatedAt\":\"2026-11-05\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(103,'st-teresa-backup-2026-11-12.json','attendance','mw4ipvb80iisc0','6a01d1b956e1cb6812eebbc328b19ae9a1da0a2275df47df03712a40be98a3a7','{\"id\":\"mw4ipvb80iisc0\",\"classId\":\"mw2tk8468zfsdq\",\"className\":\"Grade 4: Mt. Kilimanjaro\",\"date\":\"2026-11-06\",\"studentId\":\"mw4imn86ijwr30\",\"studentName\":\"Nicholas Ngatia\",\"admissionNo\":\"1111\",\"status\":\"present\",\"arrivalTime\":\"08:12\",\"remarks\":\"\",\"markedBy\":\"David Chen\",\"markedAt\":\"2026-11-06T05:13:44.397Z\",\"auditTrail\":[{\"by\":\"David Chen\",\"at\":\"2026-11-06T05:13:22.084Z\",\"from\":\"present\",\"to\":\"absent\",\"reason\":\"Correction\"},{\"by\":\"David Chen\",\"at\":\"2026-11-06T05:13:35.556Z\",\"from\":\"absent\",\"to\":\"late\",\"reason\":\"Correction\"},{\"by\":\"David Chen\",\"at\":\"2026-11-06T05:13:39.507Z\",\"from\":\"late\",\"to\":\"excused\",\"reason\":\"Correction\"},{\"by\":\"David Chen\",\"at\":\"2026-11-06T05:13:44.397Z\",\"from\":\"excused\",\"to\":\"present\",\"reason\":\"Correction\"}]}','staged','2026-11-13 10:53:55',NULL),
(104,'st-teresa-backup-2026-11-12.json','notifications','mw2tkf51etlimz','6c5650a17bbdfa6a1b51cdc6fa5c90c6b05e033e1c25f63ba8ea32638d2d2698','{\"id\":\"mw2tkf51etlimz\",\"userId\":\"mw2tk846aia0iv\",\"role\":\"student\",\"title\":\"ST. TERESA ACADEMY SCHOOL — School Fees Reminder\",\"message\":\"Dear Parent/Guardian,\\n\\nOur records indicate that your child, Emily Johnson, has an outstanding school fee balance of Ksh 12,500.00 for Term 1, Academic Year 2025.\\n\\nPlease contact the school office if you require clarification or have already made a payment that has not yet been recorded.\\n\\nThank you for your cooperation.\\n\\nST. TERESA ACADEMY SCHOOL\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-05T00:40:38.821Z\",\"meta\":{\"category\":\"fee\",\"rule\":\"first_outstanding\",\"relatedStudentId\":\"mw2tk846aia0iv\",\"relatedYear\":\"2025\",\"relatedTerm\":\"1\",\"balance\":12500}}','staged','2026-11-13 10:53:55',NULL),
(105,'st-teresa-backup-2026-11-12.json','notifications','mw2u5eeeitobal','0dec02e554ddab6df38e0901dbe9bb13650051f49b05390d8993e504c040f878','{\"id\":\"mw2u5eeeitobal\",\"userId\":\"mw2u5ed9wao2sg\",\"role\":\"student\",\"title\":\"Welcome to St. Teresa Academy\",\"message\":\"Your admission is complete. Class: Grade 4: Mt. Kenya. Your portal username is \\\"nngatiagrade4mtkenya\\\". Use the temporary password issued by the school office, then set your own password at first sign-in.\",\"type\":\"info\",\"read\":true,\"createdAt\":\"2026-11-05T00:56:57.638Z\"}','staged','2026-11-13 10:53:55',NULL),
(106,'st-teresa-backup-2026-11-12.json','notifications','mw2u5ma2mr4xjt','d5a0f6c494c709a5dadbaca78988ab4d39af2ad38632f6c9577026d6f0e2a3d9','{\"id\":\"mw2u5ma2mr4xjt\",\"userId\":\"mw2u5ed9wao2sg\",\"role\":\"student\",\"title\":\"ST. TERESA ACADEMY SCHOOL — School Fees Reminder\",\"message\":\"Dear Parent/Guardian,\\n\\nOur records indicate that your child, NICHOLAS NGATIA, has an outstanding school fee balance of Ksh 2,000.00 for Term 1, Academic Year 2026.\\n\\nPlease contact the school office if you require clarification or have already made a payment that has not yet been recorded.\\n\\nThank you for your cooperation.\\n\\nST. TERESA ACADEMY SCHOOL\",\"type\":\"info\",\"read\":true,\"createdAt\":\"2026-11-05T00:57:07.850Z\",\"meta\":{\"category\":\"fee\",\"rule\":\"first_outstanding\",\"relatedStudentId\":\"mw2u5ed9wao2sg\",\"relatedYear\":\"2026\",\"relatedTerm\":\"1\",\"balance\":2000}}','staged','2026-11-13 10:53:55',NULL),
(107,'st-teresa-backup-2026-11-12.json','notifications','mw2vbr3l0p7dn7','8b6516fce883dffd4e9e171a8201c74158f62946044dfb444ceb9e974b3e0731','{\"id\":\"mw2vbr3l0p7dn7\",\"userId\":\"mw2tk845vyp15w\",\"role\":\"chiefexaminer\",\"title\":\"Submission received — awaiting Chief Examiner review\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) was submitted by David Chen and is now awaiting Chief Examiner review.\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-05T01:29:53.649Z\"}','staged','2026-11-13 10:53:55',NULL),
(108,'st-teresa-backup-2026-11-12.json','notifications','mw2vbr3lys5vt5','68aa9880cecc6cd7a11ebcb12ea9084e847f50eee15f544cd17d2061a8295318','{\"id\":\"mw2vbr3lys5vt5\",\"userId\":\"mw2tk84grlyvn3\",\"role\":\"teacher\",\"title\":\"Submission Received\",\"message\":\"Your document \\\"Math\\\" (STA/SUB/2026/0001) has been received and is awaiting Chief Examiner review. Next action: Chief Examiner review.\",\"type\":\"success\",\"read\":false,\"createdAt\":\"2026-11-05T01:29:53.649Z\"}','staged','2026-11-13 10:53:55',NULL),
(109,'st-teresa-backup-2026-11-12.json','notifications','mw2vdgbumqavrb','d6532264202c54ceadb5b58c2016c1cb8bf01b6bdc16cf0e9c7db7771ef28a77','{\"id\":\"mw2vdgbumqavrb\",\"userId\":\"mw2tk845mk9wnr\",\"role\":\"headteacher\",\"title\":\"Submission forwarded to the Headteacher\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) was approved by the chiefexaminer and is now awaiting Headteacher review.\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-05T01:31:13.002Z\"}','staged','2026-11-13 10:53:55',NULL),
(110,'st-teresa-backup-2026-11-12.json','notifications','mw2vdgbvt9yp9u','d0b6d56fa268d250431ebbb5f303d7393afcd2c893b6663224faae494a550d0d','{\"id\":\"mw2vdgbvt9yp9u\",\"userId\":\"mw2tk84grlyvn3\",\"role\":\"teacher\",\"title\":\"Approved by the Chief Examiner\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) was approved and forwarded to the Headteacher. Next action: Headteacher review.\",\"type\":\"success\",\"read\":false,\"createdAt\":\"2026-11-05T01:31:13.003Z\"}','staged','2026-11-13 10:53:55',NULL),
(111,'st-teresa-backup-2026-11-12.json','notifications','mw2vfk9ufoqn6j','f90fbe7e04eb3073e65336b1fe7c0bec3b50aa8a6dc5ad8f444d0245a8488841','{\"id\":\"mw2vfk9ufoqn6j\",\"userId\":\"mw2tk845ub1opf\",\"role\":\"secretary\",\"title\":\"Submission forwarded to the Secretary\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) was approved by the headteacher and is now awaiting Secretary review.\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-05T01:32:51.426Z\"}','staged','2026-11-13 10:53:55',NULL),
(112,'st-teresa-backup-2026-11-12.json','notifications','mw2vfk9u5wj6pq','739f4aad2b8028ba1ec148461cf17b5fd552695d66510ebadc4a423ac054127a','{\"id\":\"mw2vfk9u5wj6pq\",\"userId\":\"mw2tk84grlyvn3\",\"role\":\"teacher\",\"title\":\"Approved by the Headteacher\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) was approved and forwarded to the Secretary for final review. Next action: Secretary final review.\",\"type\":\"success\",\"read\":false,\"createdAt\":\"2026-11-05T01:32:51.426Z\"}','staged','2026-11-13 10:53:55',NULL),
(113,'st-teresa-backup-2026-11-12.json','notifications','mw2vgdqpqgzdcr','6d4bf7af81c6205941f2b5b77c32113f52c06e2ec9db6dcd563df658c8f41a55','{\"id\":\"mw2vgdqpqgzdcr\",\"userId\":\"mw2tk84grlyvn3\",\"role\":\"teacher\",\"title\":\"Approved — Final\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) has completed all three approval stages and is marked Approved — Final. Next action: Secretary publication.\",\"type\":\"success\",\"read\":false,\"createdAt\":\"2026-11-05T01:33:29.617Z\"}','staged','2026-11-13 10:53:55',NULL),
(114,'st-teresa-backup-2026-11-12.json','notifications','mw2vh2wjbc8rci','2d37866968d77ca9e3e9b2244414dcf1bd6a7da038da65c60a80e86497337f5b','{\"id\":\"mw2vh2wjbc8rci\",\"userId\":\"mw2u5ed9wao2sg\",\"role\":\"student\",\"title\":\"New Homework: Math\",\"message\":\"Mathematics - due soon.\",\"type\":\"info\",\"read\":true,\"createdAt\":\"2026-11-05T01:34:02.227Z\"}','staged','2026-11-13 10:53:55',NULL),
(115,'st-teresa-backup-2026-11-12.json','notifications','mw2vh2wkymbxcm','efcf1cbecc930ad2976e757d78684c775a88853f82c005f7509a0f8bb419f571','{\"id\":\"mw2vh2wkymbxcm\",\"userId\":\"mw2tk84grlyvn3\",\"role\":\"teacher\",\"title\":\"Document Published\",\"message\":\"\\\"Math\\\" (STA/SUB/2026/0001) has been published to the student portal.\",\"type\":\"success\",\"read\":false,\"createdAt\":\"2026-11-05T01:34:02.228Z\"}','staged','2026-11-13 10:53:55',NULL),
(116,'st-teresa-backup-2026-11-12.json','notifications','mw2vh2wkumxy5k','f056f9b6b78a5976b4fd5dca04171395fc1b8c9341e4667f8643fe74736d5659','{\"id\":\"mw2vh2wkumxy5k\",\"userId\":\"mw2u5ed9wao2sg\",\"role\":\"student\",\"title\":\"New School Document Published\",\"message\":\"\\\"Math\\\" (Mathematics) is now available under School Documents.\",\"type\":\"info\",\"read\":true,\"createdAt\":\"2026-11-05T01:34:02.229Z\"}','staged','2026-11-13 10:53:55',NULL),
(117,'st-teresa-backup-2026-11-12.json','notifications','mw4imn9mpkgqem','91e09424e95fe09c238432c5eecce021961c73e46a4ed272475fae8f25fb16bc','{\"id\":\"mw4imn9mpkgqem\",\"userId\":\"mw4imn86ijwr30\",\"role\":\"student\",\"title\":\"Welcome to St. Teresa Academy\",\"message\":\"Your admission is complete. Class: Grade 4: Mt. Kilimanjaro. Your portal username is \\\"nngatiagrade4mtkilimanjaro\\\". Use the temporary password issued by the school office, then set your own password at first sign-in.\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-06T05:09:59.242Z\"}','staged','2026-11-13 10:53:55',NULL),
(118,'st-teresa-backup-2026-11-12.json','notifications','mw4it0rmom9a7d','0afc9232bd5ac80bfb0f59db00d8844a7525722ffe1cea0865154644ab475122','{\"id\":\"mw4it0rmom9a7d\",\"userId\":\"mw4it0qblwy2r7\",\"role\":\"student\",\"title\":\"Welcome to St. Teresa Academy\",\"message\":\"Your admission is complete. Class: Grade 4: Mt. Kenya. Your portal username is \\\"nngatiagrade4mtkenya\\\". Use the temporary password issued by the school office, then set your own password at first sign-in.\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-06T05:14:56.674Z\"}','staged','2026-11-13 10:53:55',NULL),
(119,'st-teresa-backup-2026-11-12.json','notifications','mw4jiqwoe5ytjo','651c694bcee11c0ca8e9f4a97bd60d7850fafb523f05b42086d7f07ceb069853','{\"id\":\"mw4jiqwoe5ytjo\",\"userId\":\"mw4imn86ijwr30\",\"role\":\"student\",\"title\":\"ST. TERESA ACADEMY SCHOOL — School Fees Reminder\",\"message\":\"Dear Parent/Guardian,\\n\\nOur records indicate that your child, Nicholas Ngatia, has an outstanding school fee balance of Ksh 2,000.00 for Term 1, Academic Year 2026.\\n\\nPlease contact the school office if you require clarification or have already made a payment that has not yet been recorded.\\n\\nThank you for your cooperation.\\n\\nST. TERESA ACADEMY SCHOOL\",\"type\":\"info\",\"read\":false,\"createdAt\":\"2026-11-06T05:34:56.952Z\",\"meta\":{\"category\":\"fee\",\"rule\":\"first_outstanding\",\"relatedStudentId\":\"mw4imn86ijwr30\",\"relatedYear\":\"2026\",\"relatedTerm\":\"1\",\"balance\":2000}}','staged','2026-11-13 10:53:55',NULL),
(120,'st-teresa-backup-2026-11-12.json','notifications','mw4jld0cm6y2u1','b0c3a5c5e8d397f65e50df66d47e55cf97cbf9242694dbbb5ae9ff81d2535f54','{\"id\":\"mw4jld0cm6y2u1\",\"userId\":\"mw4imn86ijwr30\",\"role\":\"student\",\"title\":\"ST. TERESA ACADEMY SCHOOL — School Fees Cleared\",\"message\":\"Dear Parent/Guardian,\\n\\nWe confirm that Nicholas Ngatia\'s school fee balance for Term 1, Academic Year 2026 has been fully cleared. Thank you for your payment.\\n\\nST. TERESA ACADEMY SCHOOL\",\"type\":\"success\",\"read\":false,\"createdAt\":\"2026-11-06T05:36:58.908Z\",\"meta\":{\"category\":\"fee\",\"rule\":\"cleared\",\"relatedStudentId\":\"mw4imn86ijwr30\",\"relatedYear\":\"2026\",\"relatedTerm\":\"1\",\"balance\":0}}','staged','2026-11-13 10:53:55',NULL),
(121,'st-teresa-backup-2026-11-12.json','ttConfig','ttConfig-0','2f8b5aa89d092ae1fe2fdd5c351a48cf0509402f286298fdf9d3400d04ed3dd2','{\"days\":[\"Monday\",\"Tuesday\",\"Wednesday\",\"Thursday\",\"Friday\"],\"periods\":[{\"id\":\"p1\",\"label\":\"Lesson 1\",\"time\":\"8:15-8:55\",\"kind\":\"lesson\"},{\"id\":\"p2\",\"label\":\"Lesson 2\",\"time\":\"8:55-9:35\",\"kind\":\"lesson\"},{\"id\":\"p3\",\"label\":\"Lesson 3\",\"time\":\"9:35-10:15\",\"kind\":\"lesson\"},{\"id\":\"p4\",\"label\":\"Lesson 4\",\"time\":\"10:15-10:45\",\"kind\":\"lesson\"},{\"id\":\"p5\",\"label\":\"Lesson 5\",\"time\":\"10:45-11:25\",\"kind\":\"lesson\"},{\"id\":\"p6\",\"label\":\"Lesson 6\",\"time\":\"11:25-12:05\",\"kind\":\"lesson\"},{\"id\":\"p7\",\"label\":\"Lesson 7\",\"time\":\"12:05-12:45\",\"kind\":\"lesson\"},{\"id\":\"p8\",\"label\":\"Lesson 8\",\"time\":\"12:45-13:25\",\"kind\":\"lesson\"},{\"id\":\"b1\",\"label\":\"Lunch\",\"time\":\"13:25-14:00\",\"kind\":\"break\"},{\"id\":\"p9\",\"label\":\"Lesson 9\",\"time\":\"14:00-14:40\",\"kind\":\"lesson\"},{\"id\":\"p10\",\"label\":\"Lesson 10\",\"time\":\"14:40-15:20\",\"kind\":\"lesson\"}],\"published\":false,\"version\":0,\"updatedAt\":1793840119352,\"saturday\":false}','staged','2026-11-13 10:53:55',NULL),
(122,'st-teresa-backup-2026-11-12.json','classes','mw2tk846r75c6s','534516b43fab1a49f89a5c703d504925467606c79b7a151bca89a861b57f2562','{\"id\":\"mw2tk846r75c6s\",\"name\":\"PG X\",\"level\":1,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84bm26v5h\",\"teacherName\":\"Emmah Wanjiru Ndonga\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(123,'st-teresa-backup-2026-11-12.json','classes','mw2tk8460vsooq','dc0ed3c255138b7fd3da8958c95cedb989cc31bcab91d32ee948d91e0f07855d','{\"id\":\"mw2tk8460vsooq\",\"name\":\"PG Y\",\"level\":2,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84b80ybup\",\"teacherName\":\"Grace Wambui Gichuhi\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(124,'st-teresa-backup-2026-11-12.json','classes','mw2tk846ku5gg3','83469a28bf15cc271495c703d8d7c87a85f29755610e4123bfd1d1ea2ec46c34','{\"id\":\"mw2tk846ku5gg3\",\"name\":\"PG W\",\"level\":3,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"\",\"teacherName\":\"\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(125,'st-teresa-backup-2026-11-12.json','classes','mw2tk846mv9lkf','6052792ac0049ada0f874c3adaadf2c388c7700bbc32cb603624d6e19ba476df','{\"id\":\"mw2tk846mv9lkf\",\"name\":\"PP1 X\",\"level\":4,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84b9geev4\",\"teacherName\":\"Jacinta Wanjiku Ngunyi\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(126,'st-teresa-backup-2026-11-12.json','classes','mw2tk846pc3z8u','5265bc47a747f1bcc9761045281873622d01dc4dbf5db7ccfcaa3e37394107cd','{\"id\":\"mw2tk846pc3z8u\",\"name\":\"PP1 Y\",\"level\":5,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84byldhf7\",\"teacherName\":\"Veronicah Wangari Ndiritu\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(127,'st-teresa-backup-2026-11-12.json','classes','mw2tk846fx83ts','31c3e54151863001a5ef1f859b7aa1e6857d942ca8dd55de845619baba8e7b94','{\"id\":\"mw2tk846fx83ts\",\"name\":\"PP1 W\",\"level\":6,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84b45mfgm\",\"teacherName\":\"Emmah Nyawira Maina\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(128,'st-teresa-backup-2026-11-12.json','classes','mw2tk846nzxrwr','b826242eb4cb5be35f1a294a2eba370f2bd3f0c5817365183f019f6285a59eb7','{\"id\":\"mw2tk846nzxrwr\",\"name\":\"PP2 X\",\"level\":7,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84cghtb8n\",\"teacherName\":\"Joyce Wairimu Nderitu\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(129,'st-teresa-backup-2026-11-12.json','classes','mw2tk846v37dqe','20c6ec8abd57da96c1e61e4dd47b598ea4ea32277a23c2d10cc0f59b4b8acfc7','{\"id\":\"mw2tk846v37dqe\",\"name\":\"PP2 Y\",\"level\":8,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84cjifuyk\",\"teacherName\":\"Laurisia Njeri Gacheru\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(130,'st-teresa-backup-2026-11-12.json','classes','mw2tk846lfx58m','2a9c80eb449ec7f91ead22c68553d3f67d69d1455a1ea2b7652e7bb8155e63e2','{\"id\":\"mw2tk846lfx58m\",\"name\":\"PP2 W\",\"level\":9,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84ceudo5o\",\"teacherName\":\"Tabitha Wamuyu Kariuki\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(131,'st-teresa-backup-2026-11-12.json','classes','mw2tk84615gu3j','bed71a4e12ed54a960b736050d2629aaf275ccc4441905d8b01e1dfccfc53f79','{\"id\":\"mw2tk84615gu3j\",\"name\":\"Grade 1: Mt. Kenya\",\"level\":10,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84d56h6q3\",\"teacherName\":\"Tr. Margaret\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(132,'st-teresa-backup-2026-11-12.json','classes','mw2tk846xem40k','d8a46d1549898322a7f64ad2f6b1eb7e87cdf58b7d526c83feb57ef1561c44c3','{\"id\":\"mw2tk846xem40k\",\"name\":\"Grade 1: Mt. Ruwenzori\",\"level\":11,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84d4yb5q4\",\"teacherName\":\"Tr. Carol\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(133,'st-teresa-backup-2026-11-12.json','classes','mw2tk846dnewy1','86d3249fde1b86c669ceba804694ddb558449754727c5f82e69ba6f2ce727e24','{\"id\":\"mw2tk846dnewy1\",\"name\":\"Grade 1: Mt. Kilimanjaro\",\"level\":12,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84d9nugqg\",\"teacherName\":\"Tr. Eva\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(134,'st-teresa-backup-2026-11-12.json','classes','mw2tk846ln02ke','9db0e7ceb4c4222f9351010b66dde4002f980f1868771cdd2ed7c02cd742fcef','{\"id\":\"mw2tk846ln02ke\",\"name\":\"Grade 2: Mt. Kenya\",\"level\":13,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84dosz801\",\"teacherName\":\"Tr. Gladwel\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(135,'st-teresa-backup-2026-11-12.json','classes','mw2tk846dnn3xg','a581e9b7942e110e622aae3b9b21546c71c31aa4e70c2d68548e2c4dd807a1db','{\"id\":\"mw2tk846dnn3xg\",\"name\":\"Grade 2: Mt. Ruwenzori\",\"level\":14,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84dxo7xgh\",\"teacherName\":\"Tr. Alice\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(136,'st-teresa-backup-2026-11-12.json','classes','mw2tk8465xm1nj','4a7ba166cedee739e4045b701460eb209bcbf4b1960bb86cab68f53ca2cb291f','{\"id\":\"mw2tk8465xm1nj\",\"name\":\"Grade 2: Mt. Kilimanjaro\",\"level\":15,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84d2k99ur\",\"teacherName\":\"Tr. Jacinta\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(137,'st-teresa-backup-2026-11-12.json','classes','mw2tk84675gp93','5a81d3d8a090af13bd237befa277bab00a3926df97523dc0bbe93075a3086861','{\"id\":\"mw2tk84675gp93\",\"name\":\"Grade 3: Mt. Kenya\",\"level\":16,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84dl9r7wl\",\"teacherName\":\"Tr. Eliza\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(138,'st-teresa-backup-2026-11-12.json','classes','mw2tk8464dr96k','8362502ddecb226e70b3fcaa33abe35becb256fb0138384f86cdf0d3bc628cf8','{\"id\":\"mw2tk8464dr96k\",\"name\":\"Grade 3: Mt. Ruwenzori\",\"level\":17,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84dwhrwrx\",\"teacherName\":\"Tr. Mary\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(139,'st-teresa-backup-2026-11-12.json','classes','mw2tk846h8oqbo','261e640619f7f981970428dc042e4adaac7fb621944093edd15b82cd6f7758e4','{\"id\":\"mw2tk846h8oqbo\",\"name\":\"Grade 3: Mt. Kilimanjaro\",\"level\":18,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84dbdle7k\",\"teacherName\":\"Tr. Doris\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(140,'st-teresa-backup-2026-11-12.json','classes','mw2tk846b6xnnd','b9d8ed0ef58721b103fe40d7b4a01bb2704ab6fabcec11648723f9fada0bc757','{\"id\":\"mw2tk846b6xnnd\",\"name\":\"Grade 4: Mt. Kenya\",\"level\":19,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84ddkcbb7\",\"teacherName\":\"Tr. James\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(141,'st-teresa-backup-2026-11-12.json','classes','mw2tk846396n24','cccd83fd281fe588dff25806b380af8e18cf9a911428840084db7f8ff9b08df3','{\"id\":\"mw2tk846396n24\",\"name\":\"Grade 4: Mt. Ruwenzori\",\"level\":20,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84d3l5jvg\",\"teacherName\":\"Tr. Peris\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(142,'st-teresa-backup-2026-11-12.json','classes','mw2tk8468zfsdq','b6985ddaaa008db20eb9d826cc83c936522835c540ea91dd3fd974332b02ccc2','{\"id\":\"mw2tk8468zfsdq\",\"name\":\"Grade 4: Mt. Kilimanjaro\",\"level\":21,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk846iiet7j\",\"teacherName\":\"David Chen\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\",\"updatedAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(143,'st-teresa-backup-2026-11-12.json','classes','mw2tk846tok1vp','2401363355753e2cf593238f301115778330af673016878e312fe25bf8788b88','{\"id\":\"mw2tk846tok1vp\",\"name\":\"Grade 5: Mt. Kenya\",\"level\":22,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84diabatp\",\"teacherName\":\"Tr. Fidelis\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(144,'st-teresa-backup-2026-11-12.json','classes','mw2tk846itvut3','674119bac7432966072455ee2c1cc0431672a6e304075e093ed55bf2379aff17','{\"id\":\"mw2tk846itvut3\",\"name\":\"Grade 5: Mt. Ruwenzori\",\"level\":23,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84ecfc12k\",\"teacherName\":\"Tr. Doreen\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(145,'st-teresa-backup-2026-11-12.json','classes','mw2tk8466l4e2i','d9e534ff5df7fac7a55cce31219a7de9507235fb195fdda4b3a6f60163ba4200','{\"id\":\"mw2tk8466l4e2i\",\"name\":\"Grade 5: Mt. Kilimanjaro\",\"level\":24,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84do4zo99\",\"teacherName\":\"Mr. Maina\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(146,'st-teresa-backup-2026-11-12.json','classes','mw2tk846s7579u','36da4e13418f69e48b8b7852cb10033fd3c9c7652bf04564ea4058db8589cf20','{\"id\":\"mw2tk846s7579u\",\"name\":\"Grade 6: Mt. Kenya\",\"level\":25,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84e0bmy51\",\"teacherName\":\"Tr. Dennis\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(147,'st-teresa-backup-2026-11-12.json','classes','mw2tk846a8c9t1','7b8fe3479d7c2fe13c1713326f15faf03054f5621093a3d4f4be199c7fc4c802','{\"id\":\"mw2tk846a8c9t1\",\"name\":\"Grade 6: Mt. Ruwenzori\",\"level\":26,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84eqdweo9\",\"teacherName\":\"Tr. Emmanuel\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(148,'st-teresa-backup-2026-11-12.json','classes','mw2tk846jgdz4b','02e3c50150865439372f91077cf8f28a23ffe87f8c9094dc8faf948c63b7f0f0','{\"id\":\"mw2tk846jgdz4b\",\"name\":\"Grade 6: Mt. Kilimanjaro\",\"level\":27,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84etpi8px\",\"teacherName\":\"Mr. Macharia\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(149,'st-teresa-backup-2026-11-12.json','classes','mw2tk846axyse0','447e5ceb9edd07942487d2c4bc0f58ce9bb34ce1d5a5cdb938311651fcb4a262','{\"id\":\"mw2tk846axyse0\",\"name\":\"Grade 7: Mwai Kibaki\",\"level\":28,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84ej63rr4\",\"teacherName\":\"Mr. Kisaka\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(150,'st-teresa-backup-2026-11-12.json','classes','mw2tk846gw8u3u','549b5909c90afb9100a16462534cc00838da47041207e3c2089b3b71dc8466ae','{\"id\":\"mw2tk846gw8u3u\",\"name\":\"Grade 7: Wangari Maathai\",\"level\":29,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84ebxbxqo\",\"teacherName\":\"Tr. Priscilla\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(151,'st-teresa-backup-2026-11-12.json','classes','mw2tk846li0j8z','8bc3a709d912cd6d3771f13b785f408c2f35673e783cd15d3be2a3428206d798','{\"id\":\"mw2tk846li0j8z\",\"name\":\"Grade 8: Mwai Kibaki\",\"level\":30,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84eu86nus\",\"teacherName\":\"Tr. Gladys W\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(152,'st-teresa-backup-2026-11-12.json','classes','mw2tk84620w2yc','84408b907f540b0c5aba258291c57d62deb354112e626bf1ee100a46e880a8a7','{\"id\":\"mw2tk84620w2yc\",\"name\":\"Grade 8: Wangari Maathai\",\"level\":31,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84ehvim70\",\"teacherName\":\"Tr. Lewis\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(153,'st-teresa-backup-2026-11-12.json','classes','mw2tk8467imy6h','23de8467de39a42cdf15ae257c0fd516ab843c3b74b9fef80cdf9412cbc8e9e0','{\"id\":\"mw2tk8467imy6h\",\"name\":\"Grade 9: Mwai Kibaki\",\"level\":32,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84etraavt\",\"teacherName\":\"Mrs. Mwangi\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(154,'st-teresa-backup-2026-11-12.json','classes','mw2tk846gf27ez','5e5da3fa8aeffa4917ecfbb883d77af070bbea8b35f221bc799df9603baa2cca','{\"id\":\"mw2tk846gf27ez\",\"name\":\"Grade 9: Wangari Maathai\",\"level\":33,\"academicYear\":\"2026\",\"term\":\"1\",\"teacherId\":\"mw2tk84eokjre2\",\"teacherName\":\"Tr. Korir\",\"subjects\":[\"Mathematics\",\"English\",\"Kiswahili\",\"Science\",\"Social Studies\",\"Religion\",\"Art\",\"Physical Education\",\"Computer Science\"],\"status\":\"active\",\"createdAt\":\"2026-11-05\",\"assignmentDate\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(155,'st-teresa-backup-2026-11-12.json','classAssignments','mw2w04p287f8hd','31f562ad56a1c861574edd8245c9385830af2edabc3d1278fb50f594ef418e84','{\"id\":\"mw2w04p287f8hd\",\"classId\":\"mw2tk8468zfsdq\",\"className\":\"Grade 4: Mt. Kilimanjaro\",\"teacherId\":\"mw2tk846iiet7j\",\"teacherName\":\"David Chen\",\"assignedAt\":\"2026-11-05\",\"assignedBy\":\"System Administrator\",\"replacedAt\":\"\"}','staged','2026-11-13 10:53:55',NULL),
(156,'st-teresa-backup-2026-11-12.json','teachers','mw2tk846eqcaxr','1e7574b5a1d97a102a5becc4795d295a96c98a2d96c73b2de175a834d6632aef','{\"id\":\"mw2tk846eqcaxr\",\"firstName\":\"Margaret\",\"lastName\":\"OBrien\",\"email\":\"mobrien@stteresa.edu\",\"subject\":\"Mathematics\",\"role\":\"Teacher\",\"phone\":\"(555) 100-2000\",\"qualification\":\"M.Ed.\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"M.Ed. with 28 years in Catholic education.\",\"staffNo\":\"STA-T001\",\"accountId\":\"mw2tk8451y9bia\"}','staged','2026-11-13 10:53:55',NULL),
(157,'st-teresa-backup-2026-11-12.json','teachers','mw2tk846iiet7j','027edd74b1851c3324b006b06377d1495ac810256e7d153ddfae875076de9b68','{\"id\":\"mw2tk846iiet7j\",\"firstName\":\"David\",\"lastName\":\"Chen\",\"email\":\"dchen@stteresa.edu\",\"subject\":\"Science\",\"role\":\"Teacher\",\"phone\":\"(555) 100-2001\",\"qualification\":\"M.S. Engineering\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"M.S. in Engineering, inspiring innovators and problem-solvers.\",\"staffNo\":\"STA-T002\",\"accountId\":\"mw2tk84grlyvn3\"}','staged','2026-11-13 10:53:55',NULL),
(158,'st-teresa-backup-2026-11-12.json','teachers','mw2tk846l93sww','38b3d80d49e6dd8e51d2ed6f796e134ef7051f8bb207fe966f668a320eb30d2c','{\"id\":\"mw2tk846l93sww\",\"firstName\":\"Sarah\",\"lastName\":\"Williams\",\"email\":\"swilliams@stteresa.edu\",\"subject\":\"English\",\"role\":\"Teacher\",\"phone\":\"(555) 100-2002\",\"qualification\":\"M.A. Literature\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"M.A. Literature, sparking a love of reading and writing.\",\"staffNo\":\"STA-T003\",\"accountId\":\"mw2tk84gb2a1jg\"}','staged','2026-11-13 10:53:55',NULL),
(159,'st-teresa-backup-2026-11-12.json','teachers','mw2tk846j28dxa','1148ad1bff8bce6c49a3a43ac22aab069663926e04d3816b42d0c26db0d4120a','{\"id\":\"mw2tk846j28dxa\",\"firstName\":\"Catherine Marie\",\"lastName\":\"Sr.\",\"email\":\"cmarie@stteresa.edu\",\"subject\":\"Religion\",\"role\":\"Campus Ministry\",\"phone\":\"(555) 100-2003\",\"qualification\":\"Sister of St. Joseph\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"Sister of St. Joseph, guiding spiritual growth and service learning.\",\"staffNo\":\"STA-T004\",\"accountId\":\"mw2tk845mk9wnr\"}','staged','2026-11-13 10:53:55',NULL),
(160,'st-teresa-backup-2026-11-12.json','teachers','mw2tk846947ktq','c57750b0f509481ce14ce4343199dac2cc01ff160ba215305146e7ead111926c','{\"id\":\"mw2tk846947ktq\",\"firstName\":\"James\",\"lastName\":\"Whitfield\",\"email\":\"jwhitfield@stteresa.edu\",\"subject\":\"Physical Education\",\"role\":\"Athletic Director\",\"phone\":\"(555) 100-2004\",\"qualification\":\"B.S. Kinesiology\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"Former college athlete building character through sports.\",\"staffNo\":\"STA-T005\",\"accountId\":\"mw2tk84g57j9ep\"}','staged','2026-11-13 10:53:55',NULL),
(161,'st-teresa-backup-2026-11-12.json','teachers','mw2tk8460ek0bb','12a51d381cc3392d90ebccc5d917912ff927c6f3f9c7f6390faf0870e379af5e','{\"id\":\"mw2tk8460ek0bb\",\"firstName\":\"Thomas\",\"lastName\":\"Brennan\",\"email\":\"tbrennan@stteresa.edu\",\"subject\":\"Religion\",\"role\":\"Chaplain\",\"phone\":\"(555) 100-2005\",\"qualification\":\"M.Div.\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"Pastor and spiritual father guiding our community in faith.\",\"staffNo\":\"STA-T006\",\"accountId\":\"mw2tk84gfxxmj7\"}','staged','2026-11-13 10:53:55',NULL),
(162,'st-teresa-backup-2026-11-12.json','teachers','mw2tk846d2tbvt','460d7069e54067996282691c12afac6d80d93fe0daef198bcf99d7234d12f9c9','{\"id\":\"mw2tk846d2tbvt\",\"firstName\":\"Anthony\",\"lastName\":\"Rossi\",\"email\":\"arossi@stteresa.edu\",\"subject\":\"Mathematics\",\"role\":\"Vice Principal, Academics\",\"phone\":\"(555) 100-2006\",\"qualification\":\"M.A. Curriculum & Instruction\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"Championing rigorous and innovative learning.\",\"staffNo\":\"STA-T007\",\"accountId\":\"mw2tk845vyp15w\"}','staged','2026-11-13 10:53:55',NULL),
(163,'st-teresa-backup-2026-11-12.json','teachers','mw2tk846ewe2md','9098656ab404c6da5f08cbe5ca1ad6a500d9725f53cd428652027f901b3d60ae','{\"id\":\"mw2tk846ewe2md\",\"firstName\":\"Linda\",\"lastName\":\"Vasquez\",\"email\":\"lvasquez@stteresa.edu\",\"subject\":\"Administration\",\"role\":\"Director of Admissions\",\"phone\":\"(555) 100-2007\",\"qualification\":\"M.B.A.\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"Welcoming families through the admissions journey.\",\"staffNo\":\"STA-T008\",\"accountId\":\"mw2tk845ub1opf\"}','staged','2026-11-13 10:53:55',NULL),
(164,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84bm26v5h','7ff09207c04ca5dfd8bad67560b5ee9e3a7dabd1f976eababec20bf130bc54a8','{\"id\":\"mw2tk84bm26v5h\",\"firstName\":\"Emmah\",\"lastName\":\"Wanjiru Ndonga\",\"email\":\"emmah.ndonga@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-001\",\"accountId\":\"mw2tk84gprtc17\"}','staged','2026-11-13 10:53:55',NULL),
(165,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84b3clybf','037ba1f05aec6ef2cf76b33d954e9eb9ca1dd76ccd13252371fcaeb4986ca16e','{\"id\":\"mw2tk84b3clybf\",\"firstName\":\"Irene\",\"lastName\":\"Wambui Gachichio\",\"email\":\"irene.gachichio@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-002\",\"accountId\":\"mw2tk84g9c216p\"}','staged','2026-11-13 10:53:55',NULL),
(166,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84b80ybup','4c47ee57a5ea45a43b217d1df7187cbdb5f0acd11ac690c96735dfb4a608eed1','{\"id\":\"mw2tk84b80ybup\",\"firstName\":\"Grace\",\"lastName\":\"Wambui Gichuhi\",\"email\":\"grace.gichuhi@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-003\",\"accountId\":\"mw2tk84hisgx7h\"}','staged','2026-11-13 10:53:55',NULL),
(167,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84bco4sq9','cda34b3a44df600b1bf3a4e581c0c71f677f364ff204ec65204f84c7f438cab4','{\"id\":\"mw2tk84bco4sq9\",\"firstName\":\"Pamela\",\"lastName\":\"Muyoka Masinde\",\"email\":\"pamela.masinde@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-004\",\"accountId\":\"mw2tk84hgafly2\"}','staged','2026-11-13 10:53:55',NULL),
(168,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84b45mfgm','76c720bbfa35adbadbed14d86a4f666b0674c30b8f1d1a228b7ae6d247fad1bb','{\"id\":\"mw2tk84b45mfgm\",\"firstName\":\"Emmah\",\"lastName\":\"Nyawira Maina\",\"email\":\"emmah.maina@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-005\",\"accountId\":\"mw2tk84hxsek2o\"}','staged','2026-11-13 10:53:55',NULL),
(169,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84b927otd','b25d81272e239e703971e2743462d61dca2eabcb2f908d6e51815382a93d988b','{\"id\":\"mw2tk84b927otd\",\"firstName\":\"Purity\",\"lastName\":\"Muthoni Kabiru\",\"email\":\"purity.kabiru@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-006\",\"accountId\":\"mw2tk84hs8vhd3\"}','staged','2026-11-13 10:53:55',NULL),
(170,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84b9geev4','832cfbbc076666f967d7dd403f5195f37b776dc8d06b70cafcc62f5e42778321','{\"id\":\"mw2tk84b9geev4\",\"firstName\":\"Jacinta\",\"lastName\":\"Wanjiku Ngunyi\",\"email\":\"jacinta.ngunyi@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-007\",\"accountId\":\"mw2tk84hqlrs2t\"}','staged','2026-11-13 10:53:55',NULL),
(171,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84boh40el','667c7fc66a02eb6288d5b73a6c1e1c7ccf075b39f12b5770a843641c24e08901','{\"id\":\"mw2tk84boh40el\",\"firstName\":\"Lucy\",\"lastName\":\"Wanjiru Miano\",\"email\":\"lucy.miano@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-008\",\"accountId\":\"mw2tk84hsx11sb\"}','staged','2026-11-13 10:53:55',NULL),
(172,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84byldhf7','64be18306faca813eebf628d07b2b8858e7c0c5d8683ba3aeb8d4aabc7ccc6fd','{\"id\":\"mw2tk84byldhf7\",\"firstName\":\"Veronicah\",\"lastName\":\"Wangari Ndiritu\",\"email\":\"veronicah.ndiritu@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-009\",\"accountId\":\"mw2tk84h7m88bz\"}','staged','2026-11-13 10:53:55',NULL),
(173,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84cx9lzyb','fdc387f87f28f407cd13fa2c4a0bd6d1093eaf15d13c8a076b1ba94aaecd53f4','{\"id\":\"mw2tk84cx9lzyb\",\"firstName\":\"Isabel\",\"lastName\":\"Mumbi Macharia\",\"email\":\"isabel.macharia@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-010\",\"accountId\":\"mw2tk84hn5lkxs\"}','staged','2026-11-13 10:53:55',NULL),
(174,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84ceudo5o','a140dcb1ce28c4363b9452d7b932ad35cfa8fffc0e0d40de0e9dbd45d2b253cb','{\"id\":\"mw2tk84ceudo5o\",\"firstName\":\"Tabitha\",\"lastName\":\"Wamuyu Kariuki\",\"email\":\"tabitha.kariuki@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-011\",\"accountId\":\"mw2tk84hskt9xs\"}','staged','2026-11-13 10:53:55',NULL),
(175,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84cghtb8n','82c77c4abbe5e2b234ef0b1d316e615363ddf9de9dbe76efd9af7afdb32042b8','{\"id\":\"mw2tk84cghtb8n\",\"firstName\":\"Joyce\",\"lastName\":\"Wairimu Nderitu\",\"email\":\"joyce.nderitu@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-012\",\"accountId\":\"mw2tk84hdmitvb\"}','staged','2026-11-13 10:53:55',NULL),
(176,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84cmkg6s0','b1464ca00b24177bba0f7ed116fe809bf221ede2e06184d2b8e5bed7de69e554','{\"id\":\"mw2tk84cmkg6s0\",\"firstName\":\"Grace\",\"lastName\":\"Wanjiku Gitau\",\"email\":\"grace.gitau@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-013\",\"accountId\":\"mw2tk84h4cz7hv\"}','staged','2026-11-13 10:53:55',NULL),
(177,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84cjifuyk','1913d780adaa7da741af7e49631254eb327e02aea6105d0226e0a356053936b9','{\"id\":\"mw2tk84cjifuyk\",\"firstName\":\"Laurisia\",\"lastName\":\"Njeri Gacheru\",\"email\":\"laurisia.gacheru@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-014\",\"accountId\":\"mw2tk84hh0jo3w\"}','staged','2026-11-13 10:53:55',NULL),
(178,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84crgenbq','74b0bd680847a5e0bf74497c9bd26a8e7b3c986ae1ded005f293902a1044fffd','{\"id\":\"mw2tk84crgenbq\",\"firstName\":\"Emma\",\"lastName\":\"Muthoni Muriuki\",\"email\":\"emma.muriuki@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-015\",\"accountId\":\"mw2tk84haf7iz0\"}','staged','2026-11-13 10:53:55',NULL),
(179,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84d9nugqg','0add2965fad5bb3c089813b4bb9787b5bbb8f81600ac48177012f01d74957fbb','{\"id\":\"mw2tk84d9nugqg\",\"firstName\":\"Tr. Eva\",\"lastName\":\"\",\"email\":\"tr.eva@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-001\",\"accountId\":\"mw2tk84hqfhc84\"}','staged','2026-11-13 10:53:55',NULL),
(180,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84d56h6q3','beaf6b72c1aa655fc2a454ef02e866d89efc7b487f2299d5118393b353bad1b7','{\"id\":\"mw2tk84d56h6q3\",\"firstName\":\"Tr. Margaret\",\"lastName\":\"\",\"email\":\"tr.margaret@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-002\",\"accountId\":\"mw2tk84hjfapot\"}','staged','2026-11-13 10:53:55',NULL),
(181,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84d4yb5q4','88a396a3166f015326e08ba2d7f6c8bb1b848d3cf46a2b964ac93ee110ef0795','{\"id\":\"mw2tk84d4yb5q4\",\"firstName\":\"Tr. Carol\",\"lastName\":\"\",\"email\":\"tr.carol@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-003\",\"accountId\":\"mw2tk84hre1hc6\"}','staged','2026-11-13 10:53:55',NULL),
(182,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84d2k99ur','e16a93d9365e5400ab07d0d2c6efe01afd0a95edc1f9268eefcd6b7e4bb6b99e','{\"id\":\"mw2tk84d2k99ur\",\"firstName\":\"Tr. Jacinta\",\"lastName\":\"\",\"email\":\"tr.jacinta@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-004\",\"accountId\":\"mw2tk84hr2yr54\"}','staged','2026-11-13 10:53:55',NULL),
(183,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84dosz801','66c2a385ade001aa3d3a68c9b6a02fa252e5d774dd35e2b996dd41e06b5c16d3','{\"id\":\"mw2tk84dosz801\",\"firstName\":\"Tr. Gladwel\",\"lastName\":\"\",\"email\":\"tr.gladwel@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-005\",\"accountId\":\"mw2tk84ixpbfo2\"}','staged','2026-11-13 10:53:55',NULL),
(184,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84dxo7xgh','b937254488e4684c21b055e7ae4292a9e3b7fce74a221a7eb54240c75d6ed615','{\"id\":\"mw2tk84dxo7xgh\",\"firstName\":\"Tr. Alice\",\"lastName\":\"\",\"email\":\"tr.alice@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-006\",\"accountId\":\"mw2tk84i9qq561\"}','staged','2026-11-13 10:53:55',NULL),
(185,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84dbdle7k','7022fd42e57786e1180dfba460fb76628d175b2f6bf7f1615420eee19ba7944f','{\"id\":\"mw2tk84dbdle7k\",\"firstName\":\"Tr. Doris\",\"lastName\":\"\",\"email\":\"tr.doris@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-007\",\"accountId\":\"mw2tk84innixo9\"}','staged','2026-11-13 10:53:55',NULL),
(186,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84dl9r7wl','18900ef1fd0bd213a619a5c9b2cc933a1a9b0a2db3d42e067ccf755b4a8bb8af','{\"id\":\"mw2tk84dl9r7wl\",\"firstName\":\"Tr. Eliza\",\"lastName\":\"\",\"email\":\"tr.eliza@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-008\",\"accountId\":\"mw2tk84itjtngc\"}','staged','2026-11-13 10:53:55',NULL),
(187,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84dwhrwrx','6e5f439653e17b7c318bf5c8e832ad496d2d3895d3b8a6b2c8f5e5e87f6421f9','{\"id\":\"mw2tk84dwhrwrx\",\"firstName\":\"Tr. Mary\",\"lastName\":\"\",\"email\":\"tr.mary@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-009\",\"accountId\":\"mw2tk84i1mchey\"}','staged','2026-11-13 10:53:55',NULL),
(188,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84dkdo1w0','e2f4f9db50df06d25d5fac109b075ea39283fa39573e7161241f4dc199a15308','{\"id\":\"mw2tk84dkdo1w0\",\"firstName\":\"Tr. Elvis\",\"lastName\":\"\",\"email\":\"tr.elvis@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-010\",\"accountId\":\"mw2tk84idz80lb\"}','staged','2026-11-13 10:53:55',NULL),
(189,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84ddkcbb7','0f278c93d8696a1b2b32de161a4d8251ffd63ec4c76808df03c3e4ee9c9b1a43','{\"id\":\"mw2tk84ddkcbb7\",\"firstName\":\"Tr. James\",\"lastName\":\"\",\"email\":\"tr.james@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-011\",\"accountId\":\"mw2tk84igd74nn\"}','staged','2026-11-13 10:53:55',NULL),
(190,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84d3l5jvg','f18d7637bce22b409088f468aa539e7dad188c85a626aac21bb0c978ad4c919b','{\"id\":\"mw2tk84d3l5jvg\",\"firstName\":\"Tr. Peris\",\"lastName\":\"\",\"email\":\"tr.peris@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-012\",\"accountId\":\"mw2tk84ilr2ikd\"}','staged','2026-11-13 10:53:55',NULL),
(191,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84do4zo99','a139fac783c1709bdd9f039a1760bdb87b1617339db8f253bff92c357076064c','{\"id\":\"mw2tk84do4zo99\",\"firstName\":\"Mr. Maina\",\"lastName\":\"\",\"email\":\"mr.maina@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-013\",\"accountId\":\"mw2tk84i7a3pek\"}','staged','2026-11-13 10:53:55',NULL),
(192,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84diabatp','f0a063ddedaada6b613313300f9784e31797641902c34a7cf173459479d1aaf2','{\"id\":\"mw2tk84diabatp\",\"firstName\":\"Tr. Fidelis\",\"lastName\":\"\",\"email\":\"tr.fidelis@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-014\",\"accountId\":\"mw2tk84iz5osoq\"}','staged','2026-11-13 10:53:55',NULL),
(193,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84ecfc12k','8e17329457f8ad2faa0c71b63ec711cb853625174cceebe2d67a5e0fb8223449','{\"id\":\"mw2tk84ecfc12k\",\"firstName\":\"Tr. Doreen\",\"lastName\":\"\",\"email\":\"tr.doreen@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-015\",\"accountId\":\"mw2tk84jeyea1m\"}','staged','2026-11-13 10:53:55',NULL),
(194,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84etpi8px','b727f420a852958a6153f4e9e5259a59654095eda19971285e1a1479de9152af','{\"id\":\"mw2tk84etpi8px\",\"firstName\":\"Mr. Macharia\",\"lastName\":\"\",\"email\":\"mr.macharia@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-016\",\"accountId\":\"mw2tk84jrkghi6\"}','staged','2026-11-13 10:53:55',NULL),
(195,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84e0bmy51','9399f49c195d6a2c27b2d40a41b00a04487f20e34978da005f26a179be04f1ec','{\"id\":\"mw2tk84e0bmy51\",\"firstName\":\"Tr. Dennis\",\"lastName\":\"\",\"email\":\"tr.dennis@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-017\",\"accountId\":\"mw2tk84jltkfuu\"}','staged','2026-11-13 10:53:55',NULL),
(196,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84eqdweo9','ebc7d5ddd8bb8ff1d20141568de9863e765567f16f8e385044d00451f3479474','{\"id\":\"mw2tk84eqdweo9\",\"firstName\":\"Tr. Emmanuel\",\"lastName\":\"\",\"email\":\"tr.emmanuel@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-018\",\"accountId\":\"mw2tk84jucn4ud\"}','staged','2026-11-13 10:53:55',NULL),
(197,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84ebxbxqo','b93f437d34c5d0fe35116f7c8164c4b94e49677c13df63f552c582070dca208a','{\"id\":\"mw2tk84ebxbxqo\",\"firstName\":\"Tr. Priscilla\",\"lastName\":\"\",\"email\":\"tr.priscilla@stteresaacademy.edu\",\"subject\":\"Junior Secondary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-019\",\"accountId\":\"mw2tk84j2r5v6v\"}','staged','2026-11-13 10:53:55',NULL),
(198,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84ej63rr4','c1e07bcb7d67453e8afea2fb256b25395bfbca0a9cc566ddf1e2ff9f8edff3ed','{\"id\":\"mw2tk84ej63rr4\",\"firstName\":\"Mr. Kisaka\",\"lastName\":\"\",\"email\":\"mr.kisaka@stteresaacademy.edu\",\"subject\":\"Junior Secondary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-020\",\"accountId\":\"mw2tk84jpufbnq\"}','staged','2026-11-13 10:53:55',NULL),
(199,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84ehvim70','b9da82c6b7d78ccc69ec23cd46dcd1602be72326a1197658d7b9461b50902c3b','{\"id\":\"mw2tk84ehvim70\",\"firstName\":\"Tr. Lewis\",\"lastName\":\"\",\"email\":\"tr.lewis@stteresaacademy.edu\",\"subject\":\"Junior Secondary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-021\",\"accountId\":\"mw2tk84jv3wv0j\"}','staged','2026-11-13 10:53:55',NULL),
(200,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84eu86nus','8dece0e03a0ff19c334290c678312ca890e5dc56e0c8cb2b4e301a5d762ea224','{\"id\":\"mw2tk84eu86nus\",\"firstName\":\"Tr. Gladys W\",\"lastName\":\"\",\"email\":\"tr.gladys.w@stteresaacademy.edu\",\"subject\":\"Junior Secondary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-022\",\"accountId\":\"mw2tk84jx4z5ks\"}','staged','2026-11-13 10:53:55',NULL),
(201,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84eokjre2','cccaed2db0a31f3eeeefc6d1e18dde47a524705606c6928a9598247c52914e18','{\"id\":\"mw2tk84eokjre2\",\"firstName\":\"Tr. Korir\",\"lastName\":\"\",\"email\":\"tr.korir@stteresaacademy.edu\",\"subject\":\"Junior Secondary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-023\",\"accountId\":\"mw2tk84jl5ofpc\"}','staged','2026-11-13 10:53:55',NULL),
(202,'st-teresa-backup-2026-11-12.json','teachers','mw2tk84etraavt','e29cd80f491d2f123a476f97fbb53a74416432d513eef6e972be8ac15d4f9c1a','{\"id\":\"mw2tk84etraavt\",\"firstName\":\"Mrs. Mwangi\",\"lastName\":\"\",\"email\":\"mrs.mwangi@stteresaacademy.edu\",\"subject\":\"Junior Secondary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-024\",\"accountId\":\"mw2tk84kin60kx\"}','staged','2026-11-13 10:53:55',NULL),
(203,'st-teresa-backup-2026-11-12.json','accountsSeeded','accountsSeeded-0','6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b','1','staged','2026-11-13 10:53:55',NULL),
(204,'st-teresa-backup-2026-11-12.json','settings','settings-0','b73909660dc62eec927e7725aca1fd029d24757ac5487e337712873c6b51825b','{\"schoolName\":\"St. Teresa Academy\",\"motto\":\"Unity is Strength\",\"currency\":\"Ksh\",\"academicYear\":\"2026\",\"term\":\"1\",\"timezone\":\"Africa/Nairobi\",\"academicYearId\":\"mw2tk849i1pspg\"}','staged','2026-11-13 10:53:55',NULL),
(205,'st-teresa-backup-2026-11-12.json','feeItems','tuition','d2e624b7b8266b8c605c9bc7f515c6307a7787d6b838f225f7cd8659b3b95acb','{\"id\":\"tuition\",\"name\":\"Tuition Fee\",\"price\":4200,\"icon\":\"fa-graduation-cap\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','staged','2026-11-13 10:53:55',NULL),
(206,'st-teresa-backup-2026-11-12.json','feeItems','admission','b91232db8bb9251ed611c72d4b411cc8b95e55e2bd2483a4a849a9213d5f514b','{\"id\":\"admission\",\"name\":\"Admission Fee\",\"price\":500,\"icon\":\"fa-file-signature\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','staged','2026-11-13 10:53:55',NULL),
(207,'st-teresa-backup-2026-11-12.json','feeItems','lab','f10bc4bf2bf2717285a80543067270d227c679eb8817a8a5c2dd5b7ca4786c64','{\"id\":\"lab\",\"name\":\"Laboratory Fee\",\"price\":300,\"icon\":\"fa-flask\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','staged','2026-11-13 10:53:55',NULL),
(208,'st-teresa-backup-2026-11-12.json','feeItems','library','9e68eb2c8317213725a899d6eaf96471a12b07519dab7fc91da355a057dc80be','{\"id\":\"library\",\"name\":\"Library Fee\",\"price\":150,\"icon\":\"fa-book\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','staged','2026-11-13 10:53:55',NULL),
(209,'st-teresa-backup-2026-11-12.json','feeItems','transport','d65ce15621f4097230487a2e90163d2124e192b989c953b460fe37c11f62e2f8','{\"id\":\"transport\",\"name\":\"Transport Fee\",\"price\":800,\"icon\":\"fa-bus\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','staged','2026-11-13 10:53:55',NULL),
(210,'st-teresa-backup-2026-11-12.json','feeItems','uniform','71fca569e7430a2b47fdb49a79c93e4e970ad5057096077893a672e55d5d83bb','{\"id\":\"uniform\",\"name\":\"Uniform Fee\",\"price\":220,\"icon\":\"fa-tshirt\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','staged','2026-11-13 10:53:55',NULL),
(211,'st-teresa-backup-2026-11-12.json','feeItems','sports','5081cdf3286654fb118fc5c5fe582f2ddb6ef0bd3c5c31395918ddcb9715b038','{\"id\":\"sports\",\"name\":\"Sports Fee\",\"price\":180,\"icon\":\"fa-futbol\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','staged','2026-11-13 10:53:55',NULL),
(212,'st-teresa-backup-2026-11-12.json','feeItems','exam','df5b8f383fc30537078af1c7912792f9fac21c0ce6c09467c5cf279a1f2e554d','{\"id\":\"exam\",\"name\":\"Exam Fee\",\"price\":120,\"icon\":\"fa-pen\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','staged','2026-11-13 10:53:55',NULL),
(213,'st-teresa-backup-2026-11-12.json','feeItems','activity','88480a152e430664a52b9ca1d1dd41004fddfb29d10ddcb3bd23d1d603434b66','{\"id\":\"activity\",\"name\":\"Activity Fee\",\"price\":250,\"icon\":\"fa-palette\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','staged','2026-11-13 10:53:55',NULL),
(214,'st-teresa-backup-2026-11-12.json','feeItems','meal','c581db0886e4151fb93d496ac5b98d1aa3d424c2607030d769054ec10c4a13de','{\"id\":\"meal\",\"name\":\"Meal Plan\",\"price\":650,\"icon\":\"fa-utensils\",\"active\":true,\"createdAt\":\"2026-11-05\",\"createdBy\":\"migration\"}','staged','2026-11-13 10:53:55',NULL),
(215,'st-teresa-backup-2026-11-12.json','logo','logo-0','3a9768dcd096300f52f3fb27bf868fb31b3dd9597323c6cc1adf4ed869a23557','{\"name\":\"St. Teresa Kanyange Academy\",\"initials\":\"STK\"}','staged','2026-11-13 10:53:55',NULL),
(216,'st-teresa-backup-2026-11-12.json','slider','mw2tmc1096kzt7','f9607296db1c94b1ee99a864df24b7f72208e23f8d51a204b376e31406604948','{\"id\":\"mw2tmc1096kzt7\",\"title\":\"The heading displayed on the slider\",\"description\":\"Supporting text displayed below the heading.\",\"imageUrl\":\"\",\"imageKey\":\"mw2tmc1096kzt7\"}','staged','2026-11-13 10:53:55',NULL),
(217,'st-teresa-backup-2026-11-12.json','slider','mwdlb7qum1ldnz','892d1b7ec1a21bfb27bcc378ba81da21b16a353e7286a0cad2e35f1effafa8f1','{\"id\":\"mwdlb7qum1ldnz\",\"title\":\"Welcome to Our School\",\"description\":\"Providing quality education, nurturing talents, building character, and empowering learners to achieve their dreams in a safe, supportive, and inspiring learning environment.\",\"imageUrl\":\"\",\"imageKey\":\"mwdlb7qum1ldnz\"}','staged','2026-11-13 10:53:55',NULL),
(218,'st-teresa-backup-2026-11-12.json','seeded','seeded-0','6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b','1','staged','2026-11-13 10:53:55',NULL),
(219,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84b0xh4wh','bd9ff3537715bf30a68e64ecc58fdf3bc52839bbee86b5e95bd7e8035c8b0a11','{\"id\":\"mw2tk84b0xh4wh\",\"name\":\"Emmah Wanjiru Ndonga\",\"shortName\":\"E. Ndonga\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PG X\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PG X\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84bm26v5h\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(220,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84ba5pp5p','5ca209e0393a561218ed2c952a70b743c41c40b155c4ab95f6646062db28dcd9','{\"id\":\"mw2tk84ba5pp5p\",\"name\":\"Irene Wambui Gachichio\",\"shortName\":\"I. Gachichio\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PG X\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84b3clybf\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(221,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84bzk4orl','2ad01d67eeb7d651b20e31a318f5c785bdaf7e9384fb7250f32976001f11da14','{\"id\":\"mw2tk84bzk4orl\",\"name\":\"Grace Wambui Gichuhi\",\"shortName\":\"G. Gichuhi\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PG Y\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PG Y\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84b80ybup\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(222,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84b5hk1zv','3156e5c90f1565ae0db8c6db0156d3935a08ad9f43ac64e05c9038f43400edaa','{\"id\":\"mw2tk84b5hk1zv\",\"name\":\"Pamela Muyoka Masinde\",\"shortName\":\"P. Masinde\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PG Y\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84bco4sq9\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(223,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84b3r5dlg','dfcb3077d83eb287626d000bb5bca4d69093529c56f37c863a8487fa822d7577','{\"id\":\"mw2tk84b3r5dlg\",\"name\":\"Emmah Nyawira Maina\",\"shortName\":\"E. Maina\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PP1 W\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP1 W\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84b45mfgm\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(224,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84bfazq4g','783b2bb7403428abdd44afc444bc8fcbbd13334397934d2fe134f97c58150042','{\"id\":\"mw2tk84bfazq4g\",\"name\":\"Purity Muthoni Kabiru\",\"shortName\":\"P. Kabiru\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP1 W\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84b927otd\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(225,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84bgty5gw','8e8cd400176c3c55a04aac261ae8e907ee8fa20f4dde35fa5275ee855079ad0a','{\"id\":\"mw2tk84bgty5gw\",\"name\":\"Jacinta Wanjiku Ngunyi\",\"shortName\":\"J. Ngunyi\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PP1 X\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP1 X\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84b9geev4\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(226,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84bwhd3bl','7564722c56241273bd1d09612e0f9f0ca2268d8578ee12c12795f111210c8dca','{\"id\":\"mw2tk84bwhd3bl\",\"name\":\"Lucy Wanjiru Miano\",\"shortName\":\"L. Miano\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP1 X\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84boh40el\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(227,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84byew6tu','0514f7da37431af7b1ee6369a89f7a80b2d3de5f423a0be3ea8b2c55e56f3b2f','{\"id\":\"mw2tk84byew6tu\",\"name\":\"Veronicah Wangari Ndiritu\",\"shortName\":\"V. Ndiritu\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PP1 Y\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP1 Y\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84byldhf7\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(228,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84ch912ko','fe35096a3b1609721a34ab73bdea2698b26b17cde66c2e72a3f0fe334d186393','{\"id\":\"mw2tk84ch912ko\",\"name\":\"Isabel Mumbi Macharia\",\"shortName\":\"I. Macharia\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP1 Y\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84cx9lzyb\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(229,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84c1oivqk','df03679f90869ea13be037d7d26e3983a2bed4cabe308337571fa508c9def547','{\"id\":\"mw2tk84c1oivqk\",\"name\":\"Tabitha Wamuyu Kariuki\",\"shortName\":\"T. Kariuki\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PP2 W\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP2 W\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84ceudo5o\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(230,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84ct7lff7','c2d79e2e40196713c1281d4e713286d0ecd1ceef5e3a221357ecd50e79d1db63','{\"id\":\"mw2tk84ct7lff7\",\"name\":\"Joyce Wairimu Nderitu\",\"shortName\":\"J. Nderitu\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PP2 X\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP2 X\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84cghtb8n\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(231,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84c6j4enf','a2740b8a9d4e67c235570625d5d0ec4f99b91d633b217b6630db252441ee8c3f','{\"id\":\"mw2tk84c6j4enf\",\"name\":\"Grace Wanjiku Gitau\",\"shortName\":\"G. Gitau\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP2 X\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84cmkg6s0\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(232,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84c7vnxsk','ecd0f716563b6054ea58284cb67d641d1979f5e8f72551752fd5625db6d7dcb1','{\"id\":\"mw2tk84c7vnxsk\",\"name\":\"Laurisia Njeri Gacheru\",\"shortName\":\"L. Gacheru\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"PP2 Y\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP2 Y\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84cjifuyk\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(233,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84c9byry8','c0c6e34bce6b9e1d35c3a217f037f8d19b02b7bd9dd9b5388c3eec839fb4d1ee','{\"id\":\"mw2tk84c9byry8\",\"name\":\"Emma Muthoni Muriuki\",\"shortName\":\"E. Muriuki\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Kindergarten\"],\"classes\":[\"PP2 Y\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84crgenbq\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(234,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84davx3ag','0c299fd55889c9bbb39bdaf7543fa1d5e85c9562e01841bc432ed404c6f45303','{\"id\":\"mw2tk84davx3ag\",\"name\":\"Tr. Eva\",\"shortName\":\"Tr. Eva\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 1: Mt. Kilimanjaro\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 1: Mt. Kilimanjaro\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84d9nugqg\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(235,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84d0u8d2y','c45c1c6d018bb81a53ab6e811bdf5aee85ff2c546c047344a076ca0fb7a1e417','{\"id\":\"mw2tk84d0u8d2y\",\"name\":\"Tr. Margaret\",\"shortName\":\"Tr. Margaret\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 1: Mt. Kenya\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 1: Mt. Kenya\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84d56h6q3\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(236,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84dmnpn27','c7542c89cab582334c3e4975621585ed21d3634e531e4c2fee568ed2bc62179b','{\"id\":\"mw2tk84dmnpn27\",\"name\":\"Tr. Carol\",\"shortName\":\"Tr. Carol\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 1: Mt. Ruwenzori\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 1: Mt. Ruwenzori\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84d4yb5q4\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(237,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84dqy4lc1','898b1577197ba41da537ffe4d47ed80fe9e2f7e1e1aa2a77e0e45f4d87c0fa83','{\"id\":\"mw2tk84dqy4lc1\",\"name\":\"Tr. Jacinta\",\"shortName\":\"Tr. Jacinta\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 2: Mt. Kilimanjaro\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 2: Mt. Kilimanjaro\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84d2k99ur\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(238,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84d32vs10','ab1985922642c12f9b8689afd138a0d9956b5eb129cc9189904c7af365649244','{\"id\":\"mw2tk84d32vs10\",\"name\":\"Tr. Gladwel\",\"shortName\":\"Tr. Gladwel\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 2: Mt. Kenya\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 2: Mt. Kenya\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84dosz801\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(239,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84d43womx','d9cf61f5e3dff4ef6a5823cefc95e27942d9a5952ce40a586a28e271aa49dab9','{\"id\":\"mw2tk84d43womx\",\"name\":\"Tr. Alice\",\"shortName\":\"Tr. Alice\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 2: Mt. Ruwenzori\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 2: Mt. Ruwenzori\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84dxo7xgh\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(240,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84ddrolu6','31ede8aa7f5448cf3ccb523d99561fd9129536c0e285e3d72bd45203c8c89264','{\"id\":\"mw2tk84ddrolu6\",\"name\":\"Tr. Doris\",\"shortName\":\"Tr. Doris\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 3: Mt. Kilimanjaro\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 3: Mt. Kilimanjaro\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84dbdle7k\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(241,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84dlo5aqf','d8bb79d163d6e6c8770c2664a4d28d1ddc146da31096f6138dd9ecb3fb7b2a30','{\"id\":\"mw2tk84dlo5aqf\",\"name\":\"Tr. Eliza\",\"shortName\":\"Tr. Eliza\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 3: Mt. Kenya\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 3: Mt. Kenya\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84dl9r7wl\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(242,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84d4p23sa','969fc85316261b15e633f8b68a1dcd0ebf5313faffd9f7bb3d9736386a326e97','{\"id\":\"mw2tk84d4p23sa\",\"name\":\"Tr. Mary\",\"shortName\":\"Tr. Mary\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 3: Mt. Ruwenzori\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 3: Mt. Ruwenzori\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84dwhrwrx\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(243,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84dqot6ah','e904866d21fc7bcbb062f12f84c5fac7f14426b1caa3c02cf5ee8df564aca600','{\"id\":\"mw2tk84dqot6ah\",\"name\":\"Tr. Elvis\",\"shortName\":\"Tr. Elvis\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 4: Mt. Kilimanjaro\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 4: Mt. Kilimanjaro\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84dkdo1w0\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(244,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84dvzo6nj','2039013d85d6dd4cf7b4c4bd50cb2589c397d5288f2d07b2308d323913be15e1','{\"id\":\"mw2tk84dvzo6nj\",\"name\":\"Tr. James\",\"shortName\":\"Tr. James\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 4: Mt. Kenya\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 4: Mt. Kenya\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84ddkcbb7\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(245,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84d2umncv','e01a1fa77383ee96781c5f3f3ca5a11d8cffb48e50f8a57d36646dbe933560ab','{\"id\":\"mw2tk84d2umncv\",\"name\":\"Tr. Peris\",\"shortName\":\"Tr. Peris\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 4: Mt. Ruwenzori\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 4: Mt. Ruwenzori\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84d3l5jvg\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(246,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84dtiu2so','7203c9f5478cade7b91bf49aabc3c7e70e03f78d736ff7aa578f1a03ac1b5807','{\"id\":\"mw2tk84dtiu2so\",\"name\":\"Mr. Maina\",\"shortName\":\"Mr. Maina\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 5: Mt. Kilimanjaro\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 5: Mt. Kilimanjaro\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84do4zo99\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(247,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84dl8qtbm','76ec7c7a92b1e25eb7dd2a28d02b1b908669014d3df310f9e23374f8feffae2c','{\"id\":\"mw2tk84dl8qtbm\",\"name\":\"Tr. Fidelis\",\"shortName\":\"Tr. Fidelis\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 5: Mt. Kenya\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 5: Mt. Kenya\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84diabatp\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(248,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84e4vxtqr','8ee5fb36afba823f3f19e92ef82ec8777f3577a33eaec44106c06e18a07e2b85','{\"id\":\"mw2tk84e4vxtqr\",\"name\":\"Tr. Doreen\",\"shortName\":\"Tr. Doreen\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 5: Mt. Ruwenzori\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 5: Mt. Ruwenzori\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84ecfc12k\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(249,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84esln2gr','3f9f60d8bfd3c60a1e67a984fecb77a910e281c57a98fd83812d9d2cfebe2258','{\"id\":\"mw2tk84esln2gr\",\"name\":\"Mr. Macharia\",\"shortName\":\"Mr. Macharia\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 6: Mt. Kilimanjaro\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 6: Mt. Kilimanjaro\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84etpi8px\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(250,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84e54zocg','ae597cba8fea2a2f345f533552a5ff794b8c3c9ab5cc6e3dbc7ad261cefaa878','{\"id\":\"mw2tk84e54zocg\",\"name\":\"Tr. Dennis\",\"shortName\":\"Tr. Dennis\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 6: Mt. Kenya\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 6: Mt. Kenya\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84e0bmy51\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(251,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84excopxz','d79394c5de757e21e18de1041e6a7a9191eda261f971819121a5e75921ce4cc2','{\"id\":\"mw2tk84excopxz\",\"name\":\"Tr. Emmanuel\",\"shortName\":\"Tr. Emmanuel\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 6: Mt. Ruwenzori\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Primary\"],\"classes\":[\"Grade 6: Mt. Ruwenzori\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84eqdweo9\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(252,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84e8p0kez','71394d6496793225ede4bdf1f845cf77e48efc9068065bba30c6343d019e9653','{\"id\":\"mw2tk84e8p0kez\",\"name\":\"Tr. Priscilla\",\"shortName\":\"Tr. Priscilla\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 7: Wangari Maathai\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Junior Secondary\"],\"classes\":[\"Grade 7: Wangari Maathai\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84ebxbxqo\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(253,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84exdf7ug','0ff20ceaefbd9cbcfba96cfc66a414ffa30963cca358744db4a81cc31e52e2e8','{\"id\":\"mw2tk84exdf7ug\",\"name\":\"Mr. Kisaka\",\"shortName\":\"Mr. Kisaka\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 7: Mwai Kibaki\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Junior Secondary\"],\"classes\":[\"Grade 7: Mwai Kibaki\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84ej63rr4\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(254,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84e3jskbt','f7e3f5277e127bd84d4cc73202c85b77f88992d9cba2fb83c58b38c03ed4d100','{\"id\":\"mw2tk84e3jskbt\",\"name\":\"Tr. Lewis\",\"shortName\":\"Tr. Lewis\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 8: Wangari Maathai\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Junior Secondary\"],\"classes\":[\"Grade 8: Wangari Maathai\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84ehvim70\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(255,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84eegpmcl','f3e00bc7188f77c365f35bc06130429dcec0cd536c2e0bb4ca2fb1486c06626a','{\"id\":\"mw2tk84eegpmcl\",\"name\":\"Tr. Gladys W\",\"shortName\":\"Tr. Gladys W\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 8: Mwai Kibaki\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Junior Secondary\"],\"classes\":[\"Grade 8: Mwai Kibaki\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84eu86nus\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(256,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84ecfc561','428a9135bfd394d4e77299efbdcf393630388ef6b0aa0bca6e825a93e3a1648a','{\"id\":\"mw2tk84ecfc561\",\"name\":\"Tr. Korir\",\"shortName\":\"Tr. Korir\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 9: Wangari Maathai\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Junior Secondary\"],\"classes\":[\"Grade 9: Wangari Maathai\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84eokjre2\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(257,'st-teresa-backup-2026-11-12.json','ttTeachers','mw2tk84evros9r','2fe1f5b22c0c4fe491ade66849a46e99281f40c92abd95a9c409c7c347707416','{\"id\":\"mw2tk84evros9r\",\"name\":\"Mrs. Mwangi\",\"shortName\":\"Mrs. Mwangi\",\"count\":0,\"timeOff\":[],\"classTeacherOf\":\"Grade 9: Mwai Kibaki\",\"approvalStatus\":\"approved\",\"maxWindows\":4,\"daysTaught\":5,\"exhaustionLimit\":24,\"minPerDay\":1,\"maxPerDay\":6,\"maxQuestionMarking\":60,\"maxFreePerDay\":3,\"noThreeFree\":true,\"subjects\":[\"Junior Secondary\"],\"classes\":[\"Grade 9: Mwai Kibaki\"],\"availability\":[],\"workingHours\":\"07:30–15:30\",\"staffId\":\"mw2tk84etraavt\",\"createdAt\":\"2026-11-05\"}','staged','2026-11-13 10:53:55',NULL),
(258,'st-teresa-backup-2026-11-12.json','students','mw4imn86ijwr30','e60fe54a926079e2f947b4c3fbcf2c7338e3411e9956f7be7348dc148662c7f9','{\"id\":\"mw4imn86ijwr30\",\"firstName\":\"Nicholas\",\"lastName\":\"Ngatia\",\"fullName\":\"Nicholas Ngatia\",\"email\":\"\",\"grade\":\"Grade 4: Mt. Kilimanjaro\",\"className\":\"Grade 4: Mt. Kilimanjaro\",\"admissionNo\":\"1111\",\"admissionDate\":\"2026-11-05\",\"academicYear\":\"2026\",\"academicYearId\":\"mw2tk849i1pspg\",\"term\":\"1\",\"gender\":\"Male\",\"dob\":\"\",\"previousSchool\":\"\",\"status\":\"active\",\"category\":\"Boarder\",\"remarks\":\"\",\"photo\":\"\",\"photoKey\":\"\",\"photoUpdatedAt\":0,\"parentName\":\"Wachira\",\"parentRelationship\":\"Father\",\"parentPhone\":\"070\",\"parentAltPhone\":\"\",\"parentEmail\":\"\",\"guardian2Name\":\"Wachira\",\"guardian2Phone\":\"070\",\"address\":\"\",\"emergencyContact\":\"\",\"medicalInfo\":\"\",\"feeBalance\":0,\"createdAt\":\"2026-11-06T05:09:59.190Z\",\"updatedAt\":\"2026-11-06T05:09:59.190Z\",\"feeLedgerV\":1}','staged','2026-11-13 10:53:55',NULL),
(259,'st-teresa-backup-2026-11-12.json','students','mw4it0qblwy2r7','c4e2b8fcb8e1c90941ab56f4ec7715921692c2f7d5a81c714508901cd56583d6','{\"id\":\"mw4it0qblwy2r7\",\"firstName\":\"Nicholas\",\"lastName\":\"Ngatia\",\"fullName\":\"Nicholas Ngatia\",\"email\":\"\",\"grade\":\"Grade 4: Mt. Kenya\",\"className\":\"Grade 4: Mt. Kenya\",\"admissionNo\":\"1112\",\"admissionDate\":\"2026-11-06\",\"academicYear\":\"2026\",\"academicYearId\":\"mw2tk849i1pspg\",\"term\":\"1\",\"gender\":\"Male\",\"dob\":\"\",\"previousSchool\":\"\",\"status\":\"active\",\"category\":\"Boarder\",\"remarks\":\"\",\"photo\":\"\",\"photoKey\":\"\",\"photoUpdatedAt\":0,\"parentName\":\"\",\"parentRelationship\":\"\",\"parentPhone\":\"\",\"parentAltPhone\":\"\",\"parentEmail\":\"\",\"guardian2Name\":\"\",\"guardian2Phone\":\"\",\"address\":\"\",\"emergencyContact\":\"\",\"medicalInfo\":\"\",\"feeBalance\":0,\"createdAt\":\"2026-11-06T05:14:56.628Z\",\"updatedAt\":\"2026-11-06T05:14:56.628Z\",\"feeLedgerV\":1}','staged','2026-11-13 10:53:55',NULL),
(260,'st-teresa-backup-2026-11-12.json','subCounters','subCounters-0','1b28caa0f759687d0dc48ab9299e5fba917b38fbed7c9a694568c96a3342c93d','{\"2026\":1}','staged','2026-11-13 10:53:55',NULL);
/*!40000 ALTER TABLE `import_staging` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leadership`
--

DROP TABLE IF EXISTS `leadership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `leadership` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(64) NOT NULL,
  `name` varchar(190) NOT NULL DEFAULT '',
  `position` varchar(190) NOT NULL DEFAULT '',
  `photo` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(190) NOT NULL DEFAULT '',
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_leadership_legacy` (`legacy_id`),
  KEY `idx_leadership_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leadership`
--

LOCK TABLES `leadership` WRITE;
/*!40000 ALTER TABLE `leadership` DISABLE KEYS */;
INSERT INTO `leadership` VALUES
(1,'mwdl424ojh9way','John','director1','assets/img_20261113_105359_b748f69becac5c11_leadership-mwdl424ojh9way-photo.jpg','','{\"id\":\"mwdl424ojh9way\",\"position\":\"director1\",\"name\":\"John\",\"title\":\"School Director\",\"bio\":\"A dedicated and visionary leader committed to providing quality education, promoting academic excellence, nurturing talents, and ensuring a safe, supportive, and inspiring learning environment for all students.\",\"status\":\"active\",\"published\":true,\"photo\":\"assets/img_20261113_105359_b748f69becac5c11_leadership-mwdl424ojh9way-photo.jpg\",\"createdAt\":\"2026-11-12\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `leadership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_attempts`
--

DROP TABLE IF EXISTS `login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_attempts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `success` tinyint(1) NOT NULL DEFAULT 0,
  `attempted_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_login_attempts_user_time` (`username`,`attempted_at`),
  KEY `idx_login_attempts_ip_time` (`ip`,`attempted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_attempts`
--

LOCK TABLES `login_attempts` WRITE;
/*!40000 ALTER TABLE `login_attempts` DISABLE KEYS */;
INSERT INTO `login_attempts` VALUES
(90,'admin','::1',1,'2026-11-13 10:40:44'),
(91,'admin','127.0.0.1',1,'2026-11-13 10:55:04');
/*!40000 ALTER TABLE `login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `media` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `mime` varchar(100) NOT NULL,
  `size` bigint(20) unsigned NOT NULL DEFAULT 0,
  `kind` varchar(32) NOT NULL DEFAULT 'image',
  `legacy_key` varchar(120) DEFAULT NULL,
  `uploaded_by` bigint(20) unsigned DEFAULT NULL,
  `is_demo` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_media_path` (`path`),
  KEY `idx_media_legacy` (`legacy_key`),
  KEY `idx_media_uploader` (`uploaded_by`),
  CONSTRAINT `fk_media_user` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES
(13,'img_20261113_105359_b748f69becac5c11_leadership-mwdl424ojh9way-photo.jpg','assets/img_20261113_105359_b748f69becac5c11_leadership-mwdl424ojh9way-photo.jpg','image/jpeg',38407,'image','leadership:mwdl424ojh9way:photo',NULL,0,'2026-11-13 10:53:59');
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `token_hash` char(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_password_resets_token` (`token_hash`),
  KEY `idx_password_resets_user` (`user_id`),
  CONSTRAINT `fk_password_resets_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(50) NOT NULL,
  `applied_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES
('0001_core','2026-11-13 09:01:52'),
('stage4a-domains','2026-11-13 09:01:53'),
('stage4b-domains','2026-11-13 09:46:29');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` char(64) NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `csrf_token` char(64) NOT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `last_seen_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sessions_user` (`user_id`),
  KEY `idx_sessions_expiry` (`expires_at`),
  CONSTRAINT `fk_sessions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES
('46d7589cb072521c53c0f26d3a69777d261dcb77495af9640010856198252ea6',1,'66d16abc6da4d0617f561ea6acd037cc29d6532df15de53aa18b35f61772da38','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','2026-11-13 12:40:44','2026-11-13 10:40:44','2026-11-13 10:40:44'),
('e3089aa29e88f05038be008b9afc90ac753500a671b145eb984bd2dbd199a24c',1,'a15fa4ed14e71a54945dda994fb58ffe1bdcd462686d3b92a3b6f8805e09a612','127.0.0.1','curl/8.0.1','2026-11-13 12:55:04','2026-11-13 10:55:04','2026-11-13 10:55:04');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slider_slides`
--

DROP TABLE IF EXISTS `slider_slides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `slider_slides` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(64) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` text DEFAULT NULL,
  `image_url` varchar(500) NOT NULL DEFAULT '',
  `image_key` varchar(120) NOT NULL DEFAULT '',
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_slides_legacy` (`legacy_id`),
  KEY `idx_slides_sort` (`sort_order`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slider_slides`
--

LOCK TABLES `slider_slides` WRITE;
/*!40000 ALTER TABLE `slider_slides` DISABLE KEYS */;
INSERT INTO `slider_slides` VALUES
(1,'mw2tmc1096kzt7','The heading displayed on the slider','Supporting text displayed below the heading.','','mw2tmc1096kzt7',0,'{\"id\":\"mw2tmc1096kzt7\",\"title\":\"The heading displayed on the slider\",\"description\":\"Supporting text displayed below the heading.\",\"imageUrl\":\"\",\"imageKey\":\"mw2tmc1096kzt7\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'mwdlb7qum1ldnz','Welcome to Our School','Providing quality education, nurturing talents, building character, and empowering learners to achieve their dreams in a safe, supportive, and inspiring learning environment.','','mwdlb7qum1ldnz',0,'{\"id\":\"mwdlb7qum1ldnz\",\"title\":\"Welcome to Our School\",\"description\":\"Providing quality education, nurturing talents, building character, and empowering learners to achieve their dreams in a safe, supportive, and inspiring learning environment.\",\"imageUrl\":\"\",\"imageKey\":\"mwdlb7qum1ldnz\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `slider_slides` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(64) NOT NULL,
  `staff_no` varchar(64) NOT NULL DEFAULT '',
  `first_name` varchar(120) NOT NULL DEFAULT '',
  `last_name` varchar(120) NOT NULL DEFAULT '',
  `full_name` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(190) NOT NULL DEFAULT '',
  `phone` varchar(64) NOT NULL DEFAULT '',
  `subject` varchar(120) NOT NULL DEFAULT '',
  `role` varchar(120) NOT NULL DEFAULT '',
  `qualification` varchar(190) NOT NULL DEFAULT '',
  `status` varchar(32) NOT NULL DEFAULT 'active',
  `photo` varchar(255) NOT NULL DEFAULT '',
  `bio` text DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_staff_legacy` (`legacy_id`),
  KEY `idx_staff_status` (`status`),
  KEY `idx_staff_subject` (`subject`),
  KEY `idx_staff_user` (`user_id`),
  CONSTRAINT `fk_staff_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES
(1,'mw2tk846eqcaxr','STA-T001','Margaret','OBrien','Margaret OBrien','mobrien@stteresa.edu','(555) 100-2000','Mathematics','Teacher','M.Ed.','active','','M.Ed. with 28 years in Catholic education.',NULL,'{\"id\":\"mw2tk846eqcaxr\",\"firstName\":\"Margaret\",\"lastName\":\"OBrien\",\"email\":\"mobrien@stteresa.edu\",\"subject\":\"Mathematics\",\"role\":\"Teacher\",\"phone\":\"(555) 100-2000\",\"qualification\":\"M.Ed.\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"M.Ed. with 28 years in Catholic education.\",\"staffNo\":\"STA-T001\",\"accountId\":\"mw2tk8451y9bia\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'mw2tk846iiet7j','STA-T002','David','Chen','David Chen','dchen@stteresa.edu','(555) 100-2001','Science','Teacher','M.S. Engineering','active','','M.S. in Engineering, inspiring innovators and problem-solvers.',NULL,'{\"id\":\"mw2tk846iiet7j\",\"firstName\":\"David\",\"lastName\":\"Chen\",\"email\":\"dchen@stteresa.edu\",\"subject\":\"Science\",\"role\":\"Teacher\",\"phone\":\"(555) 100-2001\",\"qualification\":\"M.S. Engineering\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"M.S. in Engineering, inspiring innovators and problem-solvers.\",\"staffNo\":\"STA-T002\",\"accountId\":\"mw2tk84grlyvn3\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(3,'mw2tk846l93sww','STA-T003','Sarah','Williams','Sarah Williams','swilliams@stteresa.edu','(555) 100-2002','English','Teacher','M.A. Literature','active','','M.A. Literature, sparking a love of reading and writing.',NULL,'{\"id\":\"mw2tk846l93sww\",\"firstName\":\"Sarah\",\"lastName\":\"Williams\",\"email\":\"swilliams@stteresa.edu\",\"subject\":\"English\",\"role\":\"Teacher\",\"phone\":\"(555) 100-2002\",\"qualification\":\"M.A. Literature\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"M.A. Literature, sparking a love of reading and writing.\",\"staffNo\":\"STA-T003\",\"accountId\":\"mw2tk84gb2a1jg\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(4,'mw2tk846j28dxa','STA-T004','Catherine Marie','Sr.','Catherine Marie Sr.','cmarie@stteresa.edu','(555) 100-2003','Religion','Campus Ministry','Sister of St. Joseph','active','','Sister of St. Joseph, guiding spiritual growth and service learning.',NULL,'{\"id\":\"mw2tk846j28dxa\",\"firstName\":\"Catherine Marie\",\"lastName\":\"Sr.\",\"email\":\"cmarie@stteresa.edu\",\"subject\":\"Religion\",\"role\":\"Campus Ministry\",\"phone\":\"(555) 100-2003\",\"qualification\":\"Sister of St. Joseph\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"Sister of St. Joseph, guiding spiritual growth and service learning.\",\"staffNo\":\"STA-T004\",\"accountId\":\"mw2tk845mk9wnr\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(5,'mw2tk846947ktq','STA-T005','James','Whitfield','James Whitfield','jwhitfield@stteresa.edu','(555) 100-2004','Physical Education','Athletic Director','B.S. Kinesiology','active','','Former college athlete building character through sports.',NULL,'{\"id\":\"mw2tk846947ktq\",\"firstName\":\"James\",\"lastName\":\"Whitfield\",\"email\":\"jwhitfield@stteresa.edu\",\"subject\":\"Physical Education\",\"role\":\"Athletic Director\",\"phone\":\"(555) 100-2004\",\"qualification\":\"B.S. Kinesiology\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"Former college athlete building character through sports.\",\"staffNo\":\"STA-T005\",\"accountId\":\"mw2tk84g57j9ep\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(6,'mw2tk8460ek0bb','STA-T006','Thomas','Brennan','Thomas Brennan','tbrennan@stteresa.edu','(555) 100-2005','Religion','Chaplain','M.Div.','active','','Pastor and spiritual father guiding our community in faith.',NULL,'{\"id\":\"mw2tk8460ek0bb\",\"firstName\":\"Thomas\",\"lastName\":\"Brennan\",\"email\":\"tbrennan@stteresa.edu\",\"subject\":\"Religion\",\"role\":\"Chaplain\",\"phone\":\"(555) 100-2005\",\"qualification\":\"M.Div.\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"Pastor and spiritual father guiding our community in faith.\",\"staffNo\":\"STA-T006\",\"accountId\":\"mw2tk84gfxxmj7\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(7,'mw2tk846d2tbvt','STA-T007','Anthony','Rossi','Anthony Rossi','arossi@stteresa.edu','(555) 100-2006','Mathematics','Vice Principal, Academics','M.A. Curriculum & Instruction','active','','Championing rigorous and innovative learning.',NULL,'{\"id\":\"mw2tk846d2tbvt\",\"firstName\":\"Anthony\",\"lastName\":\"Rossi\",\"email\":\"arossi@stteresa.edu\",\"subject\":\"Mathematics\",\"role\":\"Vice Principal, Academics\",\"phone\":\"(555) 100-2006\",\"qualification\":\"M.A. Curriculum & Instruction\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"Championing rigorous and innovative learning.\",\"staffNo\":\"STA-T007\",\"accountId\":\"mw2tk845vyp15w\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(8,'mw2tk846ewe2md','STA-T008','Linda','Vasquez','Linda Vasquez','lvasquez@stteresa.edu','(555) 100-2007','Administration','Director of Admissions','M.B.A.','active','','Welcoming families through the admissions journey.',NULL,'{\"id\":\"mw2tk846ewe2md\",\"firstName\":\"Linda\",\"lastName\":\"Vasquez\",\"email\":\"lvasquez@stteresa.edu\",\"subject\":\"Administration\",\"role\":\"Director of Admissions\",\"phone\":\"(555) 100-2007\",\"qualification\":\"M.B.A.\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"Welcoming families through the admissions journey.\",\"staffNo\":\"STA-T008\",\"accountId\":\"mw2tk845ub1opf\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(9,'mw2tk84bm26v5h','KGT-001','Emmah','Wanjiru Ndonga','Emmah Wanjiru Ndonga','emmah.ndonga@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84bm26v5h\",\"firstName\":\"Emmah\",\"lastName\":\"Wanjiru Ndonga\",\"email\":\"emmah.ndonga@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-001\",\"accountId\":\"mw2tk84gprtc17\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(10,'mw2tk84b3clybf','KGT-002','Irene','Wambui Gachichio','Irene Wambui Gachichio','irene.gachichio@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84b3clybf\",\"firstName\":\"Irene\",\"lastName\":\"Wambui Gachichio\",\"email\":\"irene.gachichio@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-002\",\"accountId\":\"mw2tk84g9c216p\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(11,'mw2tk84b80ybup','KGT-003','Grace','Wambui Gichuhi','Grace Wambui Gichuhi','grace.gichuhi@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84b80ybup\",\"firstName\":\"Grace\",\"lastName\":\"Wambui Gichuhi\",\"email\":\"grace.gichuhi@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-003\",\"accountId\":\"mw2tk84hisgx7h\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(12,'mw2tk84bco4sq9','KGT-004','Pamela','Muyoka Masinde','Pamela Muyoka Masinde','pamela.masinde@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84bco4sq9\",\"firstName\":\"Pamela\",\"lastName\":\"Muyoka Masinde\",\"email\":\"pamela.masinde@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-004\",\"accountId\":\"mw2tk84hgafly2\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(13,'mw2tk84b45mfgm','KGT-005','Emmah','Nyawira Maina','Emmah Nyawira Maina','emmah.maina@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84b45mfgm\",\"firstName\":\"Emmah\",\"lastName\":\"Nyawira Maina\",\"email\":\"emmah.maina@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-005\",\"accountId\":\"mw2tk84hxsek2o\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(14,'mw2tk84b927otd','KGT-006','Purity','Muthoni Kabiru','Purity Muthoni Kabiru','purity.kabiru@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84b927otd\",\"firstName\":\"Purity\",\"lastName\":\"Muthoni Kabiru\",\"email\":\"purity.kabiru@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-006\",\"accountId\":\"mw2tk84hs8vhd3\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(15,'mw2tk84b9geev4','KGT-007','Jacinta','Wanjiku Ngunyi','Jacinta Wanjiku Ngunyi','jacinta.ngunyi@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84b9geev4\",\"firstName\":\"Jacinta\",\"lastName\":\"Wanjiku Ngunyi\",\"email\":\"jacinta.ngunyi@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-007\",\"accountId\":\"mw2tk84hqlrs2t\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(16,'mw2tk84boh40el','KGT-008','Lucy','Wanjiru Miano','Lucy Wanjiru Miano','lucy.miano@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84boh40el\",\"firstName\":\"Lucy\",\"lastName\":\"Wanjiru Miano\",\"email\":\"lucy.miano@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-008\",\"accountId\":\"mw2tk84hsx11sb\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(17,'mw2tk84byldhf7','KGT-009','Veronicah','Wangari Ndiritu','Veronicah Wangari Ndiritu','veronicah.ndiritu@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84byldhf7\",\"firstName\":\"Veronicah\",\"lastName\":\"Wangari Ndiritu\",\"email\":\"veronicah.ndiritu@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-009\",\"accountId\":\"mw2tk84h7m88bz\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(18,'mw2tk84cx9lzyb','KGT-010','Isabel','Mumbi Macharia','Isabel Mumbi Macharia','isabel.macharia@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84cx9lzyb\",\"firstName\":\"Isabel\",\"lastName\":\"Mumbi Macharia\",\"email\":\"isabel.macharia@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-010\",\"accountId\":\"mw2tk84hn5lkxs\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(19,'mw2tk84ceudo5o','KGT-011','Tabitha','Wamuyu Kariuki','Tabitha Wamuyu Kariuki','tabitha.kariuki@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84ceudo5o\",\"firstName\":\"Tabitha\",\"lastName\":\"Wamuyu Kariuki\",\"email\":\"tabitha.kariuki@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-011\",\"accountId\":\"mw2tk84hskt9xs\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(20,'mw2tk84cghtb8n','KGT-012','Joyce','Wairimu Nderitu','Joyce Wairimu Nderitu','joyce.nderitu@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84cghtb8n\",\"firstName\":\"Joyce\",\"lastName\":\"Wairimu Nderitu\",\"email\":\"joyce.nderitu@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-012\",\"accountId\":\"mw2tk84hdmitvb\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(21,'mw2tk84cmkg6s0','KGT-013','Grace','Wanjiku Gitau','Grace Wanjiku Gitau','grace.gitau@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84cmkg6s0\",\"firstName\":\"Grace\",\"lastName\":\"Wanjiku Gitau\",\"email\":\"grace.gitau@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-013\",\"accountId\":\"mw2tk84h4cz7hv\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(22,'mw2tk84cjifuyk','KGT-014','Laurisia','Njeri Gacheru','Laurisia Njeri Gacheru','laurisia.gacheru@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84cjifuyk\",\"firstName\":\"Laurisia\",\"lastName\":\"Njeri Gacheru\",\"email\":\"laurisia.gacheru@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-014\",\"accountId\":\"mw2tk84hh0jo3w\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(23,'mw2tk84crgenbq','KGT-015','Emma','Muthoni Muriuki','Emma Muthoni Muriuki','emma.muriuki@stteresaacademy.edu','','Kindergarten','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84crgenbq\",\"firstName\":\"Emma\",\"lastName\":\"Muthoni Muriuki\",\"email\":\"emma.muriuki@stteresaacademy.edu\",\"subject\":\"Kindergarten\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"KGT-015\",\"accountId\":\"mw2tk84haf7iz0\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(24,'mw2tk84d9nugqg','CT-001','Tr. Eva','','Tr. Eva','tr.eva@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84d9nugqg\",\"firstName\":\"Tr. Eva\",\"lastName\":\"\",\"email\":\"tr.eva@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-001\",\"accountId\":\"mw2tk84hqfhc84\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(25,'mw2tk84d56h6q3','CT-002','Tr. Margaret','','Tr. Margaret','tr.margaret@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84d56h6q3\",\"firstName\":\"Tr. Margaret\",\"lastName\":\"\",\"email\":\"tr.margaret@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-002\",\"accountId\":\"mw2tk84hjfapot\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(26,'mw2tk84d4yb5q4','CT-003','Tr. Carol','','Tr. Carol','tr.carol@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84d4yb5q4\",\"firstName\":\"Tr. Carol\",\"lastName\":\"\",\"email\":\"tr.carol@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-003\",\"accountId\":\"mw2tk84hre1hc6\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(27,'mw2tk84d2k99ur','CT-004','Tr. Jacinta','','Tr. Jacinta','tr.jacinta@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84d2k99ur\",\"firstName\":\"Tr. Jacinta\",\"lastName\":\"\",\"email\":\"tr.jacinta@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-004\",\"accountId\":\"mw2tk84hr2yr54\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(28,'mw2tk84dosz801','CT-005','Tr. Gladwel','','Tr. Gladwel','tr.gladwel@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84dosz801\",\"firstName\":\"Tr. Gladwel\",\"lastName\":\"\",\"email\":\"tr.gladwel@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-005\",\"accountId\":\"mw2tk84ixpbfo2\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(29,'mw2tk84dxo7xgh','CT-006','Tr. Alice','','Tr. Alice','tr.alice@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84dxo7xgh\",\"firstName\":\"Tr. Alice\",\"lastName\":\"\",\"email\":\"tr.alice@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-006\",\"accountId\":\"mw2tk84i9qq561\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(30,'mw2tk84dbdle7k','CT-007','Tr. Doris','','Tr. Doris','tr.doris@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84dbdle7k\",\"firstName\":\"Tr. Doris\",\"lastName\":\"\",\"email\":\"tr.doris@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-007\",\"accountId\":\"mw2tk84innixo9\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(31,'mw2tk84dl9r7wl','CT-008','Tr. Eliza','','Tr. Eliza','tr.eliza@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84dl9r7wl\",\"firstName\":\"Tr. Eliza\",\"lastName\":\"\",\"email\":\"tr.eliza@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-008\",\"accountId\":\"mw2tk84itjtngc\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(32,'mw2tk84dwhrwrx','CT-009','Tr. Mary','','Tr. Mary','tr.mary@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84dwhrwrx\",\"firstName\":\"Tr. Mary\",\"lastName\":\"\",\"email\":\"tr.mary@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-009\",\"accountId\":\"mw2tk84i1mchey\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(33,'mw2tk84dkdo1w0','CT-010','Tr. Elvis','','Tr. Elvis','tr.elvis@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84dkdo1w0\",\"firstName\":\"Tr. Elvis\",\"lastName\":\"\",\"email\":\"tr.elvis@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-010\",\"accountId\":\"mw2tk84idz80lb\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(34,'mw2tk84ddkcbb7','CT-011','Tr. James','','Tr. James','tr.james@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84ddkcbb7\",\"firstName\":\"Tr. James\",\"lastName\":\"\",\"email\":\"tr.james@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-011\",\"accountId\":\"mw2tk84igd74nn\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(35,'mw2tk84d3l5jvg','CT-012','Tr. Peris','','Tr. Peris','tr.peris@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84d3l5jvg\",\"firstName\":\"Tr. Peris\",\"lastName\":\"\",\"email\":\"tr.peris@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-012\",\"accountId\":\"mw2tk84ilr2ikd\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(36,'mw2tk84do4zo99','CT-013','Mr. Maina','','Mr. Maina','mr.maina@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84do4zo99\",\"firstName\":\"Mr. Maina\",\"lastName\":\"\",\"email\":\"mr.maina@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-013\",\"accountId\":\"mw2tk84i7a3pek\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(37,'mw2tk84diabatp','CT-014','Tr. Fidelis','','Tr. Fidelis','tr.fidelis@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84diabatp\",\"firstName\":\"Tr. Fidelis\",\"lastName\":\"\",\"email\":\"tr.fidelis@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-014\",\"accountId\":\"mw2tk84iz5osoq\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(38,'mw2tk84ecfc12k','CT-015','Tr. Doreen','','Tr. Doreen','tr.doreen@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84ecfc12k\",\"firstName\":\"Tr. Doreen\",\"lastName\":\"\",\"email\":\"tr.doreen@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-015\",\"accountId\":\"mw2tk84jeyea1m\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(39,'mw2tk84etpi8px','CT-016','Mr. Macharia','','Mr. Macharia','mr.macharia@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84etpi8px\",\"firstName\":\"Mr. Macharia\",\"lastName\":\"\",\"email\":\"mr.macharia@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-016\",\"accountId\":\"mw2tk84jrkghi6\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(40,'mw2tk84e0bmy51','CT-017','Tr. Dennis','','Tr. Dennis','tr.dennis@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84e0bmy51\",\"firstName\":\"Tr. Dennis\",\"lastName\":\"\",\"email\":\"tr.dennis@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-017\",\"accountId\":\"mw2tk84jltkfuu\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(41,'mw2tk84eqdweo9','CT-018','Tr. Emmanuel','','Tr. Emmanuel','tr.emmanuel@stteresaacademy.edu','','Primary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84eqdweo9\",\"firstName\":\"Tr. Emmanuel\",\"lastName\":\"\",\"email\":\"tr.emmanuel@stteresaacademy.edu\",\"subject\":\"Primary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-018\",\"accountId\":\"mw2tk84jucn4ud\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(42,'mw2tk84ebxbxqo','CT-019','Tr. Priscilla','','Tr. Priscilla','tr.priscilla@stteresaacademy.edu','','Junior Secondary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84ebxbxqo\",\"firstName\":\"Tr. Priscilla\",\"lastName\":\"\",\"email\":\"tr.priscilla@stteresaacademy.edu\",\"subject\":\"Junior Secondary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-019\",\"accountId\":\"mw2tk84j2r5v6v\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(43,'mw2tk84ej63rr4','CT-020','Mr. Kisaka','','Mr. Kisaka','mr.kisaka@stteresaacademy.edu','','Junior Secondary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84ej63rr4\",\"firstName\":\"Mr. Kisaka\",\"lastName\":\"\",\"email\":\"mr.kisaka@stteresaacademy.edu\",\"subject\":\"Junior Secondary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-020\",\"accountId\":\"mw2tk84jpufbnq\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(44,'mw2tk84ehvim70','CT-021','Tr. Lewis','','Tr. Lewis','tr.lewis@stteresaacademy.edu','','Junior Secondary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84ehvim70\",\"firstName\":\"Tr. Lewis\",\"lastName\":\"\",\"email\":\"tr.lewis@stteresaacademy.edu\",\"subject\":\"Junior Secondary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-021\",\"accountId\":\"mw2tk84jv3wv0j\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(45,'mw2tk84eu86nus','CT-022','Tr. Gladys W','','Tr. Gladys W','tr.gladys.w@stteresaacademy.edu','','Junior Secondary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84eu86nus\",\"firstName\":\"Tr. Gladys W\",\"lastName\":\"\",\"email\":\"tr.gladys.w@stteresaacademy.edu\",\"subject\":\"Junior Secondary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-022\",\"accountId\":\"mw2tk84jx4z5ks\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(46,'mw2tk84eokjre2','CT-023','Tr. Korir','','Tr. Korir','tr.korir@stteresaacademy.edu','','Junior Secondary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84eokjre2\",\"firstName\":\"Tr. Korir\",\"lastName\":\"\",\"email\":\"tr.korir@stteresaacademy.edu\",\"subject\":\"Junior Secondary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-023\",\"accountId\":\"mw2tk84jl5ofpc\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(47,'mw2tk84etraavt','CT-024','Mrs. Mwangi','','Mrs. Mwangi','mrs.mwangi@stteresaacademy.edu','','Junior Secondary','Teacher','','active','',NULL,NULL,'{\"id\":\"mw2tk84etraavt\",\"firstName\":\"Mrs. Mwangi\",\"lastName\":\"\",\"email\":\"mrs.mwangi@stteresaacademy.edu\",\"subject\":\"Junior Secondary\",\"role\":\"Teacher\",\"phone\":\"\",\"qualification\":\"\",\"status\":\"active\",\"photo\":\"\",\"bio\":\"\",\"staffNo\":\"CT-024\",\"accountId\":\"mw2tk84kin60kx\"}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(64) NOT NULL,
  `admission_no` varchar(64) NOT NULL DEFAULT '',
  `first_name` varchar(120) NOT NULL DEFAULT '',
  `last_name` varchar(120) NOT NULL DEFAULT '',
  `full_name` varchar(255) NOT NULL DEFAULT '',
  `grade` varchar(64) NOT NULL DEFAULT '',
  `class_name` varchar(64) NOT NULL DEFAULT '',
  `gender` varchar(32) NOT NULL DEFAULT '',
  `email` varchar(190) NOT NULL DEFAULT '',
  `phone` varchar(64) NOT NULL DEFAULT '',
  `status` varchar(32) NOT NULL DEFAULT 'active',
  `admission_date` date DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `fee_balance` decimal(12,2) NOT NULL DEFAULT 0.00,
  `photo` varchar(255) NOT NULL DEFAULT '',
  `photo_key` varchar(120) NOT NULL DEFAULT '',
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `record` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`record`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_students_legacy` (`legacy_id`),
  KEY `idx_students_class` (`class_name`),
  KEY `idx_students_status` (`status`),
  KEY `idx_students_admission` (`admission_no`),
  KEY `idx_students_user` (`user_id`),
  CONSTRAINT `fk_students_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES
(1,'mw4imn86ijwr30','1111','Nicholas','Ngatia','Nicholas Ngatia','Grade 4: Mt. Kilimanjaro','Grade 4: Mt. Kilimanjaro','Male','','','active','2026-11-05',NULL,0.00,'','',NULL,'{\"id\":\"mw4imn86ijwr30\",\"firstName\":\"Nicholas\",\"lastName\":\"Ngatia\",\"fullName\":\"Nicholas Ngatia\",\"email\":\"\",\"grade\":\"Grade 4: Mt. Kilimanjaro\",\"className\":\"Grade 4: Mt. Kilimanjaro\",\"admissionNo\":\"1111\",\"admissionDate\":\"2026-11-05\",\"academicYear\":\"2026\",\"academicYearId\":\"mw2tk849i1pspg\",\"term\":\"1\",\"gender\":\"Male\",\"dob\":\"\",\"previousSchool\":\"\",\"status\":\"active\",\"category\":\"Boarder\",\"remarks\":\"\",\"photo\":\"\",\"photoKey\":\"\",\"photoUpdatedAt\":0,\"parentName\":\"Wachira\",\"parentRelationship\":\"Father\",\"parentPhone\":\"070\",\"parentAltPhone\":\"\",\"parentEmail\":\"\",\"guardian2Name\":\"Wachira\",\"guardian2Phone\":\"070\",\"address\":\"\",\"emergencyContact\":\"\",\"medicalInfo\":\"\",\"feeBalance\":0,\"createdAt\":\"2026-11-06T05:09:59.190Z\",\"updatedAt\":\"2026-11-06T05:09:59.190Z\",\"feeLedgerV\":1}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL),
(2,'mw4it0qblwy2r7','1112','Nicholas','Ngatia','Nicholas Ngatia','Grade 4: Mt. Kenya','Grade 4: Mt. Kenya','Male','','','active','2026-11-06',NULL,0.00,'','',NULL,'{\"id\":\"mw4it0qblwy2r7\",\"firstName\":\"Nicholas\",\"lastName\":\"Ngatia\",\"fullName\":\"Nicholas Ngatia\",\"email\":\"\",\"grade\":\"Grade 4: Mt. Kenya\",\"className\":\"Grade 4: Mt. Kenya\",\"admissionNo\":\"1112\",\"admissionDate\":\"2026-11-06\",\"academicYear\":\"2026\",\"academicYearId\":\"mw2tk849i1pspg\",\"term\":\"1\",\"gender\":\"Male\",\"dob\":\"\",\"previousSchool\":\"\",\"status\":\"active\",\"category\":\"Boarder\",\"remarks\":\"\",\"photo\":\"\",\"photoKey\":\"\",\"photoUpdatedAt\":0,\"parentName\":\"\",\"parentRelationship\":\"\",\"parentPhone\":\"\",\"parentAltPhone\":\"\",\"parentEmail\":\"\",\"guardian2Name\":\"\",\"guardian2Phone\":\"\",\"address\":\"\",\"emergencyContact\":\"\",\"medicalInfo\":\"\",\"feeBalance\":0,\"createdAt\":\"2026-11-06T05:14:56.628Z\",\"updatedAt\":\"2026-11-06T05:14:56.628Z\",\"feeLedgerV\":1}','2026-11-13 10:53:59','2026-11-13 10:53:59',NULL);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `legacy_id` varchar(64) DEFAULT NULL,
  `username` varchar(64) NOT NULL,
  `email` varchar(190) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `legacy_password_hash` varchar(255) DEFAULT NULL,
  `role` varchar(32) NOT NULL DEFAULT 'student',
  `status` varchar(16) NOT NULL DEFAULT 'active',
  `name` varchar(190) NOT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `subject` varchar(120) DEFAULT NULL,
  `grade` varchar(80) DEFAULT NULL,
  `class_name` varchar(120) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `must_change_password` tinyint(1) NOT NULL DEFAULT 0,
  `temp_password_expires_at` datetime DEFAULT NULL,
  `recovery_question` varchar(255) DEFAULT NULL,
  `recovery_answer_hash` varchar(255) DEFAULT NULL,
  `legacy_recovery_answer_hash` varchar(255) DEFAULT NULL,
  `failed_login_count` int(10) unsigned NOT NULL DEFAULT 0,
  `locked_until` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `password_changed_at` datetime DEFAULT NULL,
  `is_demo` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_username` (`username`),
  UNIQUE KEY `uq_users_email` (`email`),
  UNIQUE KEY `uq_users_legacy` (`legacy_id`),
  KEY `idx_users_role` (`role`),
  KEY `idx_users_status` (`status`),
  KEY `idx_users_is_demo` (`is_demo`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'seed-admin','admin','admin@stteresaacademy.edu','$2y$12$NmPOxK.SYSENVg4srYwiROwnaEBZex9A2hQ28YvS8yuNA1CX0s/yu',NULL,'admin','active','System Administrator',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'2026-11-13 10:55:04',NULL,1,'2026-11-13 07:42:49','2026-11-13 10:55:04'),
(2,'seed-headteacher','headteacher','cmarie@stteresaacademy.edu','$2y$12$nkeJulZYaf6TiTxpuEcWFeS8HlmxjM7vFB5uzQWFgKcJrNahpVApS',NULL,'headteacher','active','Sr. Catherine Marie',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'2026-11-13 09:53:57',NULL,1,'2026-11-13 07:42:50','2026-11-13 09:53:57'),
(3,'seed-chiefexaminer','chiefexaminer','arossi@stteresaacademy.edu','$2y$12$WOIZavLAsoBx6/l6BmI9k.BL9xkvC2VLzePs3H0pbdQR6p/jEUJUu',NULL,'chiefexaminer','active','Mr. Anthony Rossi',NULL,'Mathematics',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'2026-11-13 09:53:58',NULL,1,'2026-11-13 07:42:50','2026-11-13 09:53:58'),
(4,'seed-secretary','secretary','lvasquez@stteresaacademy.edu','$2y$12$M.5At.6fL2kZPTexhuFuj.cu9O6BWt38SZFRzmmGbeb2il5HVoqIG',NULL,'secretary','active','Ms. Linda Vasquez',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'2026-11-13 09:53:58',NULL,1,'2026-11-13 07:42:51','2026-11-13 09:53:58'),
(5,'seed-teacher','teacher','mobrien@stteresaacademy.edu','$2y$12$q0vkSF84FLxWxbua5rFIA.RIz0Xz/RYsZPTruEtELq.4ql4gJCqcS',NULL,'teacher','active','Mrs. Margaret OBrien',NULL,'Mathematics',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'2026-11-13 09:54:04',NULL,1,'2026-11-13 07:42:51','2026-11-13 09:54:04'),
(6,'seed-student','student','jsmith@student.stteresa.edu','$2y$12$burpAAAXd/i9pSJE2dOFsulTwyojjb8A/IoRn9VPua3R3QeHVB73u',NULL,'student','active','John Smith',NULL,NULL,NULL,'Grade 9',NULL,0,NULL,NULL,NULL,NULL,1,NULL,'2026-11-13 09:54:00',NULL,1,'2026-11-13 07:42:51','2026-11-13 09:54:01'),
(7,'seed-storekeeper','storekeeper','pkamau@stteresaacademy.edu','$2y$12$3jfPfSA.do./T0G1/8DQqustnw8A/.BmqS0ru/QC6rKZjK0Nsqi46',NULL,'storekeeper','active','Mr. Peter Kamau',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'2026-11-13 09:53:59',NULL,1,'2026-11-13 07:42:51','2026-11-13 09:53:59'),
(8,'seed-kitchenmanager','kitchenmanager','gnjeri@stteresaacademy.edu','$2y$12$eK4vd3.Al/qpdskXXVrauuutlbyuCME.WF7cHZbcKLpPl4FdTQUH6',NULL,'kitchenmanager','active','Ms. Grace Njeri',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,'2026-11-13 09:54:00',NULL,1,'2026-11-13 07:42:52','2026-11-13 09:54:00'),
(9,'seed-uniformjunior','uniformjunior','rachieng@stteresaacademy.edu','$2y$12$EVbpMuciA3NRnpFHyp4EpOhpf0d58JJyaf27ku7gX0RDuGkboS9cO',NULL,'storekeeper','active','Ms. Ruth Achieng',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,1,'2026-11-13 07:42:52','2026-11-13 07:42:52'),
(10,'seed-uniformacademy','uniformacademy','sotieno@stteresaacademy.edu','$2y$12$4ZuN5Hw/SZQf/uMfcrP.nOAUt0X9nVpiLrLmqNWsVwCuA2OUCn6BS',NULL,'storekeeper','active','Mr. Samuel Otieno',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,1,'2026-11-13 07:42:52','2026-11-13 07:42:52'),
(17,'mw2tk84grlyvn3','David','dchen@stteresa.edu',NULL,'pbkdf2$50000$b0FM8OwkJeg9t3BPuHgprg==$lAV6iYx7aeSO4hYa723IrBgoRnCkMnwwXaRt9HT61CQ=','teacher','active','David Chen','(555) 100-2001','Science',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(18,'mw2tk84gb2a1jg','swilliams','swilliams@stteresa.edu',NULL,'pbkdf2$50000$YnNoAT86mCwzyvgDcBYNOg==$Jvk6u8EqbxzBFvFaO+MIzhEpUDSp4K1mfKp3yNF5ra0=','teacher','active','Sarah Williams','(555) 100-2002','English',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(19,'mw2tk84g57j9ep','jwhitfield','jwhitfield@stteresa.edu',NULL,'pbkdf2$50000$wrjJrHuv7u2kqYTC/x5oXA==$S9iB+UdARs+cFMeX2CUQHpHIEoixSS4zpXh47NDNfg0=','teacher','active','James Whitfield','(555) 100-2004','Physical Education',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(20,'mw2tk84gfxxmj7','tbrennan','tbrennan@stteresa.edu',NULL,'pbkdf2$50000$Tmj0/xM+J3HFUK/LQSkcSQ==$bRYaoEPC4DC0blCuMDXecLidPQKJ2X3C5isW3euKONA=','teacher','active','Thomas Brennan','(555) 100-2005','Religion',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(21,'mw2tk84gprtc17','emmah.ndonga','emmah.ndonga@stteresaacademy.edu',NULL,'pbkdf2$50000$cZkUf1Ta12gM2lI0enK6+w==$tMe0BhpAaUYl2O9TrPgmt/ueoZhAz86tny4If4QMKUA=','teacher','active','Emmah Wanjiru Ndonga',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(22,'mw2tk84g9c216p','irene.gachichio','irene.gachichio@stteresaacademy.edu',NULL,'pbkdf2$50000$4qJPCLSWpQCwkJ8o0LlErg==$1DXXwGzPAEVORSNXIAQTQ+BIGPekOPXHvSWuaquj/NE=','teacher','active','Irene Wambui Gachichio',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(23,'mw2tk84hisgx7h','grace.gichuhi','grace.gichuhi@stteresaacademy.edu',NULL,'pbkdf2$50000$w2nvRKqrmpNJNWjjlicvig==$/6bpWgRjFxMCSvb2ygz74oq+si/VHQrVqhNUace1ICY=','teacher','active','Grace Wambui Gichuhi',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(24,'mw2tk84hgafly2','pamela.masinde','pamela.masinde@stteresaacademy.edu',NULL,'pbkdf2$50000$MDCi/j9qcM816/7HWLwUdg==$ThwGpYHUG4J56GH9/OWqCLbeO0TFR/h1oGUZgRJE0mk=','teacher','active','Pamela Muyoka Masinde',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(25,'mw2tk84hxsek2o','emmah.maina','emmah.maina@stteresaacademy.edu',NULL,'pbkdf2$50000$GY65SqTh+wlFeEiGQ2RVoQ==$PlwQZ+G8iASmRAkhfpr4tBhWQoaGBHkJjIp53pLZxhs=','teacher','active','Emmah Nyawira Maina',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(26,'mw2tk84hs8vhd3','purity.kabiru','purity.kabiru@stteresaacademy.edu',NULL,'pbkdf2$50000$QUT6UM5ThbANMPNU4rcSDg==$AtUKisHe5N3p+dzOEwAOL9cnH+i5p9AWnLYMZ2D5778=','teacher','active','Purity Muthoni Kabiru',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(27,'mw2tk84hqlrs2t','jacinta.ngunyi','jacinta.ngunyi@stteresaacademy.edu',NULL,'pbkdf2$50000$9f5fJa3irtU6I5emIQdyFQ==$Q8ikv5rkJCbEjGphcBXAlNjxwHVysLC4P2hM/cXlsf0=','teacher','active','Jacinta Wanjiku Ngunyi',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(28,'mw2tk84hsx11sb','lucy.miano','lucy.miano@stteresaacademy.edu',NULL,'pbkdf2$50000$1uxY1++0BPA4iFgvSohDFQ==$yxHW2IhHo/yhhc80Dm/jgHpm7q/A/FYdV4f2UH6LbjQ=','teacher','active','Lucy Wanjiru Miano',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(29,'mw2tk84h7m88bz','veronicah.ndiritu','veronicah.ndiritu@stteresaacademy.edu',NULL,'pbkdf2$50000$89Sp7rrUF4yPGfS9w7JHEw==$T9TAmt6Qrz0rA0pgrKXUEbZ3O683s0EKBdR/e5jHYks=','teacher','active','Veronicah Wangari Ndiritu',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(30,'mw2tk84hn5lkxs','isabel.macharia','isabel.macharia@stteresaacademy.edu',NULL,'pbkdf2$50000$BRKCnec07mLpMKl1iapWzw==$qAq1pfViyMsXm7qc4L76X2yCkiBWRorLphkowe1jEN0=','teacher','active','Isabel Mumbi Macharia',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(31,'mw2tk84hskt9xs','tabitha.kariuki','tabitha.kariuki@stteresaacademy.edu',NULL,'pbkdf2$50000$rdwok6kd8zOBsMxW1VRx5A==$gQRJ7blO1MG9P4o299XTGAtJjywn6ZkmEOYmMWMHvVU=','teacher','active','Tabitha Wamuyu Kariuki',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(32,'mw2tk84hdmitvb','joyce.nderitu','joyce.nderitu@stteresaacademy.edu',NULL,'pbkdf2$50000$FQC8YiIMwOxKgosWA95tcQ==$FHaFvruE8qTPcJ1oTrnVDkucjvtDd2H0iCrRFNxuQ/s=','teacher','active','Joyce Wairimu Nderitu',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(33,'mw2tk84h4cz7hv','grace.gitau','grace.gitau@stteresaacademy.edu',NULL,'pbkdf2$50000$3MZcvbRzRdx5N9I9Pp933A==$1jOK3/lipugH1Xpeky1SPXyiP63AVvIwHqH/gJmB8zw=','teacher','active','Grace Wanjiku Gitau',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(34,'mw2tk84hh0jo3w','laurisia.gacheru','laurisia.gacheru@stteresaacademy.edu',NULL,'pbkdf2$50000$MiA4QsCoiJZZJg5dlCH+3A==$m7mzcfHmEBG7l/ybEGaL84DblTzwnpaDJky1WILDolY=','teacher','active','Laurisia Njeri Gacheru',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(35,'mw2tk84haf7iz0','emma.muriuki','emma.muriuki@stteresaacademy.edu',NULL,'pbkdf2$50000$fk0A3jQwYMDv/eXB7aPSEw==$X7QVfWYibmrEnOBmlPziRirmeGS3lawg7Fq9oyHoOSM=','teacher','active','Emma Muthoni Muriuki',NULL,'Kindergarten',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(36,'mw2tk84hqfhc84','tr.eva','tr.eva@stteresaacademy.edu',NULL,'pbkdf2$50000$k5oUfIHZfIOMggQarsuRjA==$EY0cIdZqgGy1gpfJhFL+FiNEuJwuarvOUtuCQYVCJAI=','teacher','active','Tr. Eva',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(37,'mw2tk84hjfapot','tr.margaret','tr.margaret@stteresaacademy.edu',NULL,'pbkdf2$50000$irrKehz5nlrZOb6bk6uwfQ==$mMOLRmU2qRtdZ5u4Rz29FA8sWVOaKbtXlHe4+hRmE1k=','teacher','active','Tr. Margaret',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(38,'mw2tk84hre1hc6','tr.carol','tr.carol@stteresaacademy.edu',NULL,'pbkdf2$50000$xRevRfJLKsQfUA8GBQJMoQ==$uQ06GEMCf0+Yx47BqUqtJ9ow96LvPZXlbSxNhVprKdQ=','teacher','active','Tr. Carol',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(39,'mw2tk84hr2yr54','tr.jacinta','tr.jacinta@stteresaacademy.edu',NULL,'pbkdf2$50000$ARG4LadeKks0fN2sv282ag==$FJ3IYYE0LQ/BNkqKAbI/5DjYR3zugcH5k80MrWpspb8=','teacher','active','Tr. Jacinta',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(40,'mw2tk84ixpbfo2','tr.gladwel','tr.gladwel@stteresaacademy.edu',NULL,'pbkdf2$50000$dF5S1yf7BVHi43F9m35m5A==$LwP++jiVWXomlb73BUR8ZBObCymI7y3rftbMaQO3kbI=','teacher','active','Tr. Gladwel',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(41,'mw2tk84i9qq561','tr.alice','tr.alice@stteresaacademy.edu',NULL,'pbkdf2$50000$Ur2AT8qov/fZLLjVeYCT9w==$NaJDNNoYIPHT7+4gRitAt9sRPSMYfqYHHjOAWadHviY=','teacher','active','Tr. Alice',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(42,'mw2tk84innixo9','tr.doris','tr.doris@stteresaacademy.edu',NULL,'pbkdf2$50000$Na2kOoGJFD8w3NcIdrMZxQ==$Op4BJghxoqxmwodvEYiTHEDHYO7VS+4Cvh/M6Pli+wI=','teacher','active','Tr. Doris',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(43,'mw2tk84itjtngc','tr.eliza','tr.eliza@stteresaacademy.edu',NULL,'pbkdf2$50000$KRYSiGzUKXlz+awzN5uO6g==$pIYBxnsQ8eIBK3LGtCc5cYv7jMgVs9SqKBrtl3LE1mo=','teacher','active','Tr. Eliza',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(44,'mw2tk84i1mchey','tr.mary','tr.mary@stteresaacademy.edu',NULL,'pbkdf2$50000$GolMmss46HxFweUjuDR1bg==$fqfEmQvgqNdxRD9nVYRuS5BCC5/LojREgLsEgo+zNkg=','teacher','active','Tr. Mary',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(45,'mw2tk84idz80lb','tr.elvis','tr.elvis@stteresaacademy.edu',NULL,'pbkdf2$50000$vgP+oyqpWVDa2RyhdcyR8w==$ftpFhlEMpOLwtrUMu8cUl5LJ+B/HUUisG3fk9QSaThU=','teacher','active','Tr. Elvis',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(46,'mw2tk84igd74nn','tr.james','tr.james@stteresaacademy.edu',NULL,'pbkdf2$50000$cMUIo3vjaRddKoSbaJ5ERg==$yR+5aNTpO24Y/apL58K/ulAOICMZkgY2ePeELt8X4ts=','teacher','active','Tr. James',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(47,'mw2tk84ilr2ikd','tr.peris','tr.peris@stteresaacademy.edu',NULL,'pbkdf2$50000$D+B9wFrTMHDp/E1WlHsw1w==$YvXzEFQSM2n1Pi1pmyyh5tryk/9GvO1hlMJ8tmNWh2s=','teacher','active','Tr. Peris',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(48,'mw2tk84i7a3pek','mr.maina','mr.maina@stteresaacademy.edu',NULL,'pbkdf2$50000$V5TK3TEQX59/GvSkafnqtA==$fVrkYz7Vd3G75MYi8OCYAC5Y+GQ6jvBK0fpZgzvBP1M=','teacher','active','Mr. Maina',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(49,'mw2tk84iz5osoq','tr.fidelis','tr.fidelis@stteresaacademy.edu',NULL,'pbkdf2$50000$gPbcW1cbyk+tmZ5e/xwuZg==$0PR4tq4y1KOHmLW4iIPQWNgJO0wRYKM5vaqRhbQKXW0=','teacher','active','Tr. Fidelis',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(50,'mw2tk84jeyea1m','tr.doreen','tr.doreen@stteresaacademy.edu',NULL,'pbkdf2$50000$Pqfcl5WuiixIwaycs1g1Tg==$cX4MkZ66ofp9yeCClGhFdgoql3KMLoqWsJg7zCCI4Eg=','teacher','active','Tr. Doreen',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(51,'mw2tk84jrkghi6','mr.macharia','mr.macharia@stteresaacademy.edu',NULL,'pbkdf2$50000$fXCJOrjNPChWmWC1KMEeIA==$Muhr5zAOkHg/8ox9pThQG0eADcwFL2exqcjc5q8QhN0=','teacher','active','Mr. Macharia',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(52,'mw2tk84jltkfuu','tr.dennis','tr.dennis@stteresaacademy.edu',NULL,'pbkdf2$50000$uYweuN0wVgK4uKZk0qkY/g==$p9fOMKRGT0vFINQ+mjpGJzKLFAyJwLTWR7ls5YLjN6Y=','teacher','active','Tr. Dennis',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(53,'mw2tk84jucn4ud','tr.emmanuel','tr.emmanuel@stteresaacademy.edu',NULL,'pbkdf2$50000$CU7M765RJv0EUmnpfUPbMg==$pZhn7aBTDIZPyBqeuif+nBPxeuAinYh8s3ZKUKwdvc8=','teacher','active','Tr. Emmanuel',NULL,'Primary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(54,'mw2tk84j2r5v6v','tr.priscilla','tr.priscilla@stteresaacademy.edu',NULL,'pbkdf2$50000$pPMv8cbuaDekI4TIjP3qqg==$X359tYTv85LSYclQEuWAmIoZQ61eDErWM4OwSyer6YE=','teacher','active','Tr. Priscilla',NULL,'Junior Secondary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(55,'mw2tk84jpufbnq','mr.kisaka','mr.kisaka@stteresaacademy.edu',NULL,'pbkdf2$50000$NxkxR8eEpYHEIJOL0tNgkg==$CnIGfAq1CjfJ8xlQFMX4TzpxKcfbU1u/aD2tTgYP0mM=','teacher','active','Mr. Kisaka',NULL,'Junior Secondary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(56,'mw2tk84jv3wv0j','tr.lewis','tr.lewis@stteresaacademy.edu',NULL,'pbkdf2$50000$WxIqj7HrKPkwemlgKEF9kQ==$73I6s/MYvlSrQyr40jOcAq6EocwJMV1sMKtq6L8ENtQ=','teacher','active','Tr. Lewis',NULL,'Junior Secondary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(57,'mw2tk84jx4z5ks','tr.gladys.w','tr.gladys.w@stteresaacademy.edu',NULL,'pbkdf2$50000$lfg0YFY9kKr8xYPtilduUA==$0wGEjNedyqtV5DlpKEHli3ut1REZygd/CPLfCo2a660=','teacher','active','Tr. Gladys W',NULL,'Junior Secondary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(58,'mw2tk84jl5ofpc','tr.korir','tr.korir@stteresaacademy.edu',NULL,'pbkdf2$50000$ywrPUNRvoYgGjkbJ07HsIQ==$AlstqGBTT6U2TFvjtMSjTAnuvx9YZzO28Ev8rseZ6SQ=','teacher','active','Tr. Korir',NULL,'Junior Secondary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(59,'mw2tk84kin60kx','mrs.mwangi','mrs.mwangi@stteresaacademy.edu',NULL,'pbkdf2$50000$TrmMhiTs0bYrxMAZzdHfxA==$08nLijdKK4Dqm658cpMAbEk22WsxhqmCeiJ0tD7ymzA=','teacher','active','Mrs. Mwangi',NULL,'Junior Secondary',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(60,'mw4imn86ijwr30','nngatiagrade4mtkilimanjaro',NULL,NULL,'pbkdf2$50000$p6dggenq4Nc7Q58dGW4fvA==$972Pkak4/aayi0w/TfHESo2aNxZe+mjCKiRknN5uRxY=','student','active','Nicholas Ngatia',NULL,NULL,'Grade 4: Mt. Kilimanjaro','Grade 4: Mt. Kilimanjaro',NULL,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55'),
(61,'mw4it0qblwy2r7','nngatiagrade4mtkenya',NULL,NULL,'pbkdf2$50000$xdShLX6ZHTgI6z+Uq3emIA==$TJST6qeklHM3tQuixapTBqZjGQS/nEPpPTLzdk9qLoQ=','student','active','Nicholas Ngatia',NULL,NULL,'Grade 4: Mt. Kenya','Grade 4: Mt. Kenya',NULL,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,'2026-11-13 10:53:55','2026-11-13 10:53:55');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'st_teresa_academy'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-13 11:45:52
