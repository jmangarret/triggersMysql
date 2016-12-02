select r.roleid, user_name from vtiger_users inner join vtiger_user2role as r on r.userid=id
where roleid='H10'