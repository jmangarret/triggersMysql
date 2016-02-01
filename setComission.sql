DROP PROCEDURE IF EXISTS setComission;
DELIMITER |
CREATE DEFINER=`root`@`localhost`Procedure `setComission`(
IN tipodeformula VARCHAR(255),
IN base decimal(25,2),
IN _before INT,
IN _montobase decimal(25,2)
)
BEGIN
DECLARE comision decimal(25,2);
DECLARE find_id_boleto INT;

	IF tipodeformula = "Porcentaje" THEN
		SET comision = base*_montobase/100;
	ELSE
		SET comision = base;
	END IF;
    
SET find_id_boleto = (SELECT max(boletosid) FROM vtigercrm600.vtiger_boletos);
IF _before = 1 THEN
	SET @comision_sat = comision;
ELSE
	UPDATE vtigercrm600.vtiger_boletos SET comision_sat = comision WHERE boletosid = find_id_boleto;
END IF;
END |
DELIMITER ;