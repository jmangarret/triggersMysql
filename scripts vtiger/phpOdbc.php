<?php 

$db = odbc_connect("DRIVER={DBISAM 4 ODBC Driver}; ConnectionType=Local; CatalogName=C:/direccion donde estan guardadas las tablas/Data;","admin","");
$res = odbc_exec($db,"SELECT * FROM Sinventario");
echo odbc_num_rows($res)." rows found";
while($row = odbc_fetch_array($res)) {
    print_r($row);
}


$db = odbc_connect("DRIVER={DBISAM 4 ODBC Driver};ConnectionType=Local;CatalogName=C:/...../Data;","a2server",""); 
$res = odbc_exec($db," CONSULTA SELECT ");

 ?>