DROP TRIGGER IF EXISTS comision_sat_insert;
DELIMITER |
CREATE TRIGGER comision_sat_insert AFTER INSERT ON vtiger_comisionesatelites
FOR EACH ROW BEGIN 	
	DECLARE _idtipocomision INT,
	DECLARE _idsatelite INT
	IF NEW.aplicartodo=1 THEN
		DECLARE _satelite CURSOR FOR
		SELECT accountid FROM vtiger_account WHERE account_type="Satelite" AND accountid<>NEW.accountid;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET @hecho = TRUE;
		OPEN _satelite;
		loop1: LOOP
		FETCH _satelite INTO _idsatelite;
		IF @hecho THEN
			LEAVE loop1;
		END IF;
		call getCrmid();
		--buscar usuario smcreatorid en crmentity segun setype y crmid
		INSERT INTO vtiger_comisionsatelites(comisionsatelitesid,accountid,tipodecomisionid,tipodeformula,base,activa) 
		VALUES(@idcrm,_satelite,NEW.tipodecomisionid,NEW.tipodeformula,NEW.base,NEW.activa);
		END LOOP loop1;
		CLOSE _satelite;

	END IF;
END |
DELIMITER ;
