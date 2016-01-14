-- MySQL dump 10.13  Distrib 5.5.46, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: lagotto
-- ------------------------------------------------------
-- Server version	5.5.46-0ubuntu0.14.04.2

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
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_id` int(11) DEFAULT NULL,
  `class_name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `trace` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `target_url` varchar(1000) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `details` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `unresolved` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remote_ip` varchar(255) DEFAULT NULL,
  `work_id` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT '3',
  `hostname` varchar(255) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_alerts_on_source_id_and_unresolved_and_updated_at` (`source_id`,`unresolved`,`updated_at`),
  KEY `index_alerts_on_unresolved_and_updated_at` (`unresolved`,`updated_at`),
  KEY `index_alerts_on_updated_at` (`updated_at`),
  KEY `index_alerts_on_created_at` (`created_at`),
  KEY `index_alerts_on_level_and_created_at` (`level`,`created_at`),
  KEY `index_alerts_on_source_id_and_created_at` (`source_id`,`created_at`),
  KEY `index_alerts_on_class_name` (`class_name`),
  KEY `index_alerts_on_work_id_and_created_at` (`work_id`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=79309 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `api_requests`
--

DROP TABLE IF EXISTS `api_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `format` varchar(255) DEFAULT NULL,
  `db_duration` float DEFAULT NULL,
  `view_duration` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `api_key` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `info` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `ids` text,
  `duration` float DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_api_requests_on_created_at` (`created_at`),
  KEY `index_api_requests_on_api_key` (`api_key`),
  KEY `index_api_requests_api_key_created_at` (`api_key`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=391 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `api_responses`
--

DROP TABLE IF EXISTS `api_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_responses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `work_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `retrieval_status_id` int(11) DEFAULT NULL,
  `total` int(11) NOT NULL DEFAULT '0',
  `previous_total` int(11) DEFAULT NULL,
  `duration` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `update_interval` int(11) DEFAULT NULL,
  `unresolved` tinyint(1) DEFAULT '1',
  `skipped` tinyint(1) DEFAULT '0',
  `html` int(11) NOT NULL DEFAULT '0',
  `pdf` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_api_responses_unresolved_id` (`unresolved`,`id`),
  KEY `index_api_responses_created_at` (`created_at`),
  KEY `index_api_responses_on_total` (`total`)
) ENGINE=InnoDB AUTO_INCREMENT=188814 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_exports`
--

DROP TABLE IF EXISTS `data_exports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_exports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `started_exporting_at` datetime DEFAULT NULL,
  `finished_exporting_at` datetime DEFAULT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_migrations`
--

DROP TABLE IF EXISTS `data_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `days`
--

DROP TABLE IF EXISTS `days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `days` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `work_id` int(11) NOT NULL,
  `source_id` int(11) NOT NULL,
  `retrieval_status_id` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `day` int(11) NOT NULL,
  `total` int(11) NOT NULL DEFAULT '0',
  `html` int(11) NOT NULL DEFAULT '0',
  `pdf` int(11) NOT NULL DEFAULT '0',
  `comments` int(11) NOT NULL DEFAULT '0',
  `likes` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `readers` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_days_on_work_id_and_source_id_and_year_and_month` (`work_id`,`source_id`,`year`,`month`),
  KEY `index_days_on_retrieval_status_id_and_year_and_month_and_day` (`retrieval_status_id`,`year`,`month`,`day`),
  KEY `days_source_id_fk` (`source_id`),
  CONSTRAINT `days_retrieval_status_id_fk` FOREIGN KEY (`retrieval_status_id`) REFERENCES `retrieval_statuses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `days_source_id_fk` FOREIGN KEY (`source_id`) REFERENCES `sources` (`id`) ON DELETE CASCADE,
  CONSTRAINT `days_work_id_fk` FOREIGN KEY (`work_id`) REFERENCES `works` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2295 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `file_write_logs`
--

DROP TABLE IF EXISTS `file_write_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_write_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filepath` varchar(255) DEFAULT NULL,
  `file_type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `filters`
--

DROP TABLE IF EXISTS `filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `name` varchar(191) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `active` tinyint(1) DEFAULT '1',
  `config` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `months`
--

DROP TABLE IF EXISTS `months`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `months` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `work_id` int(11) NOT NULL,
  `source_id` int(11) NOT NULL,
  `retrieval_status_id` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `total` int(11) NOT NULL DEFAULT '0',
  `html` int(11) NOT NULL DEFAULT '0',
  `pdf` int(11) NOT NULL DEFAULT '0',
  `comments` int(11) NOT NULL DEFAULT '0',
  `likes` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `readers` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_months_on_work_id_and_source_id_and_year_and_month` (`work_id`,`source_id`,`year`,`month`),
  KEY `index_months_on_source_id_and_year_and_month` (`source_id`,`year`,`month`),
  KEY `index_months_on_retrieval_status_id_and_year_and_month` (`retrieval_status_id`,`year`,`month`),
  CONSTRAINT `months_retrieval_status_id_fk` FOREIGN KEY (`retrieval_status_id`) REFERENCES `retrieval_statuses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `months_source_id_fk` FOREIGN KEY (`source_id`) REFERENCES `sources` (`id`) ON DELETE CASCADE,
  CONSTRAINT `months_work_id_fk` FOREIGN KEY (`work_id`) REFERENCES `works` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=121325 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publisher_options`
--

DROP TABLE IF EXISTS `publisher_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publisher_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisher_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `config` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_publisher_options_on_publisher_id_and_source_id` (`publisher_id`,`source_id`),
  KEY `publisher_options_source_id_fk` (`source_id`),
  CONSTRAINT `publisher_options_publisher_id_fk` FOREIGN KEY (`publisher_id`) REFERENCES `publishers` (`member_id`) ON DELETE CASCADE,
  CONSTRAINT `publisher_options_source_id_fk` FOREIGN KEY (`source_id`) REFERENCES `sources` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publishers`
--

DROP TABLE IF EXISTS `publishers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publishers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `prefixes` text,
  `other_names` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `cached_at` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `name` varchar(255) NOT NULL,
  `service` varchar(255) DEFAULT NULL,
  `symbol` varchar(255) DEFAULT NULL,
  `url` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_publishers_on_member_id` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `relation_types`
--

DROP TABLE IF EXISTS `relation_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `relation_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `inverse_title` varchar(255) DEFAULT NULL,
  `inverse_name` varchar(255) DEFAULT NULL,
  `level` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `relations`
--

DROP TABLE IF EXISTS `relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `work_id` int(11) NOT NULL,
  `related_work_id` int(11) NOT NULL,
  `source_id` int(11) DEFAULT NULL,
  `relation_type_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `level` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_relationships_on_work_id_related_work_id` (`work_id`,`related_work_id`),
  KEY `index_relations_on_level_work_related_work` (`level`,`work_id`,`related_work_id`),
  KEY `relations_related_work_id_fk` (`related_work_id`),
  KEY `relations_relation_type_id_fk` (`relation_type_id`),
  KEY `relations_source_id_fk` (`source_id`),
  CONSTRAINT `relations_related_work_id_fk` FOREIGN KEY (`related_work_id`) REFERENCES `works` (`id`) ON DELETE CASCADE,
  CONSTRAINT `relations_relation_type_id_fk` FOREIGN KEY (`relation_type_id`) REFERENCES `relation_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `relations_source_id_fk` FOREIGN KEY (`source_id`) REFERENCES `sources` (`id`) ON DELETE CASCADE,
  CONSTRAINT `relations_work_id_fk` FOREIGN KEY (`work_id`) REFERENCES `works` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4502 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `config` text,
  `private` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reports_users`
--

DROP TABLE IF EXISTS `reports_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports_users` (
  `report_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  KEY `index_reports_users_on_report_id_and_user_id` (`report_id`,`user_id`),
  KEY `index_reports_users_on_user_id` (`user_id`),
  CONSTRAINT `reports_users_report_id_fk` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reports_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `retrieval_statuses`
--

DROP TABLE IF EXISTS `retrieval_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `retrieval_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `work_id` int(11) NOT NULL,
  `source_id` int(11) NOT NULL,
  `queued_at` datetime DEFAULT NULL,
  `retrieved_at` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `total` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `scheduled_at` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `events_url` text,
  `extra` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `pdf` int(11) NOT NULL DEFAULT '0',
  `html` int(11) NOT NULL DEFAULT '0',
  `readers` int(11) NOT NULL DEFAULT '0',
  `comments` int(11) NOT NULL DEFAULT '0',
  `likes` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_retrieval_statuses_on_work_id_and_source_id` (`work_id`,`source_id`),
  KEY `index_retrieval_statuses_source_id_event_count_desc` (`source_id`,`total`),
  KEY `index_retrieval_statuses_source_id_article_id_event_count_desc` (`source_id`,`work_id`,`total`),
  KEY `index_retrieval_statuses_source_id_event_count_retr_at_desc` (`source_id`,`total`,`retrieved_at`),
  KEY `index_retrieval_statuses_on_source_id` (`source_id`),
  KEY `index_rs_on_article_id_soure_id_event_count` (`work_id`,`source_id`,`total`),
  KEY `index_rs_on_soure_id_queued_at_scheduled_at` (`source_id`,`queued_at`,`scheduled_at`),
  KEY `index_retrieval_statuses_on_work_id` (`work_id`),
  KEY `index_retrieval_statuses_on_work_id_and_total` (`work_id`,`total`),
  CONSTRAINT `retrieval_statuses_source_id_fk` FOREIGN KEY (`source_id`) REFERENCES `sources` (`id`) ON DELETE CASCADE,
  CONSTRAINT `retrieval_statuses_work_id_fk` FOREIGN KEY (`work_id`) REFERENCES `works` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2526875 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `message` text,
  `input` int(11) DEFAULT NULL,
  `output` int(11) DEFAULT NULL,
  `unresolved` tinyint(1) DEFAULT '1',
  `started_at` datetime DEFAULT NULL,
  `ended_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_reviews_on_name` (`name`),
  KEY `index_reviews_on_state_id` (`state_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(191) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sources`
--

DROP TABLE IF EXISTS `sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `run_at` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `config` text,
  `group_id` int(11) NOT NULL,
  `private` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `description` text,
  `state` int(11) DEFAULT '0',
  `queueable` tinyint(1) DEFAULT '1',
  `state_event` varchar(255) DEFAULT NULL,
  `cached_at` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `eventable` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_sources_on_name` (`name`),
  UNIQUE KEY `index_sources_on_type` (`type`),
  KEY `index_sources_on_state` (`state`),
  KEY `sources_group_id_fk` (`group_id`),
  CONSTRAINT `sources_group_id_fk` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `works_count` int(11) DEFAULT '0',
  `works_new_count` int(11) DEFAULT '0',
  `events_count` int(11) DEFAULT '0',
  `responses_count` int(11) DEFAULT '0',
  `requests_count` int(11) DEFAULT '0',
  `requests_average` int(11) DEFAULT '0',
  `alerts_count` int(11) DEFAULT '0',
  `sources_working_count` int(11) DEFAULT '0',
  `sources_waiting_count` int(11) DEFAULT '0',
  `sources_disabled_count` int(11) DEFAULT '0',
  `db_size` bigint(20) DEFAULT '0',
  `version` varchar(255) DEFAULT NULL,
  `current_version` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_status_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `password_salt` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `uid` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `authentication_token` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(255) DEFAULT 'user',
  `publisher_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_authentication_token` (`authentication_token`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_types`
--

DROP TABLE IF EXISTS `work_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `work_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `container` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `works`
--

DROP TABLE IF EXISTS `works`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `works` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `doi` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `published_on` date DEFAULT NULL,
  `pmid` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pmcid` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `canonical_url` text,
  `mendeley_uuid` varchar(255) DEFAULT NULL,
  `year` int(11) DEFAULT '1970',
  `month` int(11) DEFAULT NULL,
  `day` int(11) DEFAULT NULL,
  `publisher_id` int(11) DEFAULT NULL,
  `pid_type` varchar(255) NOT NULL DEFAULT 'url',
  `pid` text NOT NULL,
  `csl` text,
  `work_type_id` int(11) DEFAULT NULL,
  `tracked` tinyint(1) DEFAULT '0',
  `scp` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wos` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ark` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `arxiv` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registration_agency` varchar(255) DEFAULT NULL,
  `dataone` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_works_on_pid` (`pid`(191)) USING BTREE,
  UNIQUE KEY `index_works_on_doi` (`doi`),
  UNIQUE KEY `index_works_on_pmid` (`pmid`),
  UNIQUE KEY `index_works_on_dataone` (`dataone`),
  UNIQUE KEY `index_works_on_pmcid` (`pmcid`(100)),
  UNIQUE KEY `index_works_on_scp` (`scp`(100)),
  UNIQUE KEY `index_works_on_wos` (`wos`(100)),
  UNIQUE KEY `index_works_on_ark` (`ark`(100)),
  UNIQUE KEY `index_works_on_arxiv` (`arxiv`(100)),
  KEY `index_works_on_published_on` (`published_on`),
  KEY `index_works_on_publisher_id_and_published_on` (`publisher_id`,`published_on`),
  KEY `index_articles_doi_published_on_article_id` (`doi`,`published_on`,`id`),
  KEY `index_works_on_pmid_published_on_id` (`pmid`,`published_on`,`id`),
  KEY `index_works_on_url_published_on_id` (`canonical_url`(100),`published_on`,`id`),
  KEY `index_works_on_url` (`canonical_url`(100)),
  KEY `index_works_on_scp_published_on_id` (`scp`,`published_on`,`id`),
  KEY `index_works_on_wos_published_on_id` (`wos`,`published_on`,`id`),
  KEY `index_works_on_ark_published_on_id` (`ark`,`published_on`,`id`),
  KEY `index_works_on_arxiv_published_on_id` (`arxiv`,`published_on`,`id`),
  KEY `index_works_on_tracked_published_on` (`tracked`,`published_on`),
  KEY `index_works_on_registration_agency` (`registration_agency`(191)),
  KEY `index_works_on_created_at` (`created_at`),
  KEY `works_work_type_id_fk` (`work_type_id`),
  CONSTRAINT `works_work_type_id_fk` FOREIGN KEY (`work_type_id`) REFERENCES `work_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=277919 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;