/*----------------------------------------------------------------------------------------------------------------------*/
/*TRIGGER EN LA BASE DE DATOS DE "REGISTRO_BOLETOS"*/
DROP TRIGGER IF EXISTS setTicketId;
DELIMITER //
CREATE TRIGGER setTicketId
AFTER INSERT ON registro_boletos.boletos
FOR EACH ROW BEGIN
/*
DECLARE lastInsert INT;
SET lastInsert = 0;
SET lastInsert = (SELECT max(id) FROM registro_boletos.boletos);
*/
CALL vtigercrm600.setTickets(NEW.id);

END//
DELIMITER ;

/*---------------------------------------------------*/