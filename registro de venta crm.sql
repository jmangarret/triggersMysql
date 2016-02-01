update vtiger_crmentity_seq set id=LAST_INSERT_ID(id+1)

insert into vtiger_crmentity (crmid,smcreatorid,smownerid,setype,description,modifiedby,createdtime,modifiedtime) 
values(12691,'28','28','RegistroDeVentas',NULL,'28','2015-12-29 14:04:23','2015-12-29 14:04:23')

select * from vtiger_field where tabid='52' and tablename='vtiger_registrodeventas' and displaytype in (1,3,4) and vtiger_field.presence in (0,2)
select cur_id,prefix from vtiger_modentity_num where semodule='RegistroDeVentas' and active = 1
UPDATE vtiger_modentity_num SET cur_id='02708' where cur_id='02707' and active=1 AND semodule='RegistroDeVentas'
insert into vtiger_registrodeventas(registrodeventasid,registrodeventasname,registrodeventastype,fecha,contacto) values(12691,'VEN02707','Boleto',NULL,'466')
select * from vtiger_field where tabid='52' and tablename='vtiger_registrodeventascf' and displaytype in (1,3,4) and vtiger_field.presence in (0,2)
insert into vtiger_registrodeventascf
	(registrodeventasid,cf_1605,cf_1606,cf_1607,cf_1618,cf_1619,cf_1621,cf_1622,cf_1623,cf_1624,cf_1625,cf_1626,cf_1627,cf_825,cf_827,cf_828,cf_853,cf_854,cf_855,cf_856,cf_857,cf_858,cf_859,cf_860,cf_861,cf_862,cf_863,cf_864,cf_865,cf_866,cf_867,cf_871,cf_873,cf_874,cf_875,cf_876,cf_877,cf_878,cf_879,cf_880,cf_881) 
	values(12691,'','','','','','',0,'',0,'0','','observa','','',NULL,'','',0,0,'','','','','',0,0,0,'',0,0,'',0,0,0,0,0,0,'',0,'345')
UPDATE vtiger_crmentity SET label='VEN02707' WHERE crmid=12691
UPDATE vtiger_registrodeventascf SET cf_1621='Pendiente de Pago' where registrodeventasid = 12691