DROP TRIGGER IF EXISTS insertar_ibip;
DELIMITER |
CREATE TRIGGER insertar_ibip AFTER INSERT ON ifm_pnrticket 
FOR EACH ROW BEGIN
	DECLARE loc				VARCHAR(20);
	DECLARE _emittedStatus	VARCHAR(20);
	DECLARE hora			VARCHAR(5);
	DECLARE minuto			VARCHAR(5);
	DECLARE segundo			VARCHAR(5);
	DECLARE _itemDate 		VARCHAR(50);
	DECLARE _creationDate	VARCHAR(50);
	SET _emittedStatus=NEW.emittedStatus;
	IF (_emittedStatus IS NULL OR _emittedStatus='') THEN
		SET _emittedStatus=(SELECT DISTINCT emittedStatus FROM ifm_pnrairsegment WHERE ticketNumber=NEW.ticketNumber);
	END IF;
	
	SET hora=EXTRACT(HOUR FROM NOW());
	SET minuto=EXTRACT(MINUTE FROM NOW());
	SET segundo=EXTRACT(SECOND FROM NOW());
	SET _itemDate=		CONCAT(NEW.itemDate,' ',hora,':',minuto,':',segundo);
	SET _creationDate=	CONCAT(NEW.pnrCreationDate,' ',hora,':',minuto,':',segundo);

	INSERT INTO registro_boletos.boletos (id_xml,localizador, currency, fee_percentage, fee, total_amount,
	montobase, coupon_status, passenger, sistemagds, emittedDate, creationDate, departureDate, 
	ticketNumber, airlineID, YN_tax, total_tax, status_emission, nombre_asesora, ID_asesora, nombre_satelite, 
	ID_satelite, tipo_vuelo, itinerary, method_payment)
	VALUES (NEW.fileSourcefileName,NEW.pnrLocator, NEW.bookingCurrency, NEW.fareCommissionPercent, NEW.fareCommission, NEW.totalPrice, NEW.price, NEW.voidStatus,
	NEW.passenger, NEW.gdsName, _itemDate,_creationDate, NEW.departureDate, 
	CONCAT(NEW.airlineiataNumericCode,'-',NEW.ticketNumber), CONCAT(NEW.airlineid,'/',NEW.airlinedescription), NEW.PriceVAT, NEW.priceVAT+NEW.otherTax,_emittedStatus, 
	NEW.ticketingAgentname, NEW.ticketingAgentid, NEW.bookingAgentname, NEW.bookingAgentid, NEW.marketPlace, NEW.itinerary,@find_paymentmethod);

END |
DELIMITER ;



