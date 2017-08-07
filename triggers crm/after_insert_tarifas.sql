/*trigger que inserta en la tabla historica (vtiger_tarifas_historico) una vez se ha ingresado en la tabla vtiger_tarifas*/
DROP TRIGGER IF EXISTS `after_insert_tarifas`;
DELIMITER |
CREATE TRIGGER after_insert_tarifas AFTER INSERT ON vtiger_tarifas
  FOR EACH ROW BEGIN 
		INSERT INTO vtiger_tarifas_historico SET tarifasid = new.tarifasid, fecha= CURRENT_DATE, valor= new.valor_base ;
  	END;|
DELIMITER ;
  	
/*trigger que inserta en la tabla historica (vtiger_tarifas_historico) una vez se ha modificado en la tabla vtiger_tarifas*/
DROP TRIGGER IF EXISTS `after_update_tarifas`;
DELIMITER |
CREATE TRIGGER after_update_tarifas AFTER UPDATE ON vtiger_tarifas
  FOR EACH ROW BEGIN 
		UPDATE vtiger_tarifas_historico SET tarifasid = old.tarifasid, fecha= CURRENT_DATE, valor= new.valor_base WHERE tarifasid=old.tarifasid;
  	END;|
DELIMITER ;