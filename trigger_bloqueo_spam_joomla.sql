DROP TRIGGER IF EXISTS bloqueo_spam;
DELIMITER | 
CREATE TRIGGER `bloqueo_spam` BEFORE INSERT ON `ost_ticket`
 FOR EACH ROW 
 BEGIN
   IF NEW.ip_address LIKE CONCAT('188.143.232.','%') THEN
    SET NEW.ticket_id=NULL;
    SET NEW.user_id=NULL;
    SET NEW.staff_id=NULL;
   END IF;
  END |
DELIMITER ;
