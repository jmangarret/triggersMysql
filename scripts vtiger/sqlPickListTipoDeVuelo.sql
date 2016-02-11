	CREATE TABLE `vtiger_tipodevuelo` (
`tipodevueloid` int( 11 ) NOT NULL AUTO_INCREMENT ,
`tipodevuelo` varchar( 200 ) NOT NULL ,
`presence` int( 1 ) NOT NULL DEFAULT '1',
`picklist_valueid` int( 11 ) NOT NULL DEFAULT '0',
`sortorderid` int( 1 ) DEFAULT NULL ,
PRIMARY KEY ( `tipodevueloid` )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

INSERT INTO `vtiger_tipodevuelo` VALUES (1,'Nacional', 1,0,1);
INSERT INTO `vtiger_tipodevuelo` VALUES (2,'Internacional', 1,0,2);
UPDATE `vtiger_field` SET `displaytype` = '1' WHERE `vtiger_field`.`fieldname` ='totalboletos';
