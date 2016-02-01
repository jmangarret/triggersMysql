DROP TRIGGER IF EXISTS crm_firmas_update;
DELIMITER |
CREATE TRIGGER crm_firmas_update AFTER UPDATE ON vtiger_terminales
FOR EACH ROW BEGIN 	
	UPDATE vtiger_firma SET firma=NEW.firma WHERE firma=OLD.firma;	
END |
DELIMITER ;
DROP TRIGGER IF EXISTS crm_firmas_insert;
DELIMITER |
CREATE TRIGGER crm_firmas_insert AFTER INSERT ON vtiger_terminales
FOR EACH ROW BEGIN  
	DECLARE totFirmas INT;
	SET totFirmas=(SELECT MAX(sortorderid) FROM vtiger_firma);
	INSERT INTO vtiger_firma VALUES(NULL,NEW.firma,1,0,totFirmas+1);	
END |
DELIMITER ;