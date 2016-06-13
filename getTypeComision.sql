DROP PROCEDURE IF EXISTS getTypeComision;
DELIMITER |
CREATE DEFINER=`root`@`localhost`PROCEDURE `getTypeComision`(
IN _boletoid INT,
IN _tipodevuelo VARCHAR(100)
)
BEGIN
DECLARE _contactoid INT;
DECLARE _accountid INT;
DECLARE _account_type VARCHAR(200);
DECLARE _tipodeformula VARCHAR(128);
DECLARE _status VARCHAR(128);
DECLARE _tipodecomisionid INT;
DECLARE _sistemagds VARCHAR (255);
DECLARE _base decimal(25,2);
DECLARE _montobase decimal(25,2);

SET max_sp_recursion_depth = 5; 

select b.monto_base, l.contactoid, l.gds, c.accountid, a.account_type, b.status
	INTO _montobase, _contactoid, _sistemagds, _accountid, _account_type, _status
	from vtiger_boletos as b inner join vtiger_localizadores as l on b.localizadorid=l.localizadoresid
	inner join vtiger_contactdetails as c on c.contactid=l.contactoid
	inner join vtiger_account as a on a.accountid=c.accountid
	where b.boletosid=_boletoid LIMIT 1;
/*CALCULAMOS COMISION A PAGAR AL SATELITE*/
SELECT tiposdecomisionesid INTO _tipodecomisionid FROM vtiger_tiposdecomisiones
	WHERE gds = _sistemagds AND tipousuario = _account_type AND tipodevuelo = _tipodevuelo AND tipotransaccion='Abono' LIMIT 1;
SELECT tipodeformula, base INTO _tipodeformula, _base FROM vtiger_comisionsatelites
	WHERE tipodecomisionid = _tipodecomisionid AND accountid = _accountid LIMIT 1;
SET @tipodeformula=_tipodeformula;
SET @base=_base;
SET @montobase=_montobase;

/*IF PARA VALIDAR SI EL STATUS DEL BOLETO ES EMITIDO, PARA SABER QUE FEE DE CARGO COBRAR AL SATELITE */
IF (_status="Emitido") THEN
	/*CALCULAMOS FEE DE EMISION A COBRAR AL SATELITE*/
	SELECT tiposdecomisionesid INTO _tipodecomisionid FROM vtiger_tiposdecomisiones
		WHERE gds = _sistemagds AND tipousuario = _account_type AND tipodevuelo = _tipodevuelo AND tipotransaccion='Cargo' LIMIT 1;
	SELECT tipodeformula, base INTO _tipodeformula, _base FROM vtiger_comisionsatelites
		WHERE tipodecomisionid = _tipodecomisionid AND accountid = _accountid LIMIT 1;
	SET @tipodeformula_fee=_tipodeformula;
	SET @base_fee=_base;
	SET @montobase_fee=_montobase;
END IF;

/*EN CASO DE REEMITIDOS Y ANULACIONES EL FEE A COBRAR (CARGO) SE TOMA DEL MODULO TARIFAS Y SE ALMACENA EN EL CAMPO FEE AGENCIA (FEE SATELITE QUEDA OBSOLETO)*/
END |
DELIMITER ;
