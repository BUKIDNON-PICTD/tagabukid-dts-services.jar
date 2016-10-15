[getList]
SELECT r.* 
FROM stockreceived r 
WHERE 1=1
${filter}
AND r.issueno LIKE $P{searchtext}

[getItems]
SELECT sri.*
FROM stockrequestitem sri
INNER JOIN products p ON sri.item_objid = p.objid
WHERE sri.parentid=$P{objid}

[getInventoryItems]
SELECT sri.*
FROM stockreceiveditem sri
INNER JOIN products p ON sri.item_objid = p.objid
WHERE sri.parentid=$P{objid}

[deleteRequest]
update stockrequest set state = 'DELETED' where objid =$P{objid} 

[closeRequest]
UPDATE stockrequest set state = 'CLOSED' WHERE objid = $P{objid}