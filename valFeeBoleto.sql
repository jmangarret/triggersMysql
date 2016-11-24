DROP PROCEDURE IF EXISTS valFeeBoleto;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `valFeeBoleto`(
	IN _loc VARCHAR(50)
	)
BEGIN 
	DECLARE _gds VARCHAR(100);
	DECLARE _valFreelance INT(11) DEFAULT 0; 
	DECLARE _valEmisionWeb INT(11) DEFAULT 0; 
	/*Validamos si no es SOTO*/
	SET @feeBoleto=0;
	SET _gds=(SELECT gds FROM vtiger_localizadores WHERE localizadoresid=_loc);
	IF (_gds='Amadeus' OR _gds='Kiu') THEN
		SET @feeBoleto=1;
	END IF;
	/*Si la emisión es de un Freelance no calcular fee de Agencia */
	SET _valFreelance=(SELECT acc.accountid
				FROM vtiger_account AS acc 
				INNER JOIN vtiger_contactdetails 	AS con ON acc.accountid=con.accountid 
				INNER JOIN vtiger_localizadores 	AS loc ON loc.contactoid=con.contactid 
				WHERE acc.account_type="Freelance" 	AND loc.localizadoresid=_loc);

	/*Validamos la firma de la Pagina Web, para no calcular fee de Agencia */
	SET _valEmisionWeb=(SELECT localizadoresid FROM vtiger_localizadores WHERE localizadoresid=_loc AND referencia='0001AASU');
	
	IF (_valEmisionWeb>0) THEN
		SET @feeBoleto=0;
	END IF;
	
END |
DELIMITER ;