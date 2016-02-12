DROP TRIGGER IF EXISTS insertar_ibip;
CREATE TRIGGER insertar_ibip AFTER INSERT ON ifm_pnrticket 
FOR EACH ROW
INSERT INTO registro_boletos.boletos (localizador, currency, fee_percentage, fee, total_amount,
montobase, coupon_status, passenger, sistemagds, emittedDate, creationDate, departureDate, 
ticketNumber, airlineID, YN_tax, status_emission, nombre_asesora, ID_asesora, nombre_satelite, 
ID_satelite, tipo_vuelo, itinerary)
VALUES (NEW.pnrLocator, NEW.bookingCurrency, NEW.fareCommissionPercent, NEW.fareCommission, NEW.totalPrice, NEW.price, NEW.voidStatus,
NEW.passenger, NEW.gdsName, NEW.itemDate, NEW.pnrCreationDate, NEW.departureDate, NEW.ticketNumber, NEW.airlineid, NEW.PriceVAT, NEW.emittedStatus, 
NEW.ticketingAgentname, NEW.ticketingAgentid, NEW.bookingAgentname, NEW.bookingAgentid, NEW.marketPlace, NEW.itinerary);