-- Adminer 5.3.0 MariaDB 10.11.13-MariaDB-ubu2204 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS `yrprey`;
CREATE DATABASE `yrprey` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `yrprey`;

DROP TABLE IF EXISTS `historico`;
CREATE TABLE `historico` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `username` text NOT NULL,
  `token` text NOT NULL,
  `valor` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

TRUNCATE `historico`;
INSERT INTO `historico` (`id`, `username`, `token`, `valor`) VALUES
(2,	'root',	'123',	'4.0'),
(3,	'root',	'123',	'4.0'),
(27,	'user',	'245',	'6.0'),
(28,	'root',	'123',	'4.0'),
(29,	'user',	'245',	'4.0'),
(30,	'teste',	'123',	'6.0'),
(31,	'teste',	'123',	'4.0'),
(32,	'teste',	'123',	'6.0'),
(33,	'',	'123',	'6.0'),
(34,	'',	'123',	'6.0'),
(35,	'',	'123',	'4.0'),
(36,	'',	'123',	'6.0'),
(37,	'',	'123',	'4.0'),
(38,	'',	'123',	'4.0'),
(39,	'',	'123',	'6.0'),
(40,	'',	'123',	'8.0'),
(41,	'',	'123',	'4.0'),
(42,	'',	'123',	'4.0');

DROP TABLE IF EXISTS `produtos`;
CREATE TABLE `produtos` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `title_image` text NOT NULL,
  `image` text NOT NULL,
  `color` text NOT NULL,
  `name` text NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

TRUNCATE `produtos`;
INSERT INTO `produtos` (`id`, `title_image`, `image`, `color`, `name`, `value`) VALUES
(2,	'YRPrey',	'sword-red',	'red',	'Sword',	'2.0'),
(3,	'YRPrey',	'map-red',	'red',	'Map',	'4.0'),
(4,	'YRPrey',	'book-red',	'red',	'Book',	'6.0'),
(5,	'YRPrey',	'potion-red',	'red',	'Potion',	'8.0'),
(6,	'YRPrey',	'axe-red',	'red',	'Axe',	'10.0'),
(7,	'YRPrey',	'arrow-red',	'red',	'Arrow',	'12.0'),
(8,	'YRPrey',	'axe-blue',	'blue',	'Axe',	'10.0'),
(9,	'YRPrey',	'map-blue',	'blue',	'Map',	'4.0'),
(10,	'YRPrey',	'book-blue',	'blue',	'Book',	'6.0'),
(11,	'YRPrey',	'sword-blue',	'blue',	'Sword',	'2.0'),
(12,	'YRPrey',	'potion-blue',	'blue',	'Potion',	'8.0'),
(13,	'YRPrey',	'shield-blue',	'blue',	'Shield',	'12.0'),
(14,	'YRPrey',	'map-cian',	'cian',	'Map',	'4.0'),
(15,	'YRPrey',	'book-cian',	'cian',	'Book',	'6.0'),
(16,	'YRPrey',	'sword-cian',	'cian',	'Sword',	'2.0'),
(17,	'YRPrey',	'axe-cian',	'cian',	'Axe',	'8.0'),
(18,	'YRPrey',	'potion-cian',	'cian',	'Potion',	'10.0'),
(19,	'YRPrey',	'shield-cian',	'cian',	'Shield',	'12.0'),
(20,	'YRPrey',	'map-white',	'white',	'Map',	'2.0'),
(21,	'YRPrey',	'book-white',	'white',	'Book',	'4.0'),
(22,	'YRPrey',	'sword-white',	'white',	'Sword',	'6.0'),
(23,	'YRPrey',	'helmet-white',	'white',	'Helmet',	'8.0'),
(24,	'YRPrey',	'potion-white',	'white',	'Potion',	'10.0'),
(25,	'YRPrey',	'shield-white',	'white',	'Shield',	'12.0'),
(26,	'YRPrey',	'axe-beige',	'beige',	'Axe',	'2.0'),
(27,	'YRPrey',	'map-beige',	'beige',	'Map',	'4.0'),
(28,	'YRPrey',	'book-beige',	'beige',	'Book',	'6.0'),
(29,	'YRPrey',	'sword-beige',	'beige',	'Sword',	'8.0'),
(30,	'YRPrey',	'potion-beige',	'beige',	'Potion',	'10.0'),
(31,	'YRPrey',	'shield-beige',	'beige',	'Shield',	'12.0');

DROP TABLE IF EXISTS `shop`;
CREATE TABLE `shop` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `titulo` text NOT NULL,
  `img` text NOT NULL,
  `price` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

TRUNCATE `shop`;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `username` text NOT NULL,
  `password` text NOT NULL,
  `token` text NOT NULL,
  `saldo` text NOT NULL,
  `role` int(255) NOT NULL,
  `criptomoeda` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

TRUNCATE `users`;
INSERT INTO `users` (`id`, `username`, `password`, `token`, `saldo`, `role`, `criptomoeda`) VALUES
(1,	'root',	'1234',	'123',	'9788',	1,	'14.538,73'),
(2,	'admin',	'admin',	'245',	'10000',	0,	'20.200');

-- 2025-06-12 16:27:24 UTC