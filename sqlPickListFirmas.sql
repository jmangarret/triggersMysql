	CREATE TABLE `vtiger_firma` (
`firmaid` int( 11 ) NOT NULL AUTO_INCREMENT ,
`firma` varchar( 200 ) NOT NULL ,
`presence` int( 1 ) NOT NULL DEFAULT '1',
`picklist_valueid` int( 11 ) NOT NULL DEFAULT '0',
`sortorderid` int( 1 ) DEFAULT NULL ,
PRIMARY KEY ( `firmaid` )
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `vtiger_users` CHANGE `agenteid` `agenteid` VARCHAR( 100 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;
UPDATE `vtiger_field` SET `fieldname` = 'firma', `uitype` = '33' WHERE `vtiger_field`.`columnname` ='agenteid' AND `vtiger_field`.`tablename` ='vtiger_users';
UPDATE `vtiger_field` SET `uitype` = '16' WHERE `vtiger_field`.`fieldname` ='gds' AND `vtiger_field`.`tablename` ='vtiger_terminales';
