SELECT table_name AS "Tables", round( (
(
data_length + index_length
) /1024 /1024 ) , 2
) "Size in MB"
FROM information_schema.TABLES
WHERE table_schema = "osticket1911"
ORDER BY (
data_length + index_length
) DESC 