SELECT loc.localizadoresid, loc.localizador, loc.contactoid, loc.paymentmethod, loc.registrodeventasid, 
loc.procesado, loc.gds, bol.amount, bol.fecha_emision, bol.boleto1, bol.boletosid, bol.tipodevuelo, bol.status, 
bol.currency, usu.first_name, usu.last_name
FROM vtiger_localizadores AS loc  
INNER JOIN vtiger_boletos AS bol ON bol.localizadorid=loc.localizadoresid  
INNER JOIN vtiger_crmentity AS en ON en.crmid = loc.localizadoresid 
INNER JOIN vtiger_users AS usu ON usu.id = en.smownerid 
WHERE 
bol.boletosid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1 AND setype='Boletos') AND
loc.localizadoresid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1 AND setype='Localizadores') AND
bol.currency = 'VEF'  AND (loc.gds = 'Amadeus' OR loc.gds = 'Kiu' OR loc.gds = 'Web Aerolinea') 
  AND loc.localizador LIKE '%8SXOQG%'  
  UNION ALL (SELECT loc.localizadoresid, loc.localizador, loc.contactoid, loc.paymentmethod, loc.registrodeventasid, 
  	loc.procesado, loc.gds, bol.amount, bol.fecha_emision, bol.boleto1, bol.boletosid, bol.tipodevuelo, bol.status, 
  	bol.currency, usu.first_name, usu.last_name
  FROM vtiger_localizadores AS loc  
  INNER JOIN vtiger_boletos AS bol ON bol.localizadorid=loc.localizadoresid  
  INNER JOIN vtiger_crmentity AS en ON en.crmid = loc.localizadoresid  
  INNER JOIN vtiger_contactdetails AS con ON con.contactid = loc.contactoid  
  INNER JOIN vtiger_users AS usu ON usu.id = en.smownerid  
  WHERE 
bol.boletosid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1 AND setype='Boletos') AND
loc.localizadoresid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1 AND setype='Localizadores') AND
(loc.gds='Servi' OR loc.gds='Web Aerolinea')  
  AND loc.registrodeventasid IN (SELECT registrodeventasid FROM vtiger_registrodeventascf WHERE cf_881 != '' AND cf_861 != '')  AND loc.localizador LIKE '%8SXOQG%' )  ORDER BY fecha_emision DESC