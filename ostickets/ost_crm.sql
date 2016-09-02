CREATE VIEW ost_crm AS
SELECT
    a.ticket_id,
    a.number as ticket_number,
    a.status_id as ticket_status_id,
    (SELECT 
        b.name 
     FROM
        ost_ticket_status b
     WHERE
        a.status_id = b.id) as ticket_status,
    a.created as ticket_creado,
    (SELECT 
        b.org_id
    FROM 
        ost_user b
    WHERE 
        a.user_id = b.id) as org_id,
    (SELECT 
        c.name
    FROM 
        ost_user b,
        ost_organization c
    WHERE 
        a.user_id = b.id AND
        c.id = b.org_id) as org_name,
    (SELECT 
        d.value
    FROM 
        ost_user b,
        ost_form_entry c,
        ost_form_entry_values d
    WHERE 
        a.user_id = b.id AND
        c.object_type = 'O' AND
        b.org_id = c.object_id AND
        d.entry_id = c.id AND 
        d.field_id = 87
    GROUP BY
        d.value) as org_rif,
    a.user_id,
    (SELECT 
        d.value
    FROM
        ost_user b,
        ost_form_entry c,
        ost_form_entry_values d
    WHERE 
        a.user_id = b.id AND
        c.object_type = 'U' AND
        b.org_id = c.object_id AND
        d.entry_id = c.id AND 
        d.field_id = 88
    GROUP BY
        d.value) as user_ci,
    CAST(e.localizador AS char(100) CHARACTER SET utf8) as localizador,
    CAST(e.status_loc AS char(100) CHARACTER SET utf8) as localizador_status,
    a.staff_id as asesor_id,
    CONCAT(f.firstname, ' ',f.lastname) as asesor,
    SUBSTRING(CAST(e.gds AS char(100) CHARACTER SET utf8),1,LOCATE(",",CAST(e.gds AS char(100) CHARACTER SET utf8)) - 1) as gds_id,    
    SUBSTRING(CAST(e.gds AS char(100) CHARACTER SET utf8),LOCATE(",",CAST(e.gds AS char(100) CHARACTER SET utf8)) + 1,LENGTH(CAST(e.gds AS char(100) CHARACTER SET utf8))) as gds,
    SUBSTRING(CAST(e.subject AS char(100) CHARACTER SET utf8),1,LOCATE(",",CAST(e.subject AS char(100) CHARACTER SET utf8)) - 1) as solicitud_id,
    SUBSTRING(CAST(e.subject AS char(100) CHARACTER SET utf8),LOCATE(",",CAST(e.subject AS char(100) CHARACTER SET utf8)) + 1,LENGTH(CAST(e.subject AS char(100) CHARACTER SET utf8))) as solicitud,
    SUBSTRING(CAST(e.paymentmethod AS char(100) CHARACTER SET utf8),1,LOCATE(",",CAST(e.paymentmethod AS char(100) CHARACTER SET utf8)) - 1) as paymentmethod_id,
    SUBSTRING(CAST(e.paymentmethod AS char(100) CHARACTER SET utf8),LOCATE(",",CAST(e.paymentmethod AS char(100) CHARACTER SET utf8)) + 1,LENGTH(CAST(e.paymentmethod AS char(100) CHARACTER SET utf8))) as paymentmethod,
    CAST(e.cardnumber AS char(100) CHARACTER SET utf8) as cardnumber,
    CAST(e.expirationdate AS char(100) CHARACTER SET utf8) as expirationdate,
    CAST(e.holdername AS char(100) CHARACTER SET utf8) as holdername,
    CAST(e.holderci AS char(100) CHARACTER SET utf8) as holderci,
    CAST(e.field_85 AS char(100) CHARACTER SET utf8) as monto_tdc
FROM
    ost_ticket a,
    ost_ticket__cdata e,
    ost_staff f
WHERE
    a.ticket_id = e.ticket_id AND
    a.staff_id = f.staff_id AND
    a.topic_id = 19