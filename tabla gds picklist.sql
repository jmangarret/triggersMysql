	CREATE TABLE `vtiger_gds` (
`gdsid` int( 11 ) NOT NULL AUTO_INCREMENT ,
`gds` varchar( 200 ) NOT NULL ,
`presence` int( 1 ) NOT NULL DEFAULT '1',
`picklist_valueid` int( 11 ) NOT NULL DEFAULT '0',
`sortorderid` int( 1 ) DEFAULT NULL ,
PRIMARY KEY ( `gdsid` )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';

INSERT INTO `vtiger_gds`
SELECT *
FROM `vtiger_cf_1605` ;

UPDATE `vtiger_field` SET `uitype` = '16' WHERE `vtiger_field`.`tablename` ='vtiger_localizadores' AND `vtiger_field`.`fieldname` ='paymentmethod';

UPDATE `vtiger_field` SET `uitype` = '16' WHERE `vtiger_field`.`tablename` ='vtiger_localizadores' AND `vtiger_field`.`fieldname` ='gds';
