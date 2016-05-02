DROP TRIGGER IF EXISTS crm_update;
DELIMITER |
CREATE TRIGGER crm_update AFTER UPDATE ON ost_ticket
FOR EACH ROW BEGIN  
	DECLARE loc		VARCHAR(20);
	DECLARE ticket 	VARCHAR(20);
	DECLARE sistema	VARCHAR(50);
	DECLARE usuario	VARCHAR(50);
	DECLARE fpago 	VARCHAR(50);
	DECLARE sol 	VARCHAR(100);
	DECLARE rif 	VARCHAR(20);
	DECLARE org 	VARCHAR(200);
	DECLARE fech 	VARCHAR(20);
	DECLARE loc_status VARCHAR(50);
	DECLARE ced_user VARCHAR(20);
	DECLARE ced_ase VARCHAR(20); 
	DECLARE idloc INT;
	DECLARE idcta INT;
	SET loc_status=(SELECT CAST(status_loc as char(100) charset utf8) FROM ost_ticket__cdata WHERE ticket_id=NEW.ticket_id);
	IF (NEW.status_id=3 AND loc_status="Emitido") THEN
	SET loc = (SELECT localizador FROM ost_crm WHERE ticket_id = NEW.ticket_id);
	SELECT 
	localizador,ticket_number,gds,paymentmethod,solicitud,org_rif,org_name,asesor_rif,user_ci,user_name,ticket_creado,localizador_status	
	INTO loc,ticket,sistema,fpago,sol,rif,org,ced_ase,ced_user,usuario,fech,loc_status 
	FROM ost_crm WHERE ticket_id = NEW.ticket_id;
	CALL vtigercrm600.getCrmId(); #Devuelve @idcrm
	CALL vtigercrm600.getCrmUser(ced_ase); #Devuelve @iduser
	CALL vtigercrm600.valCuenta(rif,org,"SATELITE",fech,@idcrm,@iduser);#Devuelve @id_cuenta
	CALL vtigercrm600.valContacto(ced_user,usuario,fech,@id_cuenta,@idcrm,@iduser); #Devuelve @id_contacto
	SELECT localizadoresid INTO idloc FROM vtigercrm600.vtiger_localizadores WHERE nroticket=ticket;
	IF idloc>0 THEN
		UPDATE vtigercrm600.vtiger_localizadores 
		SET localizador=loc,sistemagds=sistema,paymentmethod=fpago,solicitud=sol,contacto_id=@id_contacto,status=loc_status
		WHERE localizadoresid=idloc;  			
	ELSE
		INSERT INTO vtigercrm600.vtiger_localizadores (localizadoresid,localizador,nroticket,contacto_id,sistemagds,paymentmethod, solicitud) 
		VALUES (@idcrm,loc,ticket,@id_contacto,sistema,fpago, sol); 
		IF (ROW_COUNT()>0) THEN 
			CALL vtigercrm600.getCrmId();	#Devuelva @idcrm
			CALL vtigercrm600.setCrmEntity("Localizadores",loc,fech,@idcrm,@iduser);
			INSERT INTO vtigercrm600.vtiger_localizadorescf(localizadoresid) VALUES(@idcrm);					
		END IF;
	END IF;
	END IF;
END |
DELIMITER ;