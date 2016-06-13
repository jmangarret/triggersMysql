DROP PROCEDURE IF EXISTS valFeeBoleto;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `valFeeBoleto`(
	IN _loc VARCHAR(50)
	)
BEGIN 
	DECLARE _gds VARCHAR(100);
	DECLARE _ctaid INT(11) DEFAULT 0; 
	/* Validamos si no es SOTO */
	SET @feeBoleto=0;
	SET _gds=(SELECT gds FROM vtiger_localizadores WHERE localizadoresid=_loc);
	IF (_gds='Amadeus' OR _gds='Kiu') THEN
		SET @feeBoleto=1;
	END IF;
	/* Si la emisión es de un Satélite no calcular fee de Agencia 
	SET _ctaid=(SELECT acc.accountid
				FROM vtiger_account AS acc 
				INNER JOIN vtiger_contactdetails 	AS con ON acc.accountid=con.accountid 
				INNER JOIN vtiger_localizadores 	AS loc ON loc.contactoid=con.contactid 
				WHERE acc.account_type="Satelite" 	AND loc.localizadoresid=_loc);
	IF (_ctaid>0) THEN
		SET @feeBoleto=0;
	END IF;
	*/
END |
DELIMITER ;