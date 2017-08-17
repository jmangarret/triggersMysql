/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50051
Source Host           : localhost:3306
Source Database       : crmtuagencia24

Target Server Type    : MYSQL
Target Server Version : 50051
File Encoding         : 65001

Date: 2017-07-27 09:20:33
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for vtiger_tarifas_historico
-- ----------------------------
DROP TABLE IF EXISTS `vtiger_tarifas_historico`;
CREATE TABLE `vtiger_tarifas_historico` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tarifasid` int(11) NOT NULL,
  `fecha` date default NULL,
  `valor` double(8,2) default NULL,
  PRIMARY KEY ( `id` ) 
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET FOREIGN_KEY_CHECKS=1;
