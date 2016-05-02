DROP PROCEDURE IF EXISTS `validar_firmas`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `validar_firmas`(
IN firma VARCHAR(50),
IN id_contactid INT)
BEGIN 
DECLARE find_firmas_satelite VARCHAR(100);
DECLARE find_agenteid VARCHAR(100);
DECLARE find_old_contactid INT;

SELECT firmas_satelite INTO find_firmas_satelite FROM vtiger_contactdetails WHERE contactid=id_contactid;

IF ROW_COUNT()=0 THEN

	SELECT agenteid INTO find_agenteid FROM vtiger_users WHERE id=id_contactid;
    
    IF isnull(find_agenteid) or (find_agenteid="") THEN
		SELECT id INTO find_old_contactid FROM vtiger_users WHERE agenteid LIKE CONCAT("%",firma,"%");
		IF ROW_COUNT()>0 THEN
			UPDATE vtiger_users SET agenteid=REPLACE(agenteid, CONCAT(firma,' |##|'),'') WHERE id=find_old_contactid;
			IF ROW_COUNT()=0 THEN 
				UPDATE vtiger_users SET agenteid=REPLACE(agenteid, firma,'') WHERE id=find_old_contactid;
    		END IF;
		END IF;
		UPDATE vtiger_users SET agenteid=CONCAT(firma, " |##| ") WHERE id=id_contactid;
	ELSE
		SELECT id INTO find_old_contactid FROM vtiger_users WHERE agenteid LIKE CONCAT("%",firma,"%");
		IF ROW_COUNT()>0 THEN
			UPDATE vtiger_users SET agenteid=REPLACE(agenteid, CONCAT(firma,' |##|'),'') WHERE id=find_old_contactid;
			IF ROW_COUNT()=0 THEN 
				UPDATE vtiger_users SET agenteid=REPLACE(agenteid, firma,'') WHERE id=find_old_contactid;
    		END IF;
		END IF;
		UPDATE vtiger_users SET agenteid=CONCAT(agenteid, firma, " |##| ") WHERE id=id_contactid;
    END IF;
ELSEIF isnull(find_firmas_satelite) or (find_firmas_satelite="") THEN

	SELECT contactid INTO find_old_contactid FROM vtiger_contactdetails WHERE firmas_satelite LIKE CONCAT("%",firma,"%");
    IF ROW_COUNT()>0 THEN
		UPDATE vtiger_contactdetails SET firmas_satelite=REPLACE(firmas_satelite, CONCAT(firma,' |##|'),'') WHERE contactid=find_old_contactid;
		IF ROW_COUNT()=0 THEN
			UPDATE vtiger_contactdetails SET firmas_satelite=REPLACE(firmas_satelite, firma,'') WHERE contactid=find_old_contactid;
    	END IF;
    END IF;
    UPDATE vtiger_contactdetails SET firmas_satelite=CONCAT(firma, " |##| ") WHERE contactid=id_contactid;
    
ELSE
	SELECT contactid INTO find_old_contactid FROM vtiger_contactdetails WHERE firmas_satelite LIKE CONCAT("%",firma,"%");
    IF ROW_COUNT()>0 THEN
		UPDATE vtiger_contactdetails SET firmas_satelite=REPLACE(firmas_satelite, CONCAT(firma,' |##|'),'') WHERE contactid=find_old_contactid;
		IF ROW_COUNT()=0 THEN
			UPDATE vtiger_contactdetails SET firmas_satelite=REPLACE(firmas_satelite, firma,'') WHERE contactid=find_old_contactid;
    	END IF;
    END IF;
	UPDATE vtiger_contactdetails SET firmas_satelite=CONCAT(firmas_satelite, firma, " |##| ") WHERE contactid=id_contactid;
END IF;

END|
DELIMITER ;