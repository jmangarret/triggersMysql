SELECT accountname, email1, email, l.localizador, gds, passenger, itinerario, boleto1, fecha_emision, amount, currency, b.status
FROM vtiger_account as a 
	INNER JOIN vtiger_contactdetails as c ON a.accountid=c.accountid
		INNER JOIN vtiger_localizadores as l ON l.contactoid=c.contactid
			AND localizadoresid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1 AND setype='Localizadores') 
		INNER JOIN vtiger_boletos as b ON b.localizadorid=l.localizadoresid 
			AND boletosid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1 AND setype='Boletos')
	WHERE a.account_type='Satelite' OR a.account_type LIKE '%Freelance%'
ORDER BY accountname