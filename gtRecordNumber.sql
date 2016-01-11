DROP PROCEDURE IF EXISTS `getRecordNumber`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `getRecordNumber`(
	IN module VARCHAR(30) 
	)
BEGIN 
DECLARE id  INT(11);
DECLARE pref VARCHAR(20);
SELECT cur_id, CONCAT(prefix,cur_id) INTO id,pref FROM vtiger_modentity_num WHERE semodule=module and active=1; 
SET @id_entity=id;
SET @cur_prefix=pref;
END |
DELIMITER ;