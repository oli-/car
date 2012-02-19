-- Server version: 5.1.41
-- PHP Version: 5.3.2-1ubuntu4.11

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

-- --------------------------------------------------------

--
-- Table structure for table `cars`
--

CREATE TABLE IF NOT EXISTS `cars` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `make` varchar(32) NOT NULL,
  `model` varchar(64) NOT NULL,
  `hp` smallint(6) NOT NULL,
  `plate` varchar(12) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `fuels`
--

CREATE TABLE IF NOT EXISTS `fuels` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

INSERT INTO `fuels` (`id`, `name`) VALUES
(1, 'Super'),
(2, 'Super E10'),
(3, 'Super Plus');

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE IF NOT EXISTS `reports` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `car` int(10) unsigned NOT NULL,
  `fuel` tinyint(3) unsigned NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `distance` decimal(6,1) unsigned DEFAULT NULL COMMENT 'km',
  `amount` decimal(5,2) NOT NULL COMMENT 'litres',
  `unitprice` decimal(5,3) NOT NULL COMMENT 'EUR/litre',
  PRIMARY KEY (`id`),
  KEY `car` (`car`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=15 ;

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE IF NOT EXISTS `tickets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `car` int(10) unsigned NOT NULL,
  `received` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `amount` decimal(8,2) unsigned NOT NULL,
  `reason` tinytext NOT NULL,
  `location` tinytext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

