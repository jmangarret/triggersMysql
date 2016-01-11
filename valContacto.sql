DROP PROCEDURE IF EXISTS valContacto;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `valContacto`(
	IN rif VARCHAR(20), 
	IN contacto VARCHAR(250), 
	IN creado VARCHAR(20), 
	IN cuenta INT, 
	IN idcrm INT,
	IN iduser INT
	)
BEGIN 
DECLARE prefix VARCHAR(50);
DECLARE tipo VARCHAR(50);
DECLARE valCont INT;
DECLARE satelite INT DEFAULT 0;
SET @id_contacto=0;
IF (rif<>"") THEN
SET tipo=(SELECT account_type FROM vtiger_account WHERE accountid=cuenta);
IF (tipo="SATELITE") THEN 
	SET satelite=1;
END IF;
SET valCont=(SELECT contactid FROM vtiger_contactscf WHERE cf_614 LIKE CONCAT("%",rif,"%"));
IF (valCont>0) THEN
	SET @idcrm=valCont;
	SET @id_contacto=valCont;
ELSE
	CALL vtigercrm600.getCrmId();	#Devuelva @idcrm
	CALL vtigercrm600.getRecordNumber("Contacts");  #Devuelve @id_entity, @cur_prefix	  		
	CALL vtigercrm600.setCrmEntity("Contacts",contacto,creado,@idcrm,@iduser);		
	INSERT INTO vtiger_contactdetails(contactid, contact_no, accountid, firstname,isSatelite)
	VALUES(@idcrm,@cur_prefix,cuenta,contacto,satelite);
	IF (ROW_COUNT()>0) THEN		
		SET @id_contacto=@idcrm;
		INSERT INTO vtigercrm600.vtiger_contactscf (contactid, cf_614, cf_829) VALUES (@idcrm,rif,'V');		
		UPDATE vtiger_modentity_num SET cur_id=@id_entity+1 WHERE cur_id=@id_entity AND active=1 AND semodule="Contacts";
	 	INSERT INTO vtigercrm600.vtiger_contactaddress (contactaddressid,mailingcity,mailingstreet,mailingzip) VALUES (@idcrm,"CCS,Caracas,VE","CARACAS","1010");
		INSERT INTO vtigercrm600.vtiger_contactsubdetails (contactsubscriptionid,homephone) VALUES(@idcrm,"0000-0000000");
		INSERT INTO vtigercrm600.vtiger_customerdetails (customerid,portal) VALUES(@idcrm,0);	
	END IF;
END IF;
END IF;
END |
DELIMITER ;
