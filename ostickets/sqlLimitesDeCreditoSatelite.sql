SELECT date, disponible FROM osticket1911.ost_auditoria_limite_credito AS aud
INNER JOIN ost_organization AS org ON aud.org_id=org.id
WHERE org.name LIKE '%KALISCAPE%' 
ORDER BY aud.id DESC