DROP PROCEDURE IF EXISTS `updateSatelites`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSatelites`()
BEGIN 
	DECLARE _idsatelite INT;
	DECLARE _type VARCHAR(100);

	DECLARE _cursor_sat CURSOR FOR
	SELECT accountid,account_type FROM vtiger_account;
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @end_row = TRUE;
	OPEN _cursor_sat;
	loop1: LOOP
	FETCH _cursor_sat INTO _idsatelite, _type;
	IF @end_row THEN
		LEAVE loop1;
	END IF;
	IF (_type="Satelite") THEN		
			UPDATE vtiger_contactdetails SET isSatelite=1 WHERE accountid=_idsatelite;
	END IF;

	END LOOP loop1;
	CLOSE _cursor_sat;

END |
DELIMITER ;
