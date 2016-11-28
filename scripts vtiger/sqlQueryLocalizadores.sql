--Localizadores duplicados
SELECT localizadoresid, localizador, gds, createdtime 
from vtiger_localizadores as c 
inner join vtiger_crmentity as e ON c.localizadoresid=e.crmid 
where createdtime like '%2016-10%' AND gds IN ('Amadeus','Kiu')		
AND registrodeventasid<1

--Agrupado
SELECT COUNT(localizador) as tot, localizador, gds
from vtiger_localizadores as c 
inner join vtiger_crmentity as e ON c.localizadoresid=e.crmid 
where createdtime like '%2016-10%' AND gds IN ('Amadeus','Kiu')
AND registrodeventasid<1
GROUP BY localizador ORDER BY tot DESC



--Localizadores con firma Adriana
SELECT localizadoresid,localizador, first_name, referencia as firma, createdtime 
from vtiger_localizadores as c 
inner join vtiger_crmentity as e ON c.localizadoresid=e.crmid 
inner join vtiger_users as u ON u.id=e.smownerid
where e.deleted=0 AND createdtime like '%2016%' AND referencia='0192BGSU'  
		AND smownerid=25 AND gds IN ('Amadeus','Kiu')	