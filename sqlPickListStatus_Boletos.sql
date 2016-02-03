	CREATE TABLE `vtiger_tipotransaccion` (
`tipotransaccionid` int( 11 ) NOT NULL AUTO_INCREMENT ,
`tipotransaccion` varchar( 200 ) NOT NULL ,
`presence` int( 1 ) NOT NULL DEFAULT '1',
`picklist_valueid` int( 11 ) NOT NULL DEFAULT '0',
`sortorderid` int( 1 ) DEFAULT NULL ,
PRIMARY KEY ( `tipotransaccionid` )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

INSERT INTO `vtiger_tipotransaccion` VALUES (1,'Cargo', 1,0,1);
INSERT INTO `vtiger_tipotransaccion` VALUES (2,'Abono', 1,0,2);

	CREATE TABLE `vtiger_tipousuario` (
`tipousuarioid` int( 11 ) NOT NULL AUTO_INCREMENT ,
`tipousuario` varchar( 200 ) NOT NULL ,
`presence` int( 1 ) NOT NULL DEFAULT '1',
`picklist_valueid` int( 11 ) NOT NULL DEFAULT '0',
`sortorderid` int( 1 ) DEFAULT NULL ,
PRIMARY KEY ( `tipousuarioid` )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

INSERT INTO `vtiger_tipousuario` VALUES (1,'Asesor', 1,0,1);
INSERT INTO `vtiger_tipousuario` VALUES (2,'Satelite', 1,0,2);
INSERT INTO `vtiger_tipousuario` VALUES (3,'Administración', 1,0,3);

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

UPDATE `vtiger_entityname` SET `fieldname` = 'nombre' WHERE `vtiger_entityname`.`modulename` ='TiposdeComisiones';
UPDATE vtiger_field SET uitype=16 WHERE tablename='vtiger_tiposdecomisiones' AND fieldname='tipotransaccion';
UPDATE vtiger_field SET uitype=16 WHERE tablename='vtiger_tiposdecomisiones' AND fieldname='tipousuario';
UPDATE vtiger_field SET uitype=16 WHERE tablename='vtiger_comisionsatelites' AND fieldname='tipodeformula';
UPDATE vtiger_field SET uitype=16 WHERE tablename='vtiger_tiposdecomisiones' AND fieldname='gds';
UPDATE vtiger_field SET uitype=16 WHERE tablename='vtiger_tiposdecomisiones' AND fieldname='tipodevuelo';