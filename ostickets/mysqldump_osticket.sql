mysqldump -u root -p osticket1911 --ignore-table osticket1911.ost_file_chunk > ostickets16ene.sql


mysqldump -u root -p --opt --where="1 limit 100" osticket1911 ost_file_chunk > ost_file_chunk.min.sql

CHANGE MASTER TO

MASTER_LOG_FILE='mysql-bin.000009',
MASTER_LOG_POS=107;

STOP SLAVE;
CHANGE MASTER TO
MASTER_HOST='192.168.1.3';
START SLAVE;
SHOW SLAVE STATUS\G

GRANT REPLICATION SLAVE ON *.* TO admindb@192.168.1.7 IDENTIFIED BY 'admindb24';

git config --global user.name "DEV"
 git config --global user.email tuagencia.sistemas01@gmail.com


