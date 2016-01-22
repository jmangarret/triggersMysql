DROP PROCEDURE IF EXISTS `setTipoDeComisionTodos`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setTipoDeComisionTodos`(
	IN _comisionsatelitesid INT 
	)
BEGIN 
	DECLARE _tipodecomisionid INT;
	DECLARE _accountid INT;
	DECLARE _idsatelite INT;
	DECLARE _tipodeformula VARCHAR(50);
	DECLARE _base DOUBLE(8,2);
	DECLARE _aplicartodo INT;
	DECLARE _iduser INT;
	DECLARE _fecha DATETIME;
	DECLARE _type VARCHAR(100);
	DECLARE _existe INT;
	DECLARE _cursor_sat CURSOR FOR
	SELECT accountid,account_type FROM vtiger_account;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @end_row = TRUE;
	SELECT accountid,tipodecomisionid,tipodeformula,base,aplicartodo INTO _accountid,_tipodecomisionid,_tipodeformula,_base,_aplicartodo
	FROM vtiger_comisionsatelites WHERE comisionsatelitesid=_comisionsatelitesid;
	IF (_aplicartodo=1) THEN
		OPEN _cursor_sat;
		loop1: LOOP
		FETCH _cursor_sat INTO _idsatelite, _type;
		IF @end_row THEN
			LEAVE loop1;
		END IF;
		IF (_type="Satelite") THEN			
			SELECT COUNT(*) INTO _existe FROM vtiger_comisionsatelites WHERE accountid=_idsatelite AND tipodecomisionid=_tipodecomisionid;
			IF (_existe>0) THEN
				UPDATE vtiger_comisionsatelites SET tipodeformula=_tipodeformula,  base=_base WHERE accountid=_idsatelite AND tipodecomisionid=_tipodecomisionid;
			ELSE
				call getCrmid();			
				SELECT DISTINCT smcreatorid, createdtime INTO _iduser, _fecha FROM vtiger_crmentity WHERE setype="ComisionSatelites" AND crmid=_comisionsatelitesid;
				INSERT INTO vtiger_comisionsatelites(comisionsatelitesid,accountid,tipodecomisionid,tipodeformula,base,activa,aplicartodo) 
				VALUES(@idcrm,_idsatelite,_tipodecomisionid,_tipodeformula,_base,1,1);
				IF (ROW_COUNT()>0) THEN
					INSERT INTO vtiger_comisionsatelitescf(comisionsatelitesid) values(@idcrm);
					INSERT INTO vtiger_crmentity (crmid,smcreatorid,smownerid,setype,description,modifiedby,createdtime,modifiedtime,label)
					VALUES(@idcrm,_iduser,_iduser,'ComisionSatelites',NULL,_iduser,_fecha,_fecha,_idsatelite);
					UPDATE vtiger_crmentity_seq SET id=LAST_INSERT_ID(id+1);
				END IF;			
			END IF;			

		END IF;
		END LOOP loop1;
		CLOSE _cursor_sat;
	END IF;
END |
DELIMITER ;
