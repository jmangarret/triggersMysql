<?php
include_once("../config.inc.php");
$user=$dbconfig['db_username'];
$pass=$dbconfig['db_password'];
$bd=$dbconfig['db_name'];
mysql_connect("localhost",$user,$pass);
mysql_select_db($bd);
//ASOCIAR BOLETOS DESLIGADOS
$eli="SELECT localizadoresid 
from vtiger_localizadores as c 
inner join vtiger_crmentity as e ON c.localizadoresid=e.crmid 
where createdtime like '%2016-10%' 
AND gds IN ('Amadeus','Kiu') 
AND e.deleted=1 ";

$sql="SELECT boletosid, localizadorid, boleto1
from vtiger_boletos as b
inner join vtiger_crmentity as e ON b.boletosid=e.crmid 
where createdtime like '%2016-10%' 
AND e.deleted=0 
AND localizadorid IN 
	(SELECT localizadoresid 
	from vtiger_localizadores as c 
	inner join vtiger_crmentity as e ON c.localizadoresid=e.crmid 
	where createdtime like '%2016-10%' 
	AND gds IN ('Amadeus','Kiu') 
	AND e.deleted=1)
";
//BUSCAR LOC DEL LOCID ELIMINADO Y CONSULTAR EL LOC NO ELIMINADO PARA SACAR EL IDLOC QUE QUEDO


//FIN ASOCIAR BOLETOS DESLIGADOS


$sql="SELECT localizadoresid, localizador, gds, createdtime, registrodeventasid 
from vtiger_localizadores as c 
inner join vtiger_crmentity as e ON c.localizadoresid=e.crmid 
where createdtime like '%2016-10%' 
AND gds IN ('Amadeus','Kiu') 
AND e.deleted=0 
order by localizadoresid ASC";
$qry=mysql_query($sql);
$r1=mysql_fetch_row($qry);
$idini=$r1[0];
$loini=$r1[1];

while ($r=mysql_fetch_row($qry)){
	$idact=$r[0];
	$loact=$r[1];
	$idvta=$r[4];
	if ($loini==$loact){
		$upd="UPDATE vtiger_crmentity set deleted=1,modifiedtime='2016-11-07 16:33:55',modifiedby='28' where crmid='$idact'";		
		mysql_query($upd);		
		$ult="SELECT MAX(id) FROM vtiger_modtracker_basic";
		$qul=mysql_query($ult);
		$idm=mysql_result($qul, 0);
		$idm=$idm+1;
		$aud=" INSERT INTO vtiger_modtracker_basic(id, crmid, module, whodid, changedon, status) ";
		$aud.="VALUES($idm,'$idact','Localizadores','28','2016-11-07 16:33:55','1')";
		mysql_query($aud);
		$aud="update vtiger_modtracker_basic_seq set id=LAST_INSERT_ID(id+1)";
		mysql_query($aud);

		$upd="UPDATE vtiger_crmentity set deleted=1,modifiedtime='2016-11-07 16:33:55',modifiedby='28' where crmid='$idvta'";		
		mysql_query($upd);		
		$ult="SELECT MAX(id) FROM vtiger_modtracker_basic";
		$qul=mysql_query($ult);
		$idm=mysql_result($qul, 0);		
		$idm=$idm+1;
		$aud=" INSERT INTO vtiger_modtracker_basic(id, crmid, module, whodid, changedon, status) ";
		$aud.="VALUES($idm,'$idvta','RegistroDeVentas','28','2016-11-07 16:33:55','1')";		
		mysql_query($aud);
		$aud="update vtiger_modtracker_basic_seq set id=LAST_INSERT_ID(id+1)";
		mysql_query($aud);

		echo "<li>DELETE: ".$idact." - ".$loact. " - ". $idvta. " - Tracker: ".$idm;		
	}else{
		$loini=$r[1];
		echo "<strong><p>No Borrado: ".$idact." - ".$loact." - ".$idvta."</p></strong>";
		continue;
	}	
}

?>