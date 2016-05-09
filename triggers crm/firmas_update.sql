DROP TRIGGER IF EXISTS crm_firmas_insert_before;
DELIMITER |
CREATE TRIGGER crm_firmas_insert_before BEFORE INSERT ON vtiger_terminales
FOR EACH ROW BEGIN  	
    IF NEW.usercontactoid>0 THEN
        SET NEW.asignada=1;
	END IF;
END |
DELIMITER ;

DROP TRIGGER IF EXISTS crm_firmas_update_before;
DELIMITER |
CREATE TRIGGER crm_firmas_update_before BEFORE UPDATE ON vtiger_terminales
FOR EACH ROW BEGIN  	
    IF NEW.usercontactoid>0 THEN
        SET NEW.asignada=1;
	END IF;
END |
DELIMITER ;

DROP TRIGGER IF EXISTS crm_firmas_insert;
DELIMITER |
CREATE TRIGGER crm_firmas_insert AFTER INSERT ON vtiger_terminales
FOR EACH ROW BEGIN  
	DECLARE totFirmas INT;	
    DECLARE contactid INT;
	DECLARE firmacontact VARCHAR(50);
    
	SET totFirmas=(SELECT MAX(sortorderid) FROM vtiger_firma);
    IF ISNULL(totFirmas) THEN
		SET totFirmas=0;
    END IF;
    
    SET contactid = (NEW.usercontactoid);
    SET firmacontact = (NEW.firma);
    
    IF ISNULL(contactid) THEN
        INSERT INTO vtiger_firma VALUES(NULL,NEW.firma,1,0,totFirmas+1,0);
	ELSE
		INSERT INTO vtiger_firma VALUES(NULL,NEW.firma,1,0,totFirmas+1,1);
        CALL validar_firmas(firmacontact, contactid);
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

	CALL validar_firmas(firmacontact, contactid);
END |
DELIMITER ;