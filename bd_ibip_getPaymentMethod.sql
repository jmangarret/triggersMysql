DROP PROCEDURE IF EXISTS getPaymentMethod;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPaymentMethod`(
IN find_id_loc VARCHAR(20)
)
BEGIN
DECLARE n_paymentmethod INT;

SET n_paymentmethod=(SELECT COUNT(*) FROM ifm_dbstoredgdsfile WHERE pnrLocator=find_id_loc AND content like '%FPCASH%' and  `content` like '%FPCC%');
IF (n_paymentmethod>0) THEN
	SET @find_paymentmethod="Mixto";
ELSE
	SET n_paymentmethod=(SELECT COUNT(*) FROM ifm_dbstoredgdsfile WHERE pnrLocator=find_id_loc AND content like '%FPCASH%');
	IF (n_paymentmethod>0) THEN
		SET @find_paymentmethod="Efectivo";	
	ELSE
		SET n_paymentmethod=(SELECT COUNT(*) FROM ifm_dbstoredgdsfile WHERE pnrLocator=find_id_loc AND content like '%FPCC%');
		IF (n_paymentmethod>0) THEN
			SET @find_paymentmethod="Credito";	
		END IF;		
	END IF;	
END IF;
END |
DELIMITER ;
