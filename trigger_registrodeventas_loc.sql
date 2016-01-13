DROP TRIGGER IF EXISTS registrodeventas_loc_insert;
DELIMITER |
CREATE TRIGGER registrodeventas_loc_insert AFTER INSERT ON vtiger_crmentityrel
FOR EACH ROW BEGIN 	
	CALL setCrmEntityRel(NEW.module,NEW.relmodule,NEW.crmid,NEW.relcrmid);	
END |
DELIMITER ;
