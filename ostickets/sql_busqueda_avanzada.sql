--QUERY OSTICKETS BUSQ AVAN.
SELECT ticket.ticket_id, ticket.staff_id, ticket.team_id, ticket.dept_id, cdata.subject FROM ost_ticket ticket 
LEFT JOIN ost_ticket_status status ON (status.id = ticket.status_id) 
LEFT JOIN ost_ticket__cdata cdata ON (cdata.ticket_id = ticket.ticket_id) 
WHERE ( (ticket.staff_id=1 AND status.state="open" ) OR (ticket.team_id IN (1 ) AND status.state="open" ) OR ticket.dept_id IN (1,2,3,4,6) ) 
AND ( ( status.state="open" AND ticket.staff_id=33) ) 
AND ticket.created>=FROM_UNIXTIME(1472704200) AND ticket.created<=FROM_UNIXTIME(1474086599) 
AND ((FIND_IN_SET(88, `subject`)))


--CRM REPORTE OSTICKETS DASHBOARD
SELECT tk.staff_id, CONCAT(firstname,' ',lastname) as name, 'Creados' as status, count(*) AS Total, status_id 
FROM osticket1911.ost_staff as st 
INNER JOIN osticket1911.ost_ticket AS tk ON tk.staff_id=st.staff_id 
INNER JOIN osticket1911.ost_ticket_status as ts ON tk.status_id=ts.id 
INNER JOIN osticket1911.ost_ticket__cdata as td ON tk.ticket_id=td.ticket_id 
WHERE tk.created between '2016-09-01 00:00' AND '2016-09-16 23:59' 
AND tk.staff_id=33 AND (td.subject = '88' OR td.subject='88,Cotizacion PopPup') GROUP BY staff_id