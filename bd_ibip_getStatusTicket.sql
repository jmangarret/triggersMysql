DROP PROCEDURE IF EXISTS getStatusTicket;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `getStatusTicket`(
	IN nuevo_loc VARCHAR(20),
	IN ticket_number VARCHAR(20),
	IN emitted_status VARCHAR(20)
)
BEGIN
	SET @emittedStatus=emitted_status;
	IF (@emittedStatus IS NULL OR @emittedStatus='') THEN
		SET @emittedStatus=(SELECT DISTINCT emittedStatus FROM ifm_pnrairsegment WHERE ticketNumber=ticket_number LIMIT 1);
	END IF;
	
	SET @nuevo_loc=nuevo_loc;
	IF (@emittedStatus='Emitido') THEN
		SET @nuevo_loc=CONCAT(nuevo_loc,'(E)');
	END IF;
	IF (@emittedStatus='Anulado') THEN
		SET @nuevo_loc=CONCAT(nuevo_loc,'(A)');
	END IF;

	SET @reemision=(SELECT COUNT(*) FROM ifm_pnrticket WHERE ticketNumber=ticket_number AND originalTicketNumber NOT LIKE '');
	IF @reemision>0 THEN
		SET @emittedStatus='Reemitido';
		SET @nuevo_loc=CONCAT(nuevo_loc,'(R)');
	END IF;
END |
DELIMITER ;
