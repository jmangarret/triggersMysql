SELECT localizadoresid, localizador, count(localizador) AS tot 
	FROM vtiger_localizadores 
	WHERE localizadoresid<=45676
	GROUP BY localizador 
	HAVING tot>1 ORDER BY localizadoresid DESC




WHILE
	SELECT localizadoresid 
	FROM vtiger_localizadores 
	WHERE  localizador=loc

	WHILE
/*QUERY FILTRO LOCALIZADORES */

	SELECT loc.localizadoresid, loc.localizador, loc.contactoid, loc.paymentmethod, loc.registrodeventasid, 
			loc.procesado, loc.gds, bol.amount, bol.fecha_emision, bol.boleto1, bol.boletosid, bol.tipodevuelo, bol.status, bol.currency, usu.first_name, usu.last_name 
		FROM vtiger_localizadores AS loc INNER JOIN vtiger_boletos AS bol ON bol.localizadorid=loc.localizadoresid 
		INNER JOIN vtiger_crmentity AS en ON en.crmid = loc.localizadoresid 
		LEFT JOIN vtiger_registrodeventas AS rdv ON rdv.registrodeventasid=loc.registrodeventasid 
		INNER JOIN vtiger_contactdetails AS con ON con.contactid = loc.contactoid 
		INNER JOIN vtiger_account AS acc ON acc.accountid = con.accountid 
		INNER JOIN vtiger_users AS usu ON usu.id = en.smownerid 
		WHERE 
		bol.boletosid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1 AND setype='Boletos') 
			AND loc.localizadoresid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1 AND setype='Localizadores') 
			AND bol.currency = 'VEF' AND (loc.gds = 'Amadeus' OR loc.gds = 'Kiu' OR loc.gds = 'Web Aerolinea') 
			AND acc.accountid= '42036' 
	UNION ALL (SELECT loc.localizadoresid, loc.localizador, loc.contactoid, loc.paymentmethod, loc.registrodeventasid, 
			loc.procesado, loc.gds, bol.amount, bol.fecha_emision, bol.boleto1, bol.boletosid, bol.tipodevuelo, bol.status, bol.currency, usu.first_name, usu.last_name 
		FROM vtiger_localizadores AS loc INNER JOIN vtiger_boletos AS bol ON bol.localizadorid=loc.localizadoresid 
		INNER JOIN vtiger_registrodeventas AS rdv ON rdv.registrodeventasid=loc.registrodeventasid 
		INNER JOIN vtiger_crmentity AS en ON en.crmid = loc.localizadoresid 
		INNER JOIN vtiger_contactdetails AS con ON con.contactid = loc.contactoid 
		INNER JOIN vtiger_account AS acc ON acc.accountid = con.accountid 
		INNER JOIN vtiger_users AS usu ON usu.id = en.smownerid 
		WHERE 
		bol.boletosid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1 AND setype='Boletos') 
		AND loc.localizadoresid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1 AND setype='Localizadores') 
		AND (loc.gds='Servi' OR loc.gds='Web Aerolinea' OR loc.gds='Percorsi' OR loc.gds='Kiu Internacional') 
		AND loc.registrodeventasid IN (SELECT registrodeventasid FROM vtiger_registrodeventascf WHERE cf_861 != '') 
		AND loc.registrodeventasid IN (SELECT DISTINCT registrodeventasid FROM vtiger_registrodepagos) AND acc.accountid= '42036' ) 
ORDER BY fecha_emision DESC