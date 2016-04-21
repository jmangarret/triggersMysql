DROP TRIGGER IF EXISTS crm_boletos_update;
DELIMITER |
CREATE TRIGGER crm_boletos_update BEFORE UPDATE ON vtiger_boletos
FOR EACH ROW BEGIN
	CALL getFeeBoleto(NEW.status,NEW.tipodevuelo,NEW.itinerario);
	SET NEW.fee = @MONTO_FEE;
	SET NEW.totalboletos=NEW.fee+NEW.amount;
	CALL setComission(NEW.boletosid,1);
	IF NEW.status != "Procesado" THEN
		SET NEW.comision_sat = @comision_sat;
	END IF;
END|
DELIMITER ;

DROP TRIGGER IF EXISTS crm_boletos_insert_before;
DELIMITER |
CREATE TRIGGER crm_boletos_insert_before BEFORE INSERT ON vtiger_boletos
FOR EACH ROW BEGIN  	
	CALL getFeeBoleto(NEW.status,NEW.tipodevuelo,NEW.itinerario);
	SET NEW.fee = @MONTO_FEE;
	SET NEW.totalboletos=NEW.fee + NEW.amount;	
END |
DELIMITER ;
/*
DROP TRIGGER IF EXISTS crm_boletos_insert;
DELIMITER |
CREATE TRIGGER crm_boletos_insert AFTER INSERT ON vtiger_boletos
FOR EACH ROW BEGIN  	
	CALL setComission(NEW.boletosid,0);
END |
DELIMITER ;
*/

DROP TRIGGER IF EXISTS crm_boletos_update_after;
DELIMITER |
CREATE TRIGGER crm_boletos_update_after AFTER UPDATE ON vtiger_boletos
FOR EACH ROW BEGIN 	
	DECLARE _totalloc DOUBLE(25,2);
	SET _totalloc=(SELECT SUM(totalboletos) FROM vtiger_boletos WHERE localizadorid=NEW.localizadorid);
	UPDATE vtiger_localizadores SET totalloc=_totalloc WHERE localizadoresid=NEW.localizadorid;
	CALL setCrmEntityRel("RegistroDeVentas","Localizadores",0,NEW.localizadorid);	
END |
DELIMITER ;
