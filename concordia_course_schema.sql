-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.1.14-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             9.1.0.4867
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for x27xkp7knc6djk7e
CREATE DATABASE IF NOT EXISTS `x27xkp7knc6djk7e` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `x27xkp7knc6djk7e`;


-- Dumping structure for table concordiacourses.courses
CREATE TABLE IF NOT EXISTS `courses` (
  `uuid` varchar(50) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `code` varchar(8) DEFAULT NULL,
  `number` varchar(8) DEFAULT NULL,
  KEY `Index 1` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table concordiacourses.sections
CREATE TABLE IF NOT EXISTS `sections` (
  `uuid` varchar(50) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `days` varchar(50) DEFAULT NULL,
  `time_start` datetime DEFAULT NULL,
  `time_end` datetime DEFAULT NULL,
  `room` varchar(50) DEFAULT NULL,
  `section_type` varchar(50) DEFAULT NULL,
  `semester_id` varchar(50) DEFAULT NULL,
  `course_id` varchar(50) DEFAULT NULL,
  KEY `Index 1` (`uuid`),
  KEY `FK_sections_semesters` (`semester_id`),
  KEY `FK_sections_courses` (`course_id`),
  CONSTRAINT `FK_sections_courses` FOREIGN KEY (`course_id`) REFERENCES `courses` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_sections_semesters` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table concordiacourses.semesters
CREATE TABLE IF NOT EXISTS `semesters` (
  `uuid` varchar(50) NOT NULL,
  `semester` varchar(50) DEFAULT NULL,
  `year` smallint(6) DEFAULT NULL,
  KEY `Index 1` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
