DROP PROCEDURE IF EXISTS `getCrmUser`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCrmUser`(
 IN ced VARCHAR(20)
 )
BEGIN 
SET @iduser=1;
IF ced<>'' THEN
 SET @iduser = (SELECT usercontactoid FROM vtiger_terminales AS t INNER JOIN vtiger_users AS u ON t.usercontactoid=u.id  WHERE firma LIKE CONCAT('%',ced,'%') LIMIT 1);
 
 IF ISNULL(@iduser) THEN
 	SET @iduser=1;
 END IF;
 
END IF;
END |
DELIMITER ;