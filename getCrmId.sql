DROP PROCEDURE IF EXISTS `getCrmId`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCrmId`()
BEGIN 
SET @idcrm=(SELECT MAX(crmid) FROM vtiger_crmentity)+1;
END|
DELIMITER ;