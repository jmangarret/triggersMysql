DROP PROCEDURE IF EXISTS `setTickets`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setTickets`(IN id_ticket INT)
BEGIN 
DECLARE find_passenger VARCHAR(255);
DECLARE find_creationDate DATETIME;
DECLARE find_id_asesora VARCHAR(255);
DECLARE find_id_satelite VARCHAR(255);
DECLARE find_localizador VARCHAR(16);
DECLARE find_sistemagds VARCHAR(128);
DECLARE find_paymentmethod VARCHAR(128);
DECLARE find_status VARCHAR(128);
DECLARE find_status_anu VARCHAR(128);
DECLARE find_ticketNumber VARCHAR(255);
DECLARE find_currency VARCHAR(8);
DECLARE find_fee double(25,2);
DECLARE find_total_amount double(25,2);
DECLARE find_montobase double(25,2);
DECLARE find_emittedDate DATETIME;
DECLARE find_itinerario VARCHAR(255);
DECLARE id_localizador INT;
DECLARE find_tipo_vuelo VARCHAR(255);
DECLARE find_aerolinea VARCHAR(255);
DECLARE contacto_id VARCHAR(255);
DECLARE loc VARCHAR(255);
DECLARE bandera INT;
DECLARE find_YN_tax decimal(15,2);
DECLARE find_total_tax decimal(15,2);
DECLARE find_departure_date DATETIME;
DECLARE find_arrival_date DATETIME;

SET sql_safe_updates=0;
SET max_sp_recursion_depth = 255; 

SELECT localizador, currency, fee, total_amount, montobase, passenger, 
sistemagds, emittedDate, creationDate, ticketNumber, status_emission, ID_asesora, 
ID_satelite, tipo_vuelo, method_payment, itinerary, airlineID, YN_tax, total_tax, coupon_status, departureDate, arrivalDate
	INTO find_localizador, find_currency, find_fee, find_total_amount, find_montobase, find_passenger, 
	find_sistemagds, find_emittedDate, find_creationDate, find_ticketNumber, find_status, find_id_asesora, 
	find_id_satelite, find_tipo_vuelo, find_paymentmethod, find_itinerario, find_aerolinea, find_YN_tax, find_total_tax, find_status_anu, find_departure_date, find_arrival_date
FROM registro_boletos.boletos WHERE id=id_ticket;
SET @_localizador = find_localizador;
/*SET @_creationDate = find_creationDate; Se cambia fecha de creacion para asumir la de emision */
SET @_creationDate = find_emittedDate;
SET @_passenger = find_passenger;
SET @_el_montobase = find_montobase;

CALL getCrmId();
CALL getCrmUser(find_id_asesora);
/*BUSCAMOS SI ESTA EMITIDO QUITANDO EL IDENTIFICADOR DE STATUS*/
/*SET loc=SUBSTRING_INDEX(find_localizador, '(', 1);*/
/*SELECT localizadoresid INTO id_localizador FROM vtiger_localizadores WHERE localizador = loc LIMIT 1;*/

SELECT localizadoresid INTO id_localizador FROM vtiger_localizadores WHERE localizador = find_localizador LIMIT 1;

IF id_localizador>0 THEN
	/*VALIDAMOS LOC SI EL BOLETO VIENE ANULADO*/
	IF find_status_anu="Anulado" THEN		
		UPDATE vtiger_localizadores SET procesado=0,localizador=find_localizador WHERE localizadoresid=id_localizador;
	END IF;

	SET bandera = 1;
	
	CALL setVtigerBoletos(@idcrm, find_ticketNumber, find_localizador, find_currency, find_fee,
	find_total_amount, find_montobase, id_localizador, find_emittedDate, find_passenger, find_itinerario, find_status, find_tipo_vuelo, find_YN_tax, find_total_tax, bandera, find_departure_date, find_arrival_date);
	
ELSE	
	SELECT usercontactoid INTO contacto_id FROM vtiger_terminales AS t INNER JOIN vtiger_contactdetails AS d ON t.usercontactoid=d.contactid WHERE firma LIKE CONCAT('%',find_id_satelite,'%') LIMIT 1;
	
	CALL setVtigerLocalizadores(@idcrm, find_localizador, contacto_id, find_sistemagds, 
	find_paymentmethod, find_aerolinea, find_status, find_id_satelite);

	IF @salida>0 THEN

		SET id_localizador=@idcrm;
		SET bandera = 0;
		CALL getCrmId();
		
		CALL setVtigerBoletos(@idcrm, find_ticketNumber, find_localizador, find_currency, find_fee,
		find_total_amount, find_montobase, id_localizador, find_emittedDate, find_passenger, find_itinerario, find_status, find_tipo_vuelo, find_YN_tax, find_total_tax, bandera, find_departure_date, find_arrival_date);
		
	END IF;
END IF;

SET sql_safe_updates=1;
END|
DELIMITER ;