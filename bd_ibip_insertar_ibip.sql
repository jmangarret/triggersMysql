DROP TRIGGER IF EXISTS insertar_ibip;
DELIMITER |
CREATE TRIGGER insertar_ibip AFTER INSERT ON ifm_pnrticket 
FOR EACH ROW BEGIN		
	DECLARE _hora			VARCHAR(5);
	DECLARE _minuto			VARCHAR(5);
	DECLARE _segundo		VARCHAR(5);
	DECLARE _itemDate 		VARCHAR(50);
	DECLARE _creationDate	VARCHAR(50);
	
	SET @emittedStatus="Emitido";
	SET @nuevo_loc=NEW.pnrLocator;

	SET _hora=EXTRACT(HOUR FROM NOW());
	SET _minuto=EXTRACT(MINUTE FROM NOW());
	SET _segundo=EXTRACT(SECOND FROM NOW());
	SET _itemDate=		CONCAT(NEW.itemDate,' ',_hora,':',_minuto,':',_segundo);
	SET _creationDate=	CONCAT(NEW.pnrCreationDate,' ',_hora,':',_minuto,':',_segundo);

	INSERT INTO registro_boletos.boletos (id_xml,localizador, currency, fee_percentage, fee, total_amount,
	montobase, coupon_status, passenger, sistemagds, emittedDate, creationDate, departureDate, 
	ticketNumber, airlineID, YN_tax, total_tax, status_emission, nombre_asesora, ID_asesora, nombre_satelite, 
	ID_satelite, tipo_vuelo, itinerary, method_payment)
	VALUES (NEW.fileSourcefileName,@nuevo_loc, NEW.bookingCurrency, NEW.fareCommissionPercent, NEW.fareCommission, NEW.totalPrice, NEW.price, NEW.voidStatus,
	NEW.passenger, NEW.gdsName, _itemDate,_creationDate, NEW.departureDate, 
	CONCAT(NEW.airlineiataNumericCode,'-',NEW.ticketNumber), CONCAT(NEW.airlineid,'/',NEW.airlinedescription), NEW.PriceVAT, NEW.priceVAT+NEW.otherTax,@emittedStatus, 
	NEW.ticketingAgentname, NEW.ticketingAgentid, NEW.bookingAgentname, NEW.bookingAgentid, NEW.marketPlace, NEW.itinerary,@find_paymentmethod);

END |
DELIMITER ;

DROP TRIGGER IF EXISTS update_ibip;
DELIMITER |
CREATE TRIGGER update_ibip AFTER UPDATE ON ifm_pnrticket 
FOR EACH ROW BEGIN		
	DECLARE _hora			VARCHAR(5);
	DECLARE _minuto			VARCHAR(5);
	DECLARE _segundo		VARCHAR(5);
	DECLARE _itemDate 		VARCHAR(50);
	DECLARE _creationDate	VARCHAR(50);
	DECLARE _COUNT			INT;
	
	SET @emittedStatus="Emitido";
	SET @nuevo_loc=NEW.pnrLocator;

	SET _hora=EXTRACT(HOUR FROM NOW());
	SET _minuto=EXTRACT(MINUTE FROM NOW());
	SET _segundo=EXTRACT(SECOND FROM NOW());
	SET _itemDate=		CONCAT(NEW.itemDate,' ',_hora,':',_minuto,':',_segundo);
	SET _creationDate=	CONCAT(NEW.pnrCreationDate,' ',_hora,':',_minuto,':',_segundo);

	SET _COUNT=(SELECT COUNT(*) FROM registro_boletos.boletos WHERE ticketNumber=CONCAT(NEW.airlineiataNumericCode,'-',NEW.ticketNumber));
	IF _COUNT=0 THEN
		INSERT INTO registro_boletos.boletos (id_xml,localizador, currency, fee_percentage, fee, total_amount,
		montobase, coupon_status, passenger, sistemagds, emittedDate, creationDate, departureDate, 
		ticketNumber, airlineID, YN_tax, total_tax, status_emission, nombre_asesora, ID_asesora, nombre_satelite, 
		ID_satelite, tipo_vuelo, itinerary, method_payment)
		VALUES (NEW.fileSourcefileName,@nuevo_loc, NEW.bookingCurrency, NEW.fareCommissionPercent, NEW.fareCommission, NEW.totalPrice, NEW.price, NEW.voidStatus,
		NEW.passenger, NEW.gdsName, _itemDate,_creationDate, NEW.departureDate, 
		CONCAT(NEW.airlineiataNumericCode,'-',NEW.ticketNumber), CONCAT(NEW.airlineid,'/',NEW.airlinedescription), NEW.PriceVAT, NEW.priceVAT+NEW.otherTax,@emittedStatus, 
		NEW.ticketingAgentname, NEW.ticketingAgentid, NEW.bookingAgentname, NEW.bookingAgentid, NEW.marketPlace, NEW.itinerary,@find_paymentmethod);
	END IF;

END |
DELIMITER ;



