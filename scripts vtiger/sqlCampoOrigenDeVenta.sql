DROP TABLE IF EXISTS `vtiger_origendeventa`;
CREATE TABLE `vtiger_origendeventa` (
`origendeventaid` int( 11 ) NOT NULL AUTO_INCREMENT ,
`origendeventa` varchar( 200 ) NOT NULL ,
`presence` int( 1 ) NOT NULL DEFAULT '1',
`picklist_valueid` int( 11 ) NOT NULL DEFAULT '0',
`sortorderid` int( 1 ) DEFAULT NULL ,
PRIMARY KEY ( `origendeventaid` )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

INSERT INTO `vtiger_origendeventa` VALUES (1,'Presencial', 1,0,2);
INSERT INTO `vtiger_origendeventa` VALUES (2,'Llamada', 1,0,2);
INSERT INTO `vtiger_origendeventa` VALUES (3,'Pagina Web', 1,0,2);
INSERT INTO `vtiger_origendeventa` VALUES (4,'Correo Electrónico', 1,0,2);
INSERT INTO `vtiger_origendeventa` VALUES (5,'Redes Sociales', 1,0,2);
INSERT INTO `vtiger_origendeventa` VALUES (6,'Whatsapp', 1,0,2);
INSERT INTO `vtiger_origendeventa` VALUES (7,'Infoguia', 1,0,2);