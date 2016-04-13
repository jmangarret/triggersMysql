<?php
include_once ('vtlib/Vtiger/Module.php');

 $Vtiger_Utils_Log = true;


        //Inicio Instanciacion del modulo Cuentas en el Parent Tab de Satelites

        $moduleInstance=Vtiger_Module::getInstance('Accounts');
        $moduleInstance->parent= 'Satelites';
        $moduleInstance->save();              

        $menuInstance = Vtiger_Menu::getInstance('Satelites');  
        $menuInstance->updateMenu($moduleInstance);	

        //Fin Instanciacion del modulo Cuentas en el Parent Tab de Satelites

        //Inicio Instanciacion del modulo Terminales en el Parent Tab de Satelites

        $moduleInstance=Vtiger_Module::getInstance('Terminales');
        $moduleInstance->parent= 'Satelites';
        $moduleInstance->save();              

        $menuInstance = Vtiger_Menu::getInstance('Satelites');  
        $menuInstance->updateMenu($moduleInstance); 

        //Fin Instanciacion del modulo Terminales en el Parent Tab de Satelites

        //Inicio Instanciacion del modulo Tipos de Comisiones en el Parent Tab de Satelites

        $moduleInstance=Vtiger_Module::getInstance('TiposdeComisiones');
        $moduleInstance->parent= 'Satelites';
        $moduleInstance->save();              

        $menuInstance = Vtiger_Menu::getInstance('Satelites');  
        $menuInstance->updateMenu($moduleInstance); 

        //Fin Instanciacion del modulo Tipos de Comisiones en el Parent Tab de Satelites


        //Inicio Instanciacion del modulo Comisiones Satelites en el Parent Tab de Satelites

        $moduleInstance=Vtiger_Module::getInstance('ComisionSatelites');
        $moduleInstance->parent= 'Satelites';
        $moduleInstance->save();              

        $menuInstance = Vtiger_Menu::getInstance('Satelites');  
        $menuInstance->updateMenu($moduleInstance); 		

        //Fin Instanciacion del modulo Comisiones Satelites en el Parent Tab de Satelites

        //Inicio Instanciacion del modulo Tarifas en el Parent Tab de Satelites

        $moduleInstance=Vtiger_Module::getInstance('Tarifas');
        $moduleInstance->parent= 'Satelites';
        $moduleInstance->save();              

        $menuInstance = Vtiger_Menu::getInstance('Satelites');  
        $menuInstance->updateMenu($moduleInstance);         

        //Fin Instanciacion del modulo Tarifas en el Parent Tab de Satelites


         echo "OK\n";



?>