DROP TABLE IF EXISTS `vtiger_statusboleto`;
CREATE TABLE `vtiger_statusboleto` (
`statusboletoid` int( 11 ) NOT NULL AUTO_INCREMENT ,
`statusboleto` varchar( 200 ) NOT NULL ,
`presence` int( 1 ) NOT NULL DEFAULT '1',
`picklist_valueid` int( 11 ) NOT NULL DEFAULT '0',
`sortorderid` int( 1 ) DEFAULT NULL ,
PRIMARY KEY ( `statusboletoid` )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

INSERT INTO `vtiger_statusboleto` VALUES (1,'Emitido', 1,0,1);
INSERT INTO `vtiger_statusboleto` VALUES (2,'Reemitido', 1,0,1);
INSERT INTO `vtiger_statusboleto` VALUES (3,'Anulado', 1,0,2);

UPDATE vtiger_field SET uitype=16,`fieldname` = 'statusboleto' WHERE tablename='vtiger_boletos' AND columnname='status';
