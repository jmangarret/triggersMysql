/*MOSTRAR CAMPOS RESUMEN DETALLE CUENTAS Y CONTACTOS*/
UPDATE `vtigercrm600`.`vtiger_field` SET `summaryfield` = '1' WHERE `vtiger_field`.`columnname` ='account_type' AND tablename='vtiger_account';
UPDATE `vtigercrm600`.`vtiger_field` SET `summaryfield` = '1' WHERE `vtiger_field`.`columnname` ='accountid' AND tablename='vtiger_contactdetails';
/*MOSTRAR CAMPOS POPUP CREAR CUENTAS*/
UPDATE `vtigercrm600`.`vtiger_field` SET `quickcreate` = '2' WHERE  `vtiger_field`.`columnname` ='siccode' AND tablename='vtiger_account';
UPDATE `vtigercrm600`.`vtiger_field` SET `quickcreate` = '2' WHERE  `vtiger_field`.`columnname` ='email1' AND tablename='vtiger_account';
UPDATE `vtigercrm600`.`vtiger_field` SET `quickcreate` = '2' WHERE `vtiger_field`.`columnname` ='account_type' AND tablename='vtiger_account';