SELECT loc.localizadoresid,
			loc.localizador,
			loc.contactoid, 
			loc.paymentmethod,
			loc.registrodeventasid,
			loc.procesado,
			loc.gds, 
			bol.amount,
			bol.fecha_emision,
			bol.boleto1,
			bol.status,
			bol.boletosid,
			bol.tipodevuelo,
			usu.first_name,
			usu.last_name
			FROM vtiger_localizadores AS loc 
			INNER JOIN vtiger_boletos AS bol ON bol.localizadorid=loc.localizadoresid 
			INNER JOIN vtiger_crmentity AS en ON en.crmid = loc.localizadoresid 
			INNER JOIN vtiger_crmentityrel as r ON en.crmid = r.crmid 
					INNER JOIN vtiger_users AS usu ON usu.id = en.smownerid
			WHERE en.deleted=0 AND bol.status != 'Anulado'
			AND loc.localizador LIKE '6ZHW4Z%'