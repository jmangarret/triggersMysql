DROP TRIGGER IF EXISTS registrodeventas_loc_insert;
DELIMITER |
CREATE TRIGGER registrodeventas_loc_insert AFTER INSERT ON vtiger_crmentityrel
FOR EACH ROW BEGIN 	
	IF (NEW.module = "RegistroDeVentas" AND NEW.relmodule = "Localizadores") THEN
		CALL setCrmEntityRel(NEW.module,NEW.relmodule,NEW.crmid,NEW.relcrmid);	
	END IF;
END |
DELIMITER ;
