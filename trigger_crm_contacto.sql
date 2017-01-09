DROP TRIGGER IF EXISTS CRM_contactos;
DELIMITER | 
CREATE TRIGGER CRM_contactos AFTER INSERT ON ost_user 
FOR EACH ROW BEGIN
  DECLARE user_mail varchar(200);
  DECLARE user_mail_cond varchar(200);
  DECLARE crmentity_id integer;
  DECLARE cur_id_val integer;
  DECLARE modtracker_id integer;

  SET user_mail = (SELECT `address` FROM `osticket1911`.`ost_user_email` WHERE `id` = NEW.`default_email_id`);
  SET user_mail_cond = (SELECT COUNT(`email`) FROM `vtigercrm600`.`vtiger_contactdetails` WHERE UPPER(`email`) = UPPER(user_mail));

  IF(user_mail_cond <= 0) THEN 
  BEGIN
    SET cur_id_val = (SELECT `cur_id` FROM `vtigercrm600`.`vtiger_modentity_num` WHERE `active` =1 AND `semodule` = 'Contacts');
    UPDATE `vtigercrm600`.`vtiger_crmentity_seq` set `id` = LAST_INSERT_ID(id+1);
    SET crmentity_id = (SELECT MAX(`id`) FROM `vtigercrm600`.`vtiger_crmentity_seq`);
    insert into `vtigercrm600`.`vtiger_crmentity` (`crmid`,`smcreatorid`,`smownerid`,`setype`,`description`,`modifiedby`,`createdtime`,`modifiedtime`) values(crmentity_id,'1','1','Contacts',NULL,'1',NOW(),NOW());
    UPDATE `vtigercrm600`.`vtiger_modentity_num` SET `cur_id`=(cur_id_val+1) where `cur_id`=cur_id_val and `active`=1 AND `semodule`='Contacts';
    insert into `vtigercrm600`.vtiger_contactdetails(contactid,salutation,firstname,contact_no,phone,lastname,mobile,accountid,fax,email,isSatelite) values(crmentity_id,'',SUBSTRING_INDEX(NEW.name,' ',1),CONCAT('CON',cur_id_val),'',SUBSTRING_INDEX(NEW.name,' ',-1),'',0,'',user_mail,'0');
    insert into `vtigercrm600`.vtiger_contactaddress(contactaddressid,mailingstreet,mailingcity,mailingzip) values(crmentity_id,'','','');
    insert into `vtigercrm600`.vtiger_contactsubdetails(contactsubscriptionid,homephone) values(crmentity_id,'');
    insert into `vtigercrm600`.vtiger_contactscf(contactid,cf_614,cf_663,cf_664,cf_665,cf_666,cf_667,cf_829) values(crmentity_id,'','','',NULL,NULL,NULL,'V');
    insert into `vtigercrm600`.vtiger_customerdetails(customerid) values(crmentity_id);
    UPDATE `vtigercrm600`.vtiger_portalinfo SET user_name=user_mail,isactive=0 WHERE id=crmentity_id;
    UPDATE `vtigercrm600`.vtiger_crmentity SET label=CONCAT(SUBSTRING_INDEX(NEW.name,' ',1),' ',SUBSTRING_INDEX(NEW.name,' ',-1)) WHERE crmid=crmentity_id;
    update `vtigercrm600`.vtiger_modtracker_basic_seq set id=LAST_INSERT_ID(id+1);
    SET modtracker_id = (SELECT MAX(`id`) FROM `vtigercrm600`.`vtiger_modtracker_basic_seq`);
    INSERT INTO `vtigercrm600`.vtiger_modtracker_basic(id, crmid, module, whodid, changedon, status) VALUES (modtracker_id,crmentity_id,'Contacts','1',NOW(),'2');
    INSERT INTO `vtigercrm600`.vtiger_modtracker_detail(id,fieldname,prevalue,postvalue) VALUES(modtracker_id,'firstname',NULL,SUBSTRING_INDEX(NEW.name,' ',1));
    INSERT INTO `vtigercrm600`.vtiger_modtracker_detail(id,fieldname,prevalue,postvalue) VALUES(modtracker_id,'contact_no',NULL,CONCAT('CON',cur_id_val));
    INSERT INTO `vtigercrm600`.vtiger_modtracker_detail(id,fieldname,prevalue,postvalue) VALUES(modtracker_id,'lastname',NULL,SUBSTRING_INDEX(NEW.name,' ',-1));
    INSERT INTO `vtigercrm600`.vtiger_modtracker_detail(id,fieldname,prevalue,postvalue) VALUES(modtracker_id,'email',NULL,user_mail);
    INSERT INTO `vtigercrm600`.vtiger_modtracker_detail(id,fieldname,prevalue,postvalue) VALUES(modtracker_id,'assigned_user_id',NULL,'1');
    INSERT INTO `vtigercrm600`.vtiger_modtracker_detail(id,fieldname,prevalue,postvalue) VALUES(modtracker_id,'createdtime',NULL,NOW());
    INSERT INTO `vtigercrm600`.vtiger_modtracker_detail(id,fieldname,prevalue,postvalue) VALUES(modtracker_id,'cf_829',NULL,'V');
    INSERT INTO `vtigercrm600`.vtiger_modtracker_detail(id,fieldname,prevalue,postvalue) VALUES(modtracker_id,'modifiedby',NULL,'1');
    INSERT INTO `vtigercrm600`.vtiger_modtracker_detail(id,fieldname,prevalue,postvalue) VALUES(modtracker_id,'record_id',NULL,crmentity_id);
    INSERT INTO `vtigercrm600`.vtiger_modtracker_detail(id,fieldname,prevalue,postvalue) VALUES(modtracker_id,'record_module',NULL,'Contacts');

  END; 
  END IF;
END |
DELIMITER ;
