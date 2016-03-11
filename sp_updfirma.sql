DROP PROCEDURE IF EXISTS updfirma;# MySQL ha devuelto un conjunto de valores vacío (es decir: cero columnas).

DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `updfirma`(
	IN _firma VARCHAR(200),
	IN _status INT
	)
BEGIN 
	UPDATE vtiger_terminales SET asignada=_status WHERE firma=_firma;
	UPDATE vtiger_firma SET status=_status WHERE firma=_firma;			    
    SET @f=_firma;
END |

DELIMITER ;