CREATE TABLE `vtiger_tipodeformula` (
`tipodeformulaid` int( 11 ) NOT NULL AUTO_INCREMENT ,
`tipodeformula` varchar( 200 ) NOT NULL ,
`presence` int( 1 ) NOT NULL DEFAULT '1',
`picklist_valueid` int( 11 ) NOT NULL DEFAULT '0',
`sortorderid` int( 1 ) DEFAULT NULL ,
PRIMARY KEY ( `tipodeformulaid` )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

INSERT INTO `vtiger_tipodeformula` VALUES (1,'Porcentaje', 1,0,1);
INSERT INTO `vtiger_tipodeformula` VALUES (2,'Monto Fijo', 1,0,2);

UPDATE vtiger_field SET uitype=16 WHERE tablename='vtiger_tiposdecomisiones' AND fieldname='tipodevuelo';