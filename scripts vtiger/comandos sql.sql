GRANT ALL PRIVILEGES ON osticket1911.* TO 'osticket'@'localhost';

CREATE USER 'osticket'@'localhost' IDENTIFIED BY '0571ck37';

SHOW GRANTS FOR osticket@localhost;


GRANT ALL PRIVILEGES ON osticket1911.* To 'osticket'@'localhost' IDENTIFIED BY '0571ck37';

mysqldump -u root -p --opt --where="1 limit 1000" osticket1911 ost_file_chunk > ost_file_chunk.sql

yelow #FAF250
blue #0F64B4


