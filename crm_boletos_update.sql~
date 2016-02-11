DROP TRIGGER IF EXISTS crm_boletos_update;
DELIMITER |
CREATE TRIGGER crm_boletos_update
BEFORE UPDATE ON vtigercrm600.vtiger_boletos
FOR EACH ROW BEGIN
SET NEW.totalboletos=NEW.fee+NEW.amount;
call getTypeComision(NEW.boletosid,1);
if NEW.status != "Procesado" THEN
	SET NEW.comision_sat = @comision_sat;
END IF;
END|
DELIMITER ;