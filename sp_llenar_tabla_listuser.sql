DROP PROCEDURE IF EXISTS `llenar_tabla_listuser`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `llenar_tabla_listuser`()
BEGIN 

DECLARE i INT;
DECLARE buff INT;

INSERT INTO vtiger_listuser (listuser, id_user) 
SELECT CONCAT(vtiger_users.first_name, ' ', vtiger_users.last_name) 
AS nombre, id FROM vtiger_users WHERE status="Active";

set buff = ROW_COUNT();

SET i = 1;

WHILE buff>=i do
UPDATE vtiger_listuser set sortorderid=i WHERE listuserid=i;
SET i = i+1;
END WHILE;

END|
DELIMITER ;

call llenar_tabla_listuser();