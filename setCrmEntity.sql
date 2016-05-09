DROP PROCEDURE IF EXISTS setCrmEntity;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setCrmEntity`(
	IN modulo VARCHAR(250), 
	IN label VARCHAR(250), 
	IN creado DATETIME, 	
	IN idcrm INT,
	IN iduser INT
	)
BEGIN 
DECLARE TotReg INT;
/*
IF (iduser IS NULL) THEN
	SET iduser=1;
END IF;
*/
SET TotReg=(SELECT COUNT(*) FROM vtiger_crmentity WHERE crmid=idcrm AND setype=modulo);
IF (TotReg>0) THEN
	UPDATE vtiger_crmentity SET smcreatorid=iduser, smownerid=iduser, label=label WHERE crmid=idcrm and setype=modulo;	
ELSE
	INSERT INTO vtiger_crmentity (crmid,smcreatorid,smownerid,setype,description,modifiedby,createdtime,modifiedtime,label) 
	VALUES (idcrm,iduser,iduser,modulo,NULL,iduser,creado,creado,label);
	IF ROW_COUNT()>0 THEN				
		UPDATE vtiger_crmentity_seq SET id=idcrm;
	END IF;
END IF;
END |
DELIMITER ;