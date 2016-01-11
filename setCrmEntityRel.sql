DROP PROCEDURE IF EXISTS setCrmEntityRel;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setCrmEntityRel`(
	IN _modulo VARCHAR(250), 
	IN _modulorel VARCHAR(250), 
	IN _crmid INT,
	IN _crmidrel INT	
	)
BEGIN 
DECLARE totBoletosBs DOUBLE(25,2);
DECLARE totBoletosDol DOUBLE(25,2);
IF (modulo="RegistroDeVenta" AND modulorel="Localizadores") THEN
	SET totBoletosBs	=(SELECT SUM(totalboletos) FROM vtiger_boletos WHERE currency="VEF" AND localizadorid=_crmidrel);	
	SET totBoletosDol	=(SELECT SUM(totalboletos) FROM vtiger_boletos WHERE currency="USD" AND localizadorid=_crmidrel);	
	UPDATE vtiger_registrodeventas 
	SET totalventabs=totBoletosBs, totalventadolares=totBoletosDol, totalpendientebs=totBoletosBs, totalpendientedolares=totBoletosDol 
	WHERE registrodeventasid = _crmid;
END IF;

END |
DELIMITER ;