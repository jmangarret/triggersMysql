<?php
$currentUser = vglobal('current_user');
//echo "<pre>";
//print_r($currentUser);

$methods = array();
foreach (get_class_methods($currentUser) as $method) {    
        $methods[] = $method;    
}
//print_r($methods);
$role=		$currentUser->column_fields["roleid"];
$accountid=	$currentUser->column_fields["accountid"];
$roleinfo=	getRoleInformation($role);
$depth=		$roleinfo[$role][2]; //Nivel o Profundidad del Role 5=Satelites, 4=Sales Person

?>