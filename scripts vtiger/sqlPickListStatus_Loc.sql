DROP TABLE IF EXISTS `vtiger_statusloc`;
CREATE TABLE `vtiger_statusloc` (
`statuslocid` int( 11 ) NOT NULL AUTO_INCREMENT ,
`statusloc` varchar( 200 ) NOT NULL ,
`presence` int( 1 ) NOT NULL DEFAULT '1',
`picklist_valueid` int( 11 ) NOT NULL DEFAULT '0',
`sortorderid` int( 1 ) DEFAULT NULL ,
PRIMARY KEY ( `statuslocid` )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

INSERT INTO `vtiger_statusloc` VALUES (1,'Confirmado', 1,0,2);
INSERT INTO `vtiger_statusloc` VALUES (2,'Emitido', 1,0,2);
INSERT INTO `vtiger_statusloc` VALUES (3,'Anulado', 1,0,2);


UPDATE vtiger_field SET uitype=16, fieldname='statusloc' WHERE tablename='vtiger_localizadores' AND columnname='status';
