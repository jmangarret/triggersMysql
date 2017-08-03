DROP PROCEDURE IF EXISTS getLastUpdate;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `getLastUpdate`(
	IN _id INT(11), 
	IN _module VARCHAR(50) 
	)
BEGIN 
	DECLARE LAST_UPDATE DATE;
	SET LAST_UPDATE=(SELECT CAST(modifiedtime AS DATE) FROM vtiger_crmentity WHERE crmid=_id AND setype=_module);
	
    SET @LAST_UPDATE= LAST_UPDATE;
END |
DELIMITER ;