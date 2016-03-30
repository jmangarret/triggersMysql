DROP PROCEDURE IF EXISTS `setTickets`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setTickets`(IN id_ticket INT)
BEGIN 
DECLARE find_passenger VARCHAR(255);
DECLARE find_creationDate date;
DECLARE find_id_asesora VARCHAR(255);
DECLARE find_id_satelite VARCHAR(255);
DECLARE find_localizador VARCHAR(16);
DECLARE find_sistemagds VARCHAR(128);
DECLARE find_paymentmethod VARCHAR(128);
DECLARE find_status VARCHAR(128);
DECLARE find_status_anu VARCHAR(128);
DECLARE find_ticketNumber VARCHAR(255);
DECLARE find_currency VARCHAR(8);
DECLARE find_fee double(8,2);
DECLARE find_total_amount double(8,2);
DECLARE find_montobase double(8,2);
DECLARE find_emittedDate date;
DECLARE find_itinerario VARCHAR(255);
DECLARE id_localizador INT;
DECLARE find_tipo_vuelo VARCHAR(255);
DECLARE find_aerolinea VARCHAR(255);
DECLARE bandera INT;
DECLARE find_YN_tax decimal(15,2);
DECLARE find_total_tax decimal(15,2);

SET sql_safe_updates=0;
SET max_sp_recursion_depth = 255; 

SELECT localizador, currency, fee, total_amount, montobase, passenger, sistemagds, emittedDate, creationDate, 
ticketNumber, status_emission, ID_asesora, ID_satelite, tipo_vuelo, method_payment, itinerary, airlineID, YN_tax, total_tax, coupon_status
INTO find_localizador, find_currency, find_fee, find_total_amount, find_montobase, find_passenger, 
find_sistemagds, find_emittedDate, find_creationDate, find_ticketNumber, find_status, find_id_asesora, 
find_id_satelite, find_tipo_vuelo, find_paymentmethod, find_itinerario, find_aerolinea, find_YN_tax, find_total_tax, find_status_anu
FROM registro_boletos.boletos WHERE id=id_ticket;
SET @_localizador = find_localizador;
SET @_creationDate = find_creationDate;
SET @_passenger = find_passenger;
SET @_el_montobase = find_montobase;

call getCrmId();
call getCrmUser(find_id_asesora);

SELECT localizadoresid INTO id_localizador FROM vtiger_localizadores WHERE localizadores = find_localizador;

IF id_localizador>0 THEN
	/*VALIDAMOS LOC SI EL BOLETO VIENE ANULADO*/
	IF find_status_anu="Anulado" THEN
		UPDATE vtiger_localizadores SET procesado=0 WHERE localizadoresid=id_localizador;
	END IF;

	SET bandera = 1;
	call setVtigerBoletos(@idcrm, find_ticketNumber, find_localizador, find_currency, find_fee,
	find_total_amount, find_montobase, id_localizador, find_emittedDate, find_passenger, find_itinerario, find_status, find_tipo_vuelo, find_YN_tax, find_total_tax, bandera);

ELSE
	call encontrar_contactoid(find_id_satelite);

	call setVtigerLocalizadores(@idcrm, find_localizador, @contid, find_sistemagds, 
	find_paymentmethod, find_aerolinea, find_status);

	IF @salida>0 THEN

		SET id_localizador=@idcrm;
		SET bandera = 0;
		call getCrmId();
		call setVtigerBoletos(@idcrm, find_ticketNumber, find_localizador, find_currency, find_fee,
		find_total_amount, find_montobase, id_localizador, find_emittedDate, find_passenger, find_itinerario, find_status, find_tipo_vuelo, find_YN_tax, find_total_tax, bandera);

	END IF;
END IF;

SET sql_safe_updates=1;
END|
DELIMITER ;