mysqldump -u root -p osticket1911 --ignore-table osticket1911.ost_file_chunk > ostickets16ene.sql


mysqldump -u root -p --opt --where="1 limit 100" osticket1911 ost_file_chunk > ost_file_chunk.min.sql