DROP TABLE IF EXISTS `vtiger_statussoto`;
CREATE TABLE `vtiger_statussoto` (
`statussotoid` int( 11 ) NOT NULL AUTO_INCREMENT ,
`statussoto` varchar( 200 ) NOT NULL ,
`presence` int( 1 ) NOT NULL DEFAULT '1',
`picklist_valueid` int( 11 ) NOT NULL DEFAULT '0',
`sortorderid` int( 1 ) DEFAULT NULL ,
PRIMARY KEY ( `statussotoid` )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

INSERT INTO `vtiger_statussoto` VALUES (1,'Reservado', 1,0,2);
INSERT INTO `vtiger_statussoto` VALUES (2,'Confirmar Pago', 1,0,2);
INSERT INTO `vtiger_statussoto` VALUES (3,'Emitir Soto', 1,0,2);
INSERT INTO `vtiger_statussoto` VALUES (4,'Emitido', 1,0,2);


UPDATE `vtiger_field` SET `fieldlabel` = 'Nro. Pasaporte', `typeofdata` = 'V~M', `quickcreate` = '2'  WHERE `vtiger_field`.`columnname` ='cf_663';
UPDATE `vtiger_field` SET `displaytype` = '2' WHERE `vtiger_field`.`columnname` ='isSatelite';