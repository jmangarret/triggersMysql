DROP TRIGGER IF EXISTS insertar_ibip;
DELIMITER |
CREATE TRIGGER insertar_ibip AFTER INSERT ON ifm_pnrticket 
FOR EACH ROW BEGIN
	DECLARE loc					VARCHAR(20);
	DECLARE _emittedStatus		VARCHAR(20);
	SET _emittedStatus=NEW.emittedStatus;
	IF ISNULL(_emittedStatus) THEN
		SET _emittedStatus=(SELECT emittedStatus FROM ifm_pnrairsegment WHERE ticketNumber=NEW.ticketNumber);
	END IF;
	CALL getPaymentMethod(NEW.pnrLocator);
	INSERT INTO registro_boletos.boletos (id_xml,localizador, currency, fee_percentage, fee, total_amount,
	montobase, coupon_status, passenger, sistemagds, emittedDate, creationDate, departureDate, 
	ticketNumber, airlineID, YN_tax, total_tax, status_emission, nombre_asesora, ID_asesora, nombre_satelite, 
	ID_satelite, tipo_vuelo, itinerary, method_payment)
	VALUES (NEW.fileSourcefileName,NEW.pnrLocator, NEW.bookingCurrency, NEW.fareCommissionPercent, NEW.fareCommission, NEW.totalPrice, NEW.price, NEW.voidStatus,
	NEW.passenger, NEW.gdsName, NEW.itemDate, NEW.pnrCreationDate, NEW.departureDate, 
	CONCAT(NEW.airlineiataNumericCode,'-',NEW.ticketNumber), CONCAT(NEW.airlineid,'/',NEW.airlinedescription), NEW.PriceVAT, NEW.priceVAT+NEW.otherTax,_emittedStatus, 
	NEW.ticketingAgentname, NEW.ticketingAgentid, NEW.bookingAgentname, NEW.bookingAgentid, NEW.marketPlace, NEW.itinerary,@find_paymentmethod);

END |
DELIMITER ;



