DROP PROCEDURE IF EXISTS set_Insert_Update_listuser;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `set_Insert_Update_listuser`(
IN nombre_apellido VARCHAR(200),
IN flag VARCHAR(20),
IN lastID INT)
BEGIN 
DECLARE max_id INT;
DECLARE estatus VARCHAR(20);

SET sql_safe_updates=0;
IF flag="insert" THEN
	SELECT max(listuserid) INTO max_id FROM vtiger_listuser;
    SET max_id = max_id+1;
    /*SELECT max_id, nombre_apellido;*/
    INSERT INTO vtiger_listuser (listuser, sortorderid, id_user) values (nombre_apellido, max_id, lastID);
END IF;

IF flag="update" THEN
	SELECT status INTO estatus FROM vtiger_users WHERE id=lastID;
    IF estatus="Inactive" THEN
		DELETE FROM vtiger_listuser WHERE id_user=lastID;
    ELSEIF estatus="Active" THEN
		UPDATE vtiger_listuser SET listuser=nombre_apellido WHERE id_user=lastID;
        IF ROW_COUNT()=0 THEN
			SELECT max(listuserid) INTO max_id FROM vtiger_listuser;
			SET max_id = max_id+1;
			INSERT INTO vtiger_listuser (listuser, sortorderid, id_user) values (nombre_apellido, max_id, lastID);
        END IF;
    END IF;
END IF;
END//
DELIMITER ;