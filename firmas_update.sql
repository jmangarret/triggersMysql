DROP TRIGGER IF EXISTS crm_firmas_insert;
DELIMITER |
CREATE TRIGGER crm_firmas_insert AFTER INSERT ON vtiger_terminales
FOR EACH ROW BEGIN  
	DECLARE totFirmas INT;	
    DECLARE contactid INT;
	DECLARE firmacontact VARCHAR(50);
    
	SET totFirmas=(SELECT MAX(sortorderid) FROM vtiger_firma);
    IF isnull(totFirmas) THEN
		SET totFirmas=0;
    END IF;
    
    SET contactid = (NEW.usercontactoid);
    SET firmacontact = (NEW.firma);
    
    IF isnull(contactid) THEN
        INSERT INTO vtiger_firma VALUES(NULL,NEW.firma,1,0,totFirmas+1,0);
	ELSE
		INSERT INTO vtiger_firma VALUES(NULL,NEW.firma,1,0,totFirmas+1,1);
        call validar_firmas(firmacontact, contactid);
    END IF;
END |
DELIMITER ;

DROP TRIGGER IF EXISTS crm_firmas_update;
DELIMITER |
CREATE TRIGGER crm_firmas_update AFTER UPDATE ON vtiger_terminales
FOR EACH ROW BEGIN 	
	DECLARE contactid INT;
	DECLARE firmacontact VARCHAR(50);
    
	UPDATE vtiger_firma SET firma=NEW.firma WHERE firma=OLD.firma;	
    
    SET contactid = (NEW.usercontactoid);
	SET firmacontact = (NEW.firma);

	call validar_firmas(firmacontact, contactid);
END |
DELIMITER ;