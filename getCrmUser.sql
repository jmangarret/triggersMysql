DROP PROCEDURE IF EXISTS `getCrmUser`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCrmUser`(
 IN ced VARCHAR(20)
 )
BEGIN 
SET @iduser=0;
IF ced<>'' THEN
 SET @iduser=(SELECT id FROM vtiger_users WHERE cedula =ced or agenteid like concat('%',ced,'%'));
  
 IF isnull(@iduser) THEN

 SET @iduser = (SELECT usercontactoid FROM vtiger_terminales WHERE  firma LIKE CONCAT('%',ced,'%'));

 END IF;
END IF;
END |
DELIMITER ;