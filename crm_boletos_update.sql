DROP TRIGGER IF EXISTS crm_boletos_update;
DELIMITER |
CREATE TRIGGER crm_boletos_update BEFORE UPDATE ON vtiger_boletos
FOR EACH ROW BEGIN	
	SET @MONTO_FEE=0;
	CALL getFeeBoleto(NEW.localizadorid,NEW.status,NEW.tipodevuelo,NEW.itinerario);
	SET NEW.fee = @MONTO_FEE;
	SET NEW.totalboletos=NEW.fee + NEW.extra_fee + NEW.amount;
	/*CALCULAMOS FEE Y COMISION DE SATELITE*/
	CALL setComission(NEW.boletosid,NEW.tipodevuelo,NEW.status,1);
	SET NEW.comision_sat = @comision_sat;
	IF @fee_sat>0 THEN
		SET NEW.fee		= @fee_sat;
	END IF;
	
END|
DELIMITER ;

DROP TRIGGER IF EXISTS crm_boletos_insert_before;
DELIMITER |
CREATE TRIGGER crm_boletos_insert_before BEFORE INSERT ON vtiger_boletos
FOR EACH ROW BEGIN  
	SET @MONTO_FEE=0;
	CALL getFeeBoleto(NEW.localizadorid,NEW.status,NEW.tipodevuelo,NEW.itinerario);
	SET NEW.fee = @MONTO_FEE;
	SET NEW.totalboletos=NEW.fee + NEW.extra_fee + NEW.amount;	
	/*CALCULAMOS FEE Y COMISION DE SATELITE*/
	CALL setComission(NEW.boletosid,NEW.tipodevuelo,NEW.status,1);
	SET NEW.comision_sat = @comision_sat;
	IF @fee_sat>0 THEN
		SET NEW.fee		= @fee_sat;
	END IF;

END |
DELIMITER ;

DROP TRIGGER IF EXISTS crm_boletos_update_after;
DELIMITER |
CREATE TRIGGER crm_boletos_update_after AFTER UPDATE ON vtiger_boletos
FOR EACH ROW BEGIN 	
	DECLARE _totalloc DOUBLE(25,2);
	SET _totalloc=(SELECT SUM(totalboletos) FROM vtiger_boletos AS b WHERE localizadorid=NEW.localizadorid AND b.boletosid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1));
	UPDATE vtiger_localizadores SET totalloc=_totalloc WHERE localizadoresid=NEW.localizadorid;
	CALL setCrmEntityRel("RegistroDeVentas","Localizadores",0,NEW.localizadorid);	
END |
DELIMITER ;

DROP TRIGGER IF EXISTS crm_boletos_insert_after;
DELIMITER |
CREATE TRIGGER crm_boletos_insert_after AFTER INSERT ON vtiger_boletos
FOR EACH ROW BEGIN 	
	DECLARE _totalloc DOUBLE(25,2);	
	SET _totalloc=(SELECT SUM(totalboletos) FROM vtiger_boletos AS b WHERE localizadorid=NEW.localizadorid AND b.boletosid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1));
	UPDATE vtiger_localizadores SET totalloc=_totalloc WHERE localizadoresid=NEW.localizadorid;
	CALL setCrmEntityRel("RegistroDeVentas","Localizadores",0,NEW.localizadorid);	
END |
DELIMITER ;
