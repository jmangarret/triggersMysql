<?php
include_once ('vtlib/Vtiger/Module.php');

 $Vtiger_Utils_Log = true;

        //Inicio Instanciacion del modulo Terminales en el Parent Tab de Agencia

        $moduleInstance=Vtiger_Module::getInstance('Localizadores');
        $moduleInstance->parent= 'Agencia';
        $moduleInstance->save();              

        $menuInstance = Vtiger_Menu::getInstance('Agencia');  
        $menuInstance->updateMenu($moduleInstance); 

        //Fin Instanciacion del modulo Terminales en el Parent Tab de Agencia


        //Inicio Instanciacion del modulo Cuentas en el Parent Tab de Agencia

        $moduleInstance=Vtiger_Module::getInstance('Boletos');
        $moduleInstance->parent= 'Agencia';
        $moduleInstance->save();              

        $menuInstance = Vtiger_Menu::getInstance('Agencia');  
        $menuInstance->updateMenu($moduleInstance); 

        //Fin Instanciacion del modulo Cuentas en el Parent Tab de Agencia
        //Inicio Instanciacion del modulo Tipos de Comisiones en el Parent Tab de Agencia

        $moduleInstance=Vtiger_Module::getInstance('RegistroDeVentas');
        $moduleInstance->parent= 'Agencia';
        $moduleInstance->save();              

        $menuInstance = Vtiger_Menu::getInstance('Agencia');  
        $menuInstance->updateMenu($moduleInstance); 

        //Fin Instanciacion del modulo Tipos de Comisiones en el Parent Tab de Agencia


        //Inicio Instanciacion del modulo Comisiones Agencia en el Parent Tab de Agencia

        $moduleInstance=Vtiger_Module::getInstance('RegistroDePagos');
        $moduleInstance->parent= 'Agencia';
        $moduleInstance->save();              

        $menuInstance = Vtiger_Menu::getInstance('Agencia');  
        $menuInstance->updateMenu($moduleInstance); 		

        //Fin Instanciacion del modulo Comisiones Agencia en el Parent Tab de Agencia

        //Inicio Instanciacion del modulo Tarifas en el Parent Tab de Agencia

        $moduleInstance=Vtiger_Module::getInstance('VentaDeProductos');
        $moduleInstance->parent= 'Agencia';
        $moduleInstance->save();              

        $menuInstance = Vtiger_Menu::getInstance('Agencia');  
        $menuInstance->updateMenu($moduleInstance);         

        //Fin Instanciacion del modulo Tarifas en el Parent Tab de Agencia

        //Inicio Instanciacion del modulo Tarifas en el Parent Tab de Agencia

        $moduleInstance=Vtiger_Module::getInstance('Envios');
        $moduleInstance->parent= 'Agencia';
        $moduleInstance->save();              

        $menuInstance = Vtiger_Menu::getInstance('Agencia');  
        $menuInstance->updateMenu($moduleInstance);         

        //Fin Instanciacion del modulo Tarifas en el Parent Tab de Agencia


         echo "OK\n";



?>