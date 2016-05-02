<?php
ini_set('display_errors', true);
ini_set('error_reporting', E_ALL & ~E_NOTICE & ~E_DEPRECATED);
require_once('vtlib/Vtiger/Module.php');
include_once('vtlib/Vtiger/Utils.php');
include_once('vtlib/Vtiger/Menu.php');
require_once('vtlib/Vtiger/Block.php');
require_once('vtlib/Vtiger/Field.php');
$Vtiger_Utils_Log = true;
$users=Vtiger_Module::getInstance('Terminales');
$block = Vtiger_Block::getInstance('Información General',$users);

$fieldInstance = new Vtiger_Field();
$fieldInstance->name = 'usercontactoid'; //Usually matches column name
$fieldInstance->table = 'vtiger_terminales';
$fieldInstance->column = 'usercontactoid'; //Must be lower case
$fieldInstance->label = 'Agente/Satélite Asociado'; //Upper case preceeded by LBL_
$fieldInstance->columntype = 'INT'; //
$fieldInstance->uitype = 10; //Campo check
$fieldInstance->typeofdata = 'V~O'; //V=Varchar?, M=Mandatory, O=Optional
$block->addField($fieldInstance);
$fieldInstance->setRelatedModules(Array('Contacts','Users'));


$block->save($users);
$users->initWebservice();
echo 'Code successfully executed';
?>
