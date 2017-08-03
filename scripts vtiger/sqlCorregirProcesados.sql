UPDATE vtiger_localizadores SET procesado=0 WHERE procesado=1 AND registrodeventasid<1;

UPDATE vtiger_localizadores SET procesado=0 WHERE procesado=1 AND registrodeventasid IS NULL;

UPDATE vtiger_localizadores SET procesado=1 WHERE registrodeventasid>0;