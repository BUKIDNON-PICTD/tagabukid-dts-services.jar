[getList]
SELECT * 
FROM btacs_reconciliation
WHERE ( organizationcode LIKE $P{searchtext} OR txnno LIKE $P{searchtext} OR state LIKE $P{searchtext} OR organization LIKE $P{searchtext} OR signatoryname LIKE $P{searchtext} )
ORDER BY recordlog_datecreated


[getLists]
SELECT *
FROM btacs_reconciliation
WHERE ( organizationcode LIKE $P{searchtext} OR txnno LIKE $P{searchtext} OR state LIKE $P{searchtext} OR organization LIKE $P{searchtext} OR signatoryname LIKE $P{searchtext} )
ORDER BY recordlog_datecreated


[findById]
SELECT * FROM btacs_reconciliation WHERE objid = $P{objid}

[approve]
UPDATE btacs_approver SET state = 'APPROVED' WHERE objid = $P{objid}

[getreconciliationpersonnels]
SELECT * FROM btacs_reconciliation_personnel WHERE parentid = $P{parentid}

[deletepersonnels]
DELETE FROM btacs_reconciliation_personnel WHERE objid = $P{objid}

[getreconciliationpersonnelitems]
SELECT * FROM btacs_reconciliation_personnel_item WHERE parentid = $P{parentid}

[deleteitems]
DELETE FROM btacs_reconciliation_personnel WHERE objid = $P{objid}

[findBTACSReconciliationById]
SELECT * FROM btacs_reconciliation WHERE documentid = $P{documentid}

[getBTACSPersonnels]
SELECT * FROM btacs_reconciliation_personnel WHERE parentid = $P{parentid}

[getBTACSPersonnelItems]
SELECT * FROM btacs_reconciliation_personnel_item WHERE parentid = $P{parentid}

[getLatestLog]
SELECT MAX(CHECKTIME) FROM CHECKINOUT WHERE USERID = $P{USERID}

[getblanklogs]
SELECT * FROM GetEmpLogs2($P{reconciliationdate},$P{reconciliationdate},SELECT USERID FROM USERINFO WHERE STREET = $P{personnelid}) WHERE (DateLogin IS NULL OR DateLogout IS NULL) AND HOLIDAY IS NULL AND SPECDAY IS NULL		

