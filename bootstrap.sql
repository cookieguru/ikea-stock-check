CREATE DATABASE IF NOT EXISTS `ikea` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `ikea`;

CREATE TABLE IF NOT EXISTS `log` (
	`time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`event` enum('Start','Email','End') NOT NULL,
	`number` smallint(5) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `products` (
	`article_number` int(11) NOT NULL,
	`name` varchar(255) NOT NULL,
	`description` varchar(255) NOT NULL,
	`created_at` datetime NOT NULL,
	`modified_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`article_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` (`article_number`, `name`, `description`, `created_at`, `modified_at`) VALUES
	(10251045, 'HELMER', 'Drawer unit on casters, white', '2014-09-08 14:09:05', '2014-09-08 14:09:10');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;


CREATE TABLE IF NOT EXISTS `requests` (
	`request_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`store_id` int(10) unsigned NOT NULL,
	`article_number` int(10) unsigned NOT NULL,
	`email_address` varchar(255) NOT NULL,
	`active` enum('0','1') NOT NULL DEFAULT '0',
	`desired_level` smallint(5) unsigned NOT NULL,
	`user_tz` varchar(255) DEFAULT NULL,
	`created_at` datetime NOT NULL,
	`modified_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`request_id`),
	KEY `article` (`article_number`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` (`request_id`, `store_id`, `article_number`, `email_address`, `active`, `desired_level`, `user_tz`, `created_at`, `modified_at`) VALUES
	(1, 250, 10251045, 'em@il.com', '0', 2, 'America/Los_Angeles', '2014-09-08 14:53:00', '2014-09-08 23:13:18');
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;


CREATE TABLE IF NOT EXISTS `stock` (
	`stock_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`article_number` int(10) unsigned NOT NULL,
	`store_id` int(10) unsigned NOT NULL,
	`time` datetime NOT NULL,
	`stock` smallint(5) unsigned NOT NULL,
	PRIMARY KEY (`stock_id`),
	KEY `store` (`store_id`),
	KEY `article` (`article_number`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `stock` DISABLE KEYS */;
INSERT INTO `stock` (`stock_id`, `article_number`, `store_id`, `time`, `stock`) VALUES
	(1, 10251045, 250, '2014-09-08 16:09:00', 1);
/*!40000 ALTER TABLE `stock` ENABLE KEYS */;


CREATE TABLE IF NOT EXISTS `stores` (
	`store_id` int(10) unsigned NOT NULL,
	`city` varchar(50) NOT NULL,
	`state` char(2) NOT NULL,
	`tz_offset_from_est` tinyint(3) DEFAULT NULL,
	`open_mf` tinyint(3) unsigned DEFAULT NULL,
	`close_mf` tinyint(3) unsigned DEFAULT NULL,
	`open_sat` tinyint(3) unsigned DEFAULT NULL,
	`close_sat` tinyint(3) unsigned DEFAULT NULL,
	`open_sun` tinyint(3) unsigned DEFAULT NULL,
	`close_sun` tinyint(3) unsigned DEFAULT NULL,
	`notes` varchar(50) DEFAULT NULL,
	PRIMARY KEY (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `stores` DISABLE KEYS */;
INSERT INTO `stores` (`store_id`, `city`, `state`, `tz_offset_from_est`, `open_mf`, `close_mf`, `open_sat`, `close_sat`, `open_sun`, `close_sun`, `notes`) VALUES
	(26, 'Canton', 'MI', 0, 10, 21, 10, 21, 10, 21, NULL),
	(27, 'Round Rock', 'TX', -1, 10, 21, 10, 21, 10, 19, NULL),
	(28, 'Portland', 'OR', -3, 10, 21, 10, 21, 10, 21, NULL),
	(42, 'Tampa', 'FL', 0, 10, 21, 10, 21, 11, 19, NULL),
	(64, 'Centennial', 'CO', -2, 10, 21, 10, 21, 10, 21, NULL),
	(67, 'Charlotte', 'NC', 0, 10, 21, 10, 21, 11, 20, NULL),
	(103, 'Draper', 'UT', -2, 10, 21, 10, 21, 10, 19, NULL),
	(145, 'Orlando', 'FL', 0, 10, 21, 10, 21, 11, 19, NULL),
	(152, 'Baltimore', 'MD', 0, 10, 21, 10, 10, 10, 19, NULL),
	(153, 'Pittsburgh', 'PA', 0, 10, 21, 10, 21, 10, 19, NULL),
	(154, 'Elizabeth', 'NJ', 0, 10, 21, 10, 21, 10, 20, NULL),
	(156, 'Long Island', 'NY', 0, 10, 21, 10, 21, 10, 21, NULL),
	(157, 'West Sacramento', 'CA', -3, 10, 20, 10, 20, 10, 20, NULL),
	(158, 'Stoughton', 'MA', 0, 10, 21, 10, 22, 10, 21, 'Fri open until 22:00'),
	(160, 'Burbank', 'CA', -3, 10, 21, 10, 21, 10, 21, NULL),
	(162, 'Carson', 'CA', -3, 10, 21, 10, 21, 10, 21, NULL),
	(165, 'Emeryville', 'CA', -3, 10, 21, 10, 21, 10, 20, NULL),
	(166, 'San Diego', 'CA', -3, 10, 21, 10, 21, 10, 20, NULL),
	(167, 'Costa Mesa', 'CA', -3, 10, 21, 10, 21, 10, 20, NULL),
	(168, 'Woodbridge', 'VA', 0, 10, 21, 10, 21, 10, 20, NULL),
	(170, 'Bolingbrook', 'IL', -1, 10, 21, 10, 21, 10, 20, NULL),
	(175, 'West Chester', 'OH', 0, 10, 21, 10, 21, 10, 20, NULL),
	(183, 'Dallas', 'TX', -1, 10, 21, 10, 21, 10, 20, NULL),
	(207, 'Sunrise', 'FL', 0, 10, 21, 10, 21, 10, 21, NULL),
	(209, 'Tempe', 'AZ', -2, 10, 21, 10, 21, 10, 19, 'DST issues'),
	(210, 'Schaumburg', 'IL', -1, 10, 21, 10, 21, 10, 21, NULL),
	(211, 'Conshohocken', 'PA', 0, 10, 21, 10, 21, 10, 21, NULL),
	(212, 'Twin Cities', 'MN', -1, 10, 21, 10, 21, 10, 19, NULL),
	(213, 'New Haven', 'CT', 0, 10, 21, 10, 21, 10, 21, NULL),
	(215, 'South Philadelphia', 'PA', 0, 10, 21, 10, 21, 10, 20, NULL),
	(250, 'Seattle', 'WA', -3, 10, 21, 10, 21, 10, 20, NULL),
	(257, 'Atlanta', 'GA', 0, 10, 21, 10, 21, 10, 21, NULL),
	(327, 'Miami', 'FL', 0, 10, 21, 10, 21, 10, 20, NULL),
	(347, 'East Palo Alto', 'CA', -3, 10, 21, 10, 21, 10, 21, NULL),
	(374, 'Merriam', 'KS', -1, 10, 21, 10, 21, 10, 21, NULL),
	(379, 'Houston', 'TX', -1, 10, 21, 10, 21, 10, 18, NULL),
	(409, 'Paramus', 'NJ', 0, 10, 22, 10, 22, NULL, NULL, 'Closed on Sunday'),
	(411, 'College Park', 'MD', 0, 10, 21, 10, 21, 10, 20, NULL),
	(413, 'Covina', 'CA', -3, 10, 21, 10, 21, 10, 20, NULL),
	(921, 'Brooklyn', 'NY', 0, 10, 21, 10, 21, 10, 21, NULL);
/*!40000 ALTER TABLE `stores` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
