update vtiger_crmentity_seq set id=LAST_INSERT_ID(id+1)

insert into vtiger_crmentity (crmid,smcreatorid,smownerid,setype,description,modifiedby,createdtime,modifiedtime)
	values(12694,'28','28','ComisionSatelites',NULL,'28','2016-01-18 15:00:05','2016-01-18 15:00:05')
	
select * from vtiger_field where tabid='67' and tablename='vtiger_comisionsatelites' and displaytype in (1,3,4) and vtiger_field.presence in (0,2)
insert into vtiger_comisionsatelites(comisionsatelitesid,accountid,tipodecomisionid,tipodeformula,base,activa) values(12694,'11043','12682','Porcentaje','3','1')
select * from vtiger_field where tabid='67' and tablename='vtiger_comisionsatelitescf' and displaytype in (1,3,4) and vtiger_field.presence in (0,2)
insert into vtiger_comisionsatelitescf(comisionsatelitesid) values(12694)
UPDATE vtiger_crmentity SET label='11043' WHERE crmid=12694