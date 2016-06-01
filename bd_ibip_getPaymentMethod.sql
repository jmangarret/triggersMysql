DROP PROCEDURE IF EXISTS getPaymentMethod;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPaymentMethod`(
IN find_id_loc VARCHAR(20)
)
BEGIN
DECLARE n_paymentmethod INT;

SET n_paymentmethod=(SELECT COUNT(*) FROM ifm_dbstoredgdsfile WHERE pnrLocator=find_id_loc AND content LIKE '%FPCASH%' AND  `content` LIKE '%FPCC%');
IF (n_paymentmethod>0) THEN
	SET @find_paymentmethod="Mixto";
ELSE
	SET n_paymentmethod=(SELECT COUNT(*) FROM ifm_dbstoredgdsfile WHERE pnrLocator=find_id_loc AND content LIKE '%FPCASH%');
	IF (n_paymentmethod>0) THEN
		SET @find_paymentmethod="Efectivo";	
	ELSE
		SET n_paymentmethod=(SELECT COUNT(*) FROM ifm_dbstoredgdsfile WHERE pnrLocator=find_id_loc AND content LIKE '%FPCC%');
		IF (n_paymentmethod>0) THEN
			SET @find_paymentmethod="Credito";	
		END IF;		
	END IF;	
END IF;
SET n_paymentmethod=(SELECT COUNT(*) FROM ifm_dbstoredgdsfile WHERE pnrLocator=find_id_loc AND content LIKE '%FPCCAX%' OR  `content` LIKE '%FPAX%');
IF (n_paymentmethod>0) THEN
	SET @find_paymentmethod="American Express";
END IF;
SET n_paymentmethod=(SELECT COUNT(*) FROM ifm_dbstoredgdsfile WHERE pnrLocator=find_id_loc AND content LIKE '%FPCASH+CC%');
IF (n_paymentmethod>0) THEN
	SET @find_paymentmethod="Mixto";
END IF;
END |
DELIMITER ;
