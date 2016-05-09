DROP PROCEDURE IF EXISTS getTypeComision;
DELIMITER |
CREATE DEFINER=`root`@`localhost`PROCEDURE `getTypeComision`(
IN _boletoid INT
)
BEGIN
DECLARE _contactoid INT;
DECLARE _accountid INT;
DECLARE _account_type VARCHAR(200);
DECLARE _tipodeformula VARCHAR(128);
DECLARE _tipodecomisionid INT;
DECLARE _sistemagds VARCHAR (255);
DECLARE _tipodevuelo VARCHAR (255);
DECLARE _base decimal(25,2);
DECLARE _montobase decimal(25,2);

SET max_sp_recursion_depth = 5; 

select b.tipodevuelo, b.monto_base, l.contactoid, l.gds, c.accountid, a.account_type
INTO _tipodevuelo, _montobase, _contactoid, _sistemagds, _accountid, _account_type
from vtiger_boletos as b inner join vtiger_localizadores as l on b.localizadorid=l.localizadoresid
inner join vtiger_contactdetails as c on c.contactid=l.contactoid
inner join vtiger_account as a on a.accountid=c.accountid
where b.boletosid=_boletoid LIMIT 1;

SELECT tiposdecomisionesid INTO _tipodecomisionid FROM vtiger_tiposdecomisiones
WHERE gds = _sistemagds AND tipousuario = _account_type AND tipodevuelo = _tipodevuelo AND tipotransaccion='Abono' LIMIT 1;

SELECT tipodeformula, base INTO _tipodeformula, _base FROM vtiger_comisionsatelites
WHERE tipodecomisionid = _tipodecomisionid AND accountid = _accountid LIMIT 1;

SET @tipodeformula=_tipodeformula;
SET @base=_base;
SET @montobase=_montobase;

END |
DELIMITER ;
