DROP TRIGGER IF EXISTS crm_boletos_update;
DELIMITER |
CREATE TRIGGER crm_boletos_update BEFORE UPDATE ON vtiger_boletos
FOR EACH ROW BEGIN 	
	DECLARE totBoletos DOUBLE(25,2);
	SET NEW.totalboletos=NEW.fee + NEW.amount;
	SET totBoletos=(SELECT SUM(totalboletos) FROM vtiger_boletos WHERE localizadorid=NEW.localizadorid);	
	UPDATE vtiger_localizadores SET totalloc = totBoletos WHERE localizadoresid=NEW.localizadorid;
END |
DELIMITER ;
DROP TRIGGER IF EXISTS crm_boletos_insert;
DELIMITER |
CREATE TRIGGER crm_boletos_insert BEFORE INSERT ON vtiger_boletos
FOR EACH ROW BEGIN  
	DECLARE totBoletos DOUBLE(25,2);
	SET NEW.totalboletos=NEW.fee + NEW.amount;
	SET totBoletos=(SELECT SUM(totalboletos) FROM vtiger_boletos WHERE localizadorid=NEW.localizadorid);	
	UPDATE vtiger_localizadores SET totalloc = totBoletos WHERE localizadoresid=NEW.localizadorid;
END |
DELIMITER ;