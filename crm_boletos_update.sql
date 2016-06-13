DROP TRIGGER IF EXISTS crm_boletos_update;
DELIMITER |
CREATE TRIGGER crm_boletos_update BEFORE UPDATE ON vtiger_boletos
FOR EACH ROW BEGIN	
	SET @MONTO_FEE=0;
	CALL valFeeBoleto(NEW.localizadorid);
	IF (@feeBoleto>0) THEN
		CALL getFeeBoleto(NEW.localizadorid,NEW.status,NEW.tipodevuelo,NEW.itinerario);
	END IF;
	SET NEW.fee = @MONTO_FEE;
	SET NEW.totalboletos=NEW.fee + NEW.extra_fee + NEW.amount;
	
	IF NEW.status = "Emitido" THEN
		CALL setComission(NEW.boletosid,NEW.tipodevuelo,1);
		SET NEW.comision_sat 	= @comision_sat;
		SET NEW.fee_satelite 	= @fee_sat;
		SET NEW.fee 			= @fee_sat;
	END IF;
END|
DELIMITER ;

DROP TRIGGER IF EXISTS crm_boletos_insert_before;
DELIMITER |
CREATE TRIGGER crm_boletos_insert_before BEFORE INSERT ON vtiger_boletos
FOR EACH ROW BEGIN  
	SET @MONTO_FEE=0;
	CALL valFeeBoleto(NEW.localizadorid);
	IF (@feeBoleto>0) THEN
		CALL getFeeBoleto(NEW.localizadorid,NEW.status,NEW.tipodevuelo,NEW.itinerario);
	END IF;	
	SET NEW.fee = @MONTO_FEE;
	SET NEW.totalboletos=NEW.fee + NEW.extra_fee + NEW.amount;	
	IF NEW.status = "Emitido" THEN
		CALL setComission(NEW.boletosid,NEW.tipodevuelo,1);
		SET NEW.comision_sat 	= @comision_sat;
		SET NEW.fee_satelite 	= @fee_sat;
		SET NEW.fee 			= @fee_sat;
	END IF;
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

DROP TRIGGER IF EXISTS crm_boletos_insert_after;
DELIMITER |
CREATE TRIGGER crm_boletos_insert_after AFTER INSERT ON vtiger_boletos
FOR EACH ROW BEGIN 	
	DECLARE _totalloc DOUBLE(25,2);
	SET _totalloc=(SELECT SUM(totalboletos) FROM vtiger_boletos WHERE localizadorid=NEW.localizadorid);
	UPDATE vtiger_localizadores SET totalloc=_totalloc WHERE localizadoresid=NEW.localizadorid;
	CALL setCrmEntityRel("RegistroDeVentas","Localizadores",0,NEW.localizadorid);	
END |
DELIMITER ;
