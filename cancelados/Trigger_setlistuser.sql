DROP TRIGGER IF EXISTS setlistuser;
DELIMITER //
CREATE TRIGGER setlistuser
AFTER INSERT ON vtiger_users
FOR EACH ROW BEGIN
DECLARE nombre_apellido_insert VARCHAR(200);
DECLARE flag VARCHAR(20);
DECLARE lastInsert INT;

SET lastInsert=0;
SET nombre_apellido_insert = "";
SET flag = "insert";

SET lastInsert = (SELECT max(id) FROM vtiger_users);
SELECT CONCAT(vtiger_users.first_name, ' ', vtiger_users.last_name) 
AS nombre INTO nombre_apellido_insert FROM vtiger_users WHERE status="Active" AND id=lastInsert;
call set_Insert_Update_listuser(nombre_apellido_insert, flag, lastInsert);
END//
DELIMITER ;