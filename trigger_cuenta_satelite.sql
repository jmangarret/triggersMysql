DROP TRIGGER IF EXISTS after_insert_account;
DELIMITER |
CREATE TRIGGER after_insert_account AFTER INSERT ON vtiger_account 
FOR EACH ROW BEGIN
	IF (NEW.account_type="Satelite") THEN
		UPDATE vtiger_contactdetails SET isSatelite=1 WHERE accountid=NEW.accountid;
	END IF;
END |
DELIMITER ;

DROP TRIGGER IF EXISTS after_update_account;
DELIMITER |
CREATE TRIGGER after_update_account AFTER UPDATE ON vtiger_account 
FOR EACH ROW BEGIN
	IF (NEW.account_type="Satelite") THEN
		UPDATE vtiger_contactdetails SET isSatelite=1 WHERE accountid=NEW.accountid;
	END IF;
END |
DELIMITER ;

DROP TRIGGER IF EXISTS before_update_contact;
DELIMITER |
CREATE TRIGGER before_update_contact BEFORE UPDATE ON vtiger_contactdetails 
FOR EACH ROW BEGIN
	DECLARE accountType VARCHAR(100);
	IF (NEW.accountid IS NOT NULL) THEN
		SET accountType=(SELECT account_type FROM vtiger_account WHERE accountid=NEW.accountid);
		IF (accountType="Satelite") THEN
			SET NEW.isSatelite=1;
		END IF;
	END IF;
END |
DELIMITER ;