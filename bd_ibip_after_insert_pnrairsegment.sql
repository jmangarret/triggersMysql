DROP TRIGGER IF EXISTS after_insert_pnrairsegment;
DELIMITER |
CREATE TRIGGER after_insert_pnrairsegment AFTER INSERT ON ifm_pnrairsegment 
FOR EACH ROW BEGIN	
	CALL getStatusTicket(NEW.pnrLocator,NEW.ticketNumber,NEW.emittedStatus);
	UPDATE vtigercrm600.vtiger_boletos 			SET status=@emittedStatus 									WHERE boleto1 		LIKE CONCAT('%',NEW.ticketNumber,'%');
	UPDATE vtigercrm600.vtiger_localizadores 	SET localizador=@nuevo_loc 									WHERE localizador	= NEW.pnrLocator;
	UPDATE registro_boletos.boletos 			SET status_emission=@emittedStatus,localizador=@nuevo_loc 	WHERE ticketNumber 	LIKE CONCAT('%',NEW.ticketNumber,'%') AND sistemagds='Amadeus';
	UPDATE ifm_pnrticket 						SET emittedStatus=@emittedStatus,pnrLocator=@nuevo_loc 		WHERE ticketNumber 	LIKE CONCAT('%',NEW.ticketNumber,'%');
END |
DELIMITER ;

DROP TRIGGER IF EXISTS after_insert_dbstoredgdsfile;
DELIMITER |
CREATE TRIGGER after_insert_dbstoredgdsfile AFTER INSERT ON ifm_dbstoredgdsfile 
FOR EACH ROW BEGIN
	CALL getPaymentMethod(NEW.pnrLocator);
	UPDATE vtigercrm600.vtiger_localizadores	SET paymentmethod=@find_paymentmethod 	WHERE localizador 	LIKE CONCAT('%',NEW.pnrLocator,'%');
	UPDATE registro_boletos.boletos 			SET method_payment=@find_paymentmethod 	WHERE localizador 	LIKE CONCAT('%',NEW.pnrLocator,'%') AND sistemagds='Amadeus';
END |
DELIMITER ;