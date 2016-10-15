[getList]
SELECT r.* 
FROM stockrequest r 
WHERE 
r.state = 'OPEN_CONSOLIDATED'
AND r.reqno LIKE $P{searchtext}

[getItems]
SELECT sri.*
FROM stockrequestitem sri
INNER JOIN products p ON sri.item_objid = p.objid
WHERE sri.parentid=$P{objid}


[deleteRequest]
update stockrequest set state = 'DELETED' where objid =$P{objid} 