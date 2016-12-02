--- El crmid es il idrecord del modulo
UPDATE vtiger_crmentity SET 
	createdtime='2016-10-08 09:47:49' 
	WHERE crmid=22366 AND setype='RegistroDeVentas';

---ID DIANA 31
UPDATE vtiger_crmentity SET 
	smownerid=20
	WHERE crmid=22366 AND setype='RegistroDeVentas';

--Boeltos por Localizador alteran el totalLoc
SELECT * FROM vtiger_boletos WHERE localizadorid=32213;

