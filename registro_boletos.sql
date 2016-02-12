-- phpMyAdmin SQL Dump
-- version 4.2.11
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-02-2016 a las 17:13:21
-- Versión del servidor: 5.6.21-log
-- Versión de PHP: 5.6.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `registro_boletos`
--
CREATE DATABASE IF NOT EXISTS `registro_boletos` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `registro_boletos`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `ejemplo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ejemplo`(IN id INT)
BEGIN
SELECT CONCAT(currency,' ',fee) as prueba 
FROM boletos WHERE id=id;
END$$

DROP PROCEDURE IF EXISTS `setTickets`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `setTickets`(IN id_ticket INT)
BEGIN 
DECLARE find_passenger varchar(255);
DECLARE find_creationDate date;
SELECT passenger, creationDate INTO find_passenger, find_creationDate 
FROM registro_boletos.boletos WHERE id=id_ticket;
select find_passenger, find_creationDate;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `boletos`
--

DROP TABLE IF EXISTS `boletos`;
CREATE TABLE IF NOT EXISTS `boletos` (
`id` int(255) NOT NULL,
  `id_xml` int(255) DEFAULT NULL,
  `localizador` varchar(16) DEFAULT NULL,
  `currency` varchar(8) DEFAULT NULL,
  `fee_percentage` decimal(15,2) DEFAULT NULL,
  `fee` decimal(15,2) DEFAULT NULL,
  `total_amount` decimal(15,2) DEFAULT NULL,
  `montobase` decimal(15,2) DEFAULT NULL,
  `coupon_status` varchar(255) DEFAULT NULL,
  `passenger` varchar(255) DEFAULT NULL,
  `sistemagds` varchar(255) DEFAULT NULL,
  `emittedDate` date DEFAULT NULL,
  `creationDate` date DEFAULT NULL,
  `departureDate` date DEFAULT NULL,
  `arrivalDate` date DEFAULT NULL,
  `ticketNumber` varchar(255) DEFAULT NULL,
  `airlineID` varchar(16) DEFAULT NULL,
  `YN_tax` decimal(15,2) DEFAULT NULL,
  `status_emission` varchar(32) DEFAULT NULL,
  `ID_asesora` varchar(255) DEFAULT NULL,
  `nombre_asesora` varchar(255) DEFAULT NULL,
  `ID_satelite` varchar(255) DEFAULT NULL,
  `nombre_satelite` varchar(255) DEFAULT NULL,
  `tipo_vuelo` varchar(255) DEFAULT NULL,
  `method_payment` varchar(255) DEFAULT NULL,
  `itinerary` varchar(255) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=838 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `xml`
--

DROP TABLE IF EXISTS `xml`;
CREATE TABLE IF NOT EXISTS `xml` (
`id` int(255) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `fecha` varchar(50) NOT NULL,
  `status` varchar(20) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=563 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `zip`
--

DROP TABLE IF EXISTS `zip`;
CREATE TABLE IF NOT EXISTS `zip` (
`id` int(255) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `fecha` varchar(50) NOT NULL,
  `status` varchar(20) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=564 DEFAULT CHARSET=latin1;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `boletos`
--
ALTER TABLE `boletos`
 ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `xml`
--
ALTER TABLE `xml`
 ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `zip`
--
ALTER TABLE `zip`
 ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `boletos`
--
ALTER TABLE `boletos`
MODIFY `id` int(255) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=838;
--
-- AUTO_INCREMENT de la tabla `xml`
--
ALTER TABLE `xml`
MODIFY `id` int(255) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=563;
--
-- AUTO_INCREMENT de la tabla `zip`
--
ALTER TABLE `zip`
MODIFY `id` int(255) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=564;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
