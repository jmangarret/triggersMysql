SELECT vtiger_crmentity.crmid, vtiger_crmentity.smownerid, vtiger_crmentity.setype, vtiger_activity.* FROM vtiger_activity
					INNER JOIN vtiger_crmentity ON vtiger_crmentity.crmid = vtiger_activity.activityid
					LEFT JOIN vtiger_groups ON vtiger_groups.groupid = vtiger_crmentity.smownerid 
          INNER JOIN vt_tmp_u28_t9 vt_tmp_u28_t9 ON (vt_tmp_u28_t9.id = vtiger_crmentity.smownerid 
            and vt_tmp_u28_t9.shared=0) or (vt_tmp_u28_t9.id = vtiger_crmentity.smownerid 
            AND vt_tmp_u28_t9.shared=1 and vtiger_activity.visibility = 'Public')  
WHERE vtiger_crmentity.deleted=0
					AND (vtiger_activity.activitytype NOT IN ('Emails'))
					AND (vtiger_activity.status is NULL OR vtiger_activity.status NOT IN ('Completed', 'Deferred'))
					AND (vtiger_activity.eventstatus is NULL OR vtiger_activity.eventstatus NOT IN ('Held')) AND due_date >= '2016-08-10' 
          AND vtiger_crmentity.smownerid = ? ORDER BY date_start, time_start LIMIT ?, ?