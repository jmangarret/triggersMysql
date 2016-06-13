DROP PROCEDURE IF EXISTS setComission;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setComission`(
IN find_id_boleto INT,
IN _tipodevuelo VARCHAR(100),
IN _status VARCHAR(100),
IN _before INT
)
BEGIN
DECLARE comision decimal(25,2);
DECLARE fee_sat decimal(25,2);
SET max_sp_recursion_depth = 5; 

	CALL getTypeComision(find_id_boleto,_tipodevuelo,_status);
	/*CALCULAMOS COMISION A PAGAR SATELITE*/
	IF @tipodeformula = "Porcentaje" THEN
		SET comision = @base * @montobase/100;
	ELSE
		SET comision = @base;
	END IF;
	/*CALCULAMOS FEE A COBRAR SATELITE*/
	IF @tipodeformula_fee = "Porcentaje" THEN
		SET fee_sat = @base_fee * @montobase_fee/100;
	ELSE
		SET fee_sat = @base_fee;
	END IF;  
	/*VALIDAMOS SI VIENE DEL TRIGGER BEFORE INSERT*/
	IF _before = 1 THEN
		SET @comision_sat = comision;
		SET @fee_sat = fee_sat;
	ELSE
		UPDATE vtigercrm600.vtiger_boletos SET comision_sat = comision 	WHERE boletosid = find_id_boleto;
		UPDATE vtigercrm600.vtiger_boletos SET fee_satelite = fee_sat, fee = fee_sat 	WHERE boletosid = find_id_boleto;
	END IF;
END |
DELIMITER ;
