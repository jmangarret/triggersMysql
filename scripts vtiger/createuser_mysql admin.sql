GRANT ALL PRIVILEGES ON vtigercrm600.* TO 'vtigercrm'@'localhost' IDENTIFIED BY 'AvzHricg4ejxA' WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON osticket1911.* TO 'osticket'@'localhost' IDENTIFIED BY '0571ck37' WITH GRANT OPTION;


usuario joomla treavi

CREATE USER 'joomla'@'%' IDENTIFIED BY '***';
GRANT ALL PRIVILEGES ON *.* TO 'joomla'@'%' IDENTIFIED BY '***' 
WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
GRANT ALL PRIVILEGES ON `motores`.* TO 'joomla'@'%';

usuario admin tuagencia24.com para motores
CREATE USER 'admin'@'%' IDENTIFIED BY 'admin24';
GRANT ALL PRIVILEGES ON motores.* TO 'admin'@'%'; ///////IDENTIFIED BY 'admin24';


Usuarios FTP
useradd -d /var/www/vhosts -g ftp -s /bin/false userprod