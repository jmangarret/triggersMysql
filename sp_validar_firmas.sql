DROP PROCEDURE IF EXISTS `validar_firmas`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `validar_firmas`(
IN firma VARCHAR(50),
IN id_contactid INT)
BEGIN 
DECLARE find_firmas_satelite VARCHAR(100);
DECLARE find_agenteid VARCHAR(100);

SELECT firmas_satelite INTO find_firmas_satelite FROM vtiger_contactdetails WHERE contactid=id_contactid;

IF ROW_COUNT()=0 THEN

	SELECT agenteid INTO find_agenteid FROM vtiger_users WHERE id=id_contactid;
    
    IF isnull(find_agenteid) or (find_agenteid="") THEN
		UPDATE vtiger_users SET agenteid=CONCAT(" |##| ", firma) WHERE id=id_contactid;
	ELSE
		UPDATE vtiger_users SET agenteid=CONCAT(agenteid, " |##| ", firma) WHERE id=id_contactid;
    END IF;
ELSEIF isnull(find_firmas_satelite) or (find_firmas_satelite="") THEN
	UPDATE vtiger_contactdetails SET firmas_satelite=CONCAT(" |##| ", firma) WHERE contactid=id_contactid;
ELSE
	UPDATE vtiger_contactdetails SET firmas_satelite=CONCAT(firmas_satelite," |##| ", firma) WHERE contactid=id_contactid;
END IF;

END|
DELIMITER ;