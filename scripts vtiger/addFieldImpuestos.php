<?php
ini_set('display_errors', true);
ini_set('error_reporting', E_ALL & ~E_NOTICE & ~E_DEPRECATED);
require_once('vtlib/Vtiger/Module.php');
include_once('vtlib/Vtiger/Utils.php');
include_once('vtlib/Vtiger/Menu.php');
require_once('vtlib/Vtiger/Block.php');
require_once('vtlib/Vtiger/Field.php');
$Vtiger_Utils_Log = true;
$module=Vtiger_Module::getInstance('Boletos');
$block = Vtiger_Block::getInstance('LBL_BLOCK_GENERAL_INFORMATION',$module);

$field0 = new Vtiger_Field();
$field0->name = 'yn_tax'; //Usually matches column name
$field0->table = 'vtiger_boletos';
$field0->column = 'yn_tax'; //Must be lower case
$field0->label = 'Impuesto YN'; //Upper case preceeded by LBL_
$field0->columntype = 'DOUBLE(8,2)'; //
$field0->uitype = 7; //Campo select Cuenta
$field0->typeofdata = 'N~O'; //V=Varchar?, M=Mandatory, O=Optional
$block->addField($field0);
$field0->setRelatedModules(Array('yn_tax'));

$field01=new Vtiger_Field();
$field01->label='Impuesto total';
$field01->name='total_tax';
$field01->table='vtiger_boletos';
$field01->column='total_tax';
$field01->columntype = 'DOUBLE(8,2)';
$field01->uitype = 7; //PICKLIST
$field01->typeofdata = 'N~O';
$block->addField($field01);



$block->save($module);
$module->initWebservice();
echo 'Code successfully executed';
?>