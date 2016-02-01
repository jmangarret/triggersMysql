drop view if exists ost_crm;
DELIMITER |

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` 
SQL SECURITY DEFINER VIEW `ost_crm` AS select `a`.`ticket_id` AS `ticket_id`,`a`.`number` AS `ticket_number`,`a`.`status_id` AS `ticket_status_id`,
(select `b`.`name` from `ost_ticket_status` `b` where (`a`.`status_id` = `b`.`id`)) AS `ticket_status`,
`a`.`created` AS `ticket_creado`,
(select `b`.`org_id` from `ost_user` `b` where (`a`.`user_id` = `b`.`id`)) AS `org_id`,
(select `c`.`name` from (`ost_user` `b` join `ost_organization` `c`) where ((`a`.`user_id` = `b`.`id`) and (`c`.`id` = `b`.`org_id`))) AS `org_name`,
(select `d`.`value` from ((`ost_user` `b` join `ost_form_entry` `c`) join `ost_form_entry_values` `d`) 
	where ((`a`.`user_id` = `b`.`id`) and (`c`.`object_type` = 'O') and (`b`.`org_id` = `c`.`object_id`) and (`d`.`entry_id` = `c`.`id`) and (`d`.`field_id` = 87)) 
	group by `d`.`value`) AS `org_rif`,
`a`.`user_id` AS `user_id`,
(select `d`.`value` from ((`ost_user` `b` join `ost_form_entry` `c`) join `ost_form_entry_values` `d`) 
	where ((`a`.`user_id` = `b`.`id`) and (`c`.`object_type` = 'U') and (`b`.`org_id` = `c`.`object_id`) and (`d`.`entry_id` = `c`.`id`) and (`d`.`field_id` = 88)) 
	group by `d`.`value`) AS `user_ci`,
ucase(cast(`e`.`localizador` as char(100) charset utf8)) AS `localizador`,
cast(`e`.`status_loc` as char(100) charset utf8) AS `localizador_status`,
`a`.`staff_id` AS `asesor_id`,
`f`.`ci` AS `asesor_rif`,concat(`f`.`firstname`,' ',`f`.`lastname`) AS `asesor`,
cast(`e`.`gds` as char(15) charset utf8) AS `gds_id`,
(select `b`.`value` from `ost_list_items` `b` where (`b`.`id` = cast(`e`.`gds` as char(100) charset utf8))) AS `gds`,
cast(`e`.`subject` as char(15) charset utf8) AS `solicitud_id`,
(select `b`.`value` from `ost_list_items` `b` where (`b`.`id` = cast(`e`.`subject` as char(15) charset utf8))) AS `solicitud`,
cast(`e`.`paymentmethod` as char(15) charset utf8) AS `paymentmethod_id`,
(select `b`.`value` from `ost_list_items` `b` where (`b`.`id` = cast(`e`.`paymentmethod` as char(15) charset utf8))) AS `paymentmethod`,
cast(`e`.`cardnumber` as char(100) charset utf8) AS `cardnumber`,cast(`e`.`expirationdate` as char(100) charset utf8) AS `expirationdate`,
cast(`e`.`holdername` as char(100) charset utf8) AS `holdername`,cast(`e`.`holderci` as char(100) charset utf8) AS `holderci`,
cast(`e`.`field_85` as char(100) charset utf8) AS `monto_tdc` from ((`ost_ticket` `a` join `ost_ticket__cdata` `e`) join `ost_staff` `f`) 
where ((`a`.`ticket_id` = `e`.`ticket_id`) and (`a`.`staff_id` = `f`.`staff_id`) and (`a`.`topic_id` = 19))
 |
DELIMITER 