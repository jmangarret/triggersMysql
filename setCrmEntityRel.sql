DROP PROCEDURE IF EXISTS setCrmEntityRel;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setCrmEntityRel`(
	IN _modulo VARCHAR(250), 
	IN _modulorel VARCHAR(250), 
	IN _crmid VARCHAR(25), 
	IN _crmidrel VARCHAR(25)	
	)
BEGIN 
DECLARE totBoletosBs DOUBLE(25,2);
DECLARE totBoletosDol DOUBLE(25,2);
IF (_modulo="RegistroDeVentas" AND _modulorel="Localizadores") THEN
	IF (_crmid=0) THEN
		SET _crmid=(SELECT registrodeventasid FROM vtiger_localizadores WHERE localizadoresid=_crmidrel);
	END IF;
	SET totBoletosBs	=(SELECT SUM(totalboletos) FROM vtiger_boletos WHERE currency="VEF" AND localizadorid=_crmidrel AND status<>'Anulado');	
	SET totBoletosDol	=(SELECT SUM(totalboletos) FROM vtiger_boletos WHERE currency="USD" AND localizadorid=_crmidrel AND status<>'Anulado');	

	UPDATE vtiger_registrodeventas 
	SET totalventabs=totBoletosBs, totalventadolares=totBoletosDol, totalpendientebs=totBoletosBs, totalpendientedolares=totBoletosDol 
	WHERE registrodeventasid = _crmid;
	IF ROW_COUNT()>0 THEN		
		UPDATE vtiger_localizadores SET registrodeventasid=_crmid, procesado=1 WHERE localizadoresid=_crmidrel;
	END IF;	
END IF;

END |
DELIMITER ;