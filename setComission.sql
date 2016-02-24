DROP PROCEDURE IF EXISTS setComission;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setComission`(
IN find_id_boleto INT,
IN _before INT
)
BEGIN
DECLARE comision decimal(25,2);
SET max_sp_recursion_depth = 5; 

	CALL getTypeComision(find_id_boleto);

	IF @tipodeformula = "Porcentaje" THEN
		SET comision = @base * @montobase/100;
	ELSE
		SET comision = @base;
	END IF;
    

IF _before = 1 THEN
	SET @comision_sat = comision;
ELSE
	UPDATE vtigercrm600.vtiger_boletos SET comision_sat = comision WHERE boletosid = find_id_boleto;
END IF;
END |
DELIMITER ;
