DROP TRIGGER IF EXISTS crm_boletos_update;
DELIMITER |
CREATE TRIGGER crm_boletos_update BEFORE UPDATE ON vtiger_boletos
FOR EACH ROW BEGIN
	DECLARE _gds VARCHAR(100);
	SET @MONTO_FEE=0;
	SET _gds=(SELECT gds FROM vtiger_localizadores WHERE localizadoresid=NEW.localizadorid);
	IF (_gds='Amadeus' OR _gds='Kiu') THEN
		CALL getFeeBoleto(NEW.status,NEW.tipodevuelo,NEW.itinerario);
	END IF;
	SET NEW.fee = @MONTO_FEE;
	SET NEW.totalboletos=NEW.fee + NEW.extra_fee + NEW.amount;
	CALL setComission(NEW.boletosid,1);
	IF NEW.status != "Procesado" THEN
		SET NEW.comision_sat = @comision_sat;
		SET NEW.fee_satelite = @fee_sat;
	END IF;
END|
DELIMITER ;

DROP TRIGGER IF EXISTS crm_boletos_insert_before;
DELIMITER |
CREATE TRIGGER crm_boletos_insert_before BEFORE INSERT ON vtiger_boletos
FOR EACH ROW BEGIN  
	DECLARE _gds VARCHAR(100);	
	SET @MONTO_FEE=0;
	SET _gds=(SELECT gds FROM vtiger_localizadores WHERE localizadoresid=NEW.localizadorid);
	IF (_gds='Amadeus' OR _gds='Kiu') THEN
		CALL getFeeBoleto(NEW.status,NEW.tipodevuelo,NEW.itinerario);
	END IF;	
	SET NEW.fee = @MONTO_FEE;
	SET NEW.totalboletos=NEW.fee + NEW.extra_fee + NEW.amount;	
END |
DELIMITER ;

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
