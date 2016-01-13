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
SET @mod1=_modulo;
SET @mod2=_modulorel;
SET @id1=_crmid;
SET @id2=_crmidrel;
IF (_modulo="RegistroDeVentas" AND _modulorel="Localizadores") THEN
	SET totBoletosBs	=(SELECT SUM(totalboletos) FROM vtiger_boletos WHERE currency="VEF" AND localizadorid=_crmidrel);	
	SET totBoletosDol	=(SELECT SUM(totalboletos) FROM vtiger_boletos WHERE currency="USD" AND localizadorid=_crmidrel);	
	UPDATE vtiger_registrodeventas 
	SET totalventabs=totBoletosBs, totalventadolares=totBoletosDol, totalpendientebs=totBoletosBs, totalpendientedolares=totBoletosDol 
	WHERE registrodeventasid = _crmid;
END IF;

END |
DELIMITER ;