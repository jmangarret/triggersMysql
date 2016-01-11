DROP PROCEDURE IF EXISTS valCuenta;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `valCuenta`(
	IN rif VARCHAR(20), 
	IN org VARCHAR(250), 
	IN tipo VARCHAR(250), 
	IN creado VARCHAR(20), 
	IN idcrm INT,
	IN iduser INT
	)
BEGIN 
DECLARE prefix VARCHAR(50);
DECLARE valCta INT;
IF (rif<>"") THEN
SET @id_entity=0;
SET @id_cuenta=0;
SET valCta=(SELECT accountid FROM vtiger_account WHERE siccode LIKE CONCAT("%",rif,"%"));
IF (valCta>0) THEN
	SET @idcrm=valCta;
	SET @id_cuenta=valCta;
ELSE
	CALL vtigercrm600.getCrmId();	#Devuelve @idcrm
	CALL vtigercrm600.getRecordNumber("Accounts");  #Devuelve @id_entity, @cur_prefix	
	CALL vtigercrm600.setCrmEntity("Accounts",org,creado,@idcrm,@iduser);
	INSERT INTO vtiger_account(accountid, accountname,account_no,siccode,account_type,email1,phone)
	VALUES(@idcrm,org,@cur_prefix,rif,tipo,"","");
	IF (ROW_COUNT()>0) THEN				
		SET @id_cuenta=@idcrm;
		UPDATE vtiger_modentity_num SET cur_id=@id_entity+1 WHERE cur_id=@id_entity AND active=1 AND semodule="Accounts";
	END IF;
END IF;
END IF;
END |
DELIMITER ;
