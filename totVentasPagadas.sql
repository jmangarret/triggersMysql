DROP PROCEDURE IF EXISTS totVentasPagadas;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `totVentasPagadas`(
	IN _pagoId INT,
	IN _ventaId
	)
BEGIN 
DECLARE _cambio DOUBLE(25,2); 
DECLARE _status VARCHAR(250); 
DECLARE _totVentaDol DOUBLE(25,2); 
DECLARE _totVentaBs DOUBLE(25,2); 
DECLARE _totPagosDol DOUBLE(25,2);	
DECLARE _totPagosBs DOUBLE(25,2);
DECLARE _totPendBs DOUBLE(25,2);
DECLARE _totPendDol DOUBLE(25,2)
SELECT cf_1621, cf_881 INTO _cambio, _status FROM vtiger_registrodeventascf WHERE registrodeventasid = _ventaId;


END |
DELIMITER ;