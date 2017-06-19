DROP TRIGGER IF EXISTS insert_pagos_update_venta;
DELIMITER |
CREATE TRIGGER insert_pagos_update_venta AFTER INSERT ON vtiger_registrodepagos
FOR EACH ROW BEGIN 	
	CALL totVentasPagadas(NEW.registrodeventasid);	
END |
DELIMITER ;

DROP TRIGGER IF EXISTS update_pagos_update_venta;
DELIMITER |
CREATE TRIGGER update_pagos_update_venta AFTER UPDATE ON vtiger_registrodepagos
FOR EACH ROW BEGIN 	
	CALL totVentasPagadas(NEW.registrodeventasid);	
END |
DELIMITER ;

DROP PROCEDURE IF EXISTS totVentasPagadas;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `totVentasPagadas`(
	IN _ventaId INT)
BEGIN 
DECLARE _cambio DOUBLE(25,2); 
DECLARE _status VARCHAR(100); 
DECLARE _totVentaDol DOUBLE(25,2); 
DECLARE _totVentaBs DOUBLE(25,2); 
DECLARE _totPagosDol DOUBLE(25,2);	
DECLARE _totPagosBs DOUBLE(25,2);
DECLARE _totPendBs DOUBLE(25,2);
DECLARE _totPendDol DOUBLE(25,2);
DECLARE _totDolEnBs DOUBLE(25,2);
DECLARE _totCambioBs DOUBLE(25,2);
SELECT cf_881 , cf_1621 INTO _cambio, _status FROM vtiger_registrodeventascf WHERE registrodeventasid = _ventaId;
IF (ISNULL(_cambio) OR !_cambio OR _cambio=0) THEN 
	SET _cambio=1;
END IF;

SELECT 	IF(ISNULL(totalventabs),0,totalventabs), 
		IF(ISNULL(totalventadolares),0,totalventadolares) 
		INTO _totVentaBs,_totVentaDol  
		FROM vtiger_registrodeventas 
		WHERE registrodeventasid = _ventaId;

SET _totPagosDol=(SELECT IF(ISNULL(SUM(amount)),0,SUM(amount)) AS pagoDolares FROM vtiger_registrodepagos WHERE currency="USD" AND registrodeventasid = _ventaId);
SET _totPagosBs	=(SELECT IF(ISNULL(SUM(amount)),0,SUM(amount)) AS PagoBs FROM vtiger_registrodepagos WHERE currency="VEF" AND registrodeventasid =_ventaId);

SET _totPendBs = _totVentaBs - _totPagosBs;
IF (_totPagosDol>0) THEN
	SET _totPendDol = _totVentaDol - _totPagosDol;
END IF;

SET _totCambioBs = _totVentaDol * _cambio;

SET _totPendBs = _totVentaBs + _totCambioBs - (_totPagosBs + _totPagosDol * _cambio);

IF (_totPendBs<0 && _totVentaDol>0) THEN
	SET _totPendDol = _totVentaDol - _totPagosDol - (_totPagosBs/_cambio);
END IF;

IF (_totPagosDol<=0 OR _totPendBs=0) THEN
	SET _totPendDol	= 0;
END IF;
/*
IF (_totPagosBs>_totVentaBs AND _totPendDol>=0 AND (_totVentaBs>0 OR _totVentaDol>0)) THEN
	/*SET _totDolEnBs = (_totPagosBs - _totVentaBs) / _cambio;
	SET _totPendDol = _totVentaDol - _totPagosDol - _totDolEnBs;
	SET _totPendDol = _totVentaDol - _totPagosDol;
	SET _totPendBs = _totPendDol * _cambio;			
	SET _totPendBs = _totVentaBs + _totCambioBs - (_totPagosBs + _totPagosDol * _cambio);
END IF;
*/
UPDATE vtiger_registrodeventas 
SET totalpagadobs=_totPagosBs, totalpagadodolares= _totPagosDol, totalpendientebs=_totPendBs, totalpendientedolares=_totPendDol, totalcambiobs=_totCambioBs 
WHERE registrodeventasid =_ventaId;

IF (_status<>"Procesada") THEN
	IF (_totPendDol<=0 AND _totPendBs<=0) THEN
		UPDATE vtiger_registrodeventascf SET cf_1621="No Procesada" WHERE registrodeventasid = _ventaId;
	ELSE
		IF (_status="No Procesada" OR _status="Pagada") THEN
			UPDATE vtiger_registrodeventascf SET cf_1621="Pendiente de Pago" WHERE registrodeventasid = _ventaId;
		END IF;
	END IF;
END IF;

END |
DELIMITER ;