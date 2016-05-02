DROP TRIGGER IF EXISTS update_listuser;
DELIMITER |
CREATE TRIGGER update_listuser 
AFTER UPDATE ON vtiger_users
FOR EACH ROW BEGIN 	
    DECLARE flag VARCHAR(20);
    DECLARE nombre_update VARCHAR(200);
    DECLARE lastUpdate INT;
    
    SET lastUpdate=0;
    SET flag = "update";
    
    SET lastUpdate=(NEW.id);
    SET nombre_update=(CONCAT(NEW.first_name, ' ', NEW.last_name));
	CALL set_Insert_Update_listuser(nombre_update, flag, lastUpdate);	
END |
DELIMITER ;