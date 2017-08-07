DROP TRIGGER IF EXISTS crm_boletos_update;
DELIMITER |
CREATE TRIGGER crm_boletos_update BEFORE UPDATE ON vtiger_boletos
FOR EACH ROW BEGIN	
	DECLARE AEROLINEA VARCHAR(100);
	SET @MONTO_FEE=0;
	CALL getFeeBoleto(NEW.localizadorid,NEW.status,NEW.tipodevuelo,NEW.itinerario);
	IF @MONTO_FEE>0 THEN
		SET NEW.fee = @MONTO_FEE;	
	END IF;
	/*CALCULAMOS FEE Y COMISION DE SATELITE*/
	CALL setComission(NEW.boletosid,NEW.tipodevuelo,NEW.status,1);
	SET NEW.comision_sat = @comision_sat;
	IF @fee_sat>0 THEN
		SET NEW.fee		= @fee_sat;
	END IF;
	IF NEW.status='Anulado' THEN
		SET NEW.amount=0;
	END IF;	
	SET AEROLINEA=(SELECT airline FROM vtiger_localizadores WHERE localizadoresid=NEW.localizadorid);
	IF NEW.status='Anulado' AND AEROLINEA LIKE 'AW%' THEN
		SET NEW.amount=2500;
	END IF;
	SET NEW.extra_fee=IF(ISNULL(NEW.extra_fee),0,NEW.extra_fee);
	SET NEW.totalboletos=NEW.fee + NEW.extra_fee + NEW.amount;
END|
DELIMITER ;

DROP TRIGGER IF EXISTS crm_boletos_insert_before;
DELIMITER |
CREATE TRIGGER crm_boletos_insert_before BEFORE INSERT ON vtiger_boletos
FOR EACH ROW BEGIN  
	DECLARE AEROLINEA VARCHAR(100);
	SET @MONTO_FEE=0;
	CALL getFeeBoleto(NEW.localizadorid,NEW.status,NEW.tipodevuelo,NEW.itinerario);
	IF @MONTO_FEE>0 THEN
		SET NEW.fee = @MONTO_FEE;	
	END IF;	
	/*CALCULAMOS FEE Y COMISION DE SATELITE*/
	CALL setComission(NEW.boletosid,NEW.tipodevuelo,NEW.status,1);
	SET NEW.comision_sat = @comision_sat;
	IF @fee_sat>0 THEN
		SET NEW.fee		= @fee_sat;
	END IF;
	IF NEW.status='Anulado' THEN
		SET NEW.amount=0;
	END IF;
	SET AEROLINEA=(SELECT airline FROM vtiger_localizadores WHERE localizadoresid=NEW.localizadorid);
	IF NEW.status='Anulado' AND AEROLINEA LIKE 'AW%' THEN
		SET NEW.amount=2500;
	END IF;	
	SET NEW.extra_fee=IF(ISNULL(NEW.extra_fee),0,NEW.extra_fee);
	SET NEW.totalboletos=NEW.fee + NEW.extra_fee + NEW.amount;	
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
	CALL setCrmEntityRel("Localizadores","Boletos",NEW.localizadorid, NEW.boletosid);	
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
	CALL setCrmEntityRel("Localizadores","Boletos",NEW.localizadorid, NEW.boletosid);		
END |
DELIMITER ;
