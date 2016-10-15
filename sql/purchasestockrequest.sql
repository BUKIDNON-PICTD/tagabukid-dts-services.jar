[getList]
SELECT r.* 
FROM stockrequest r 
WHERE 1=1
${filter}
AND r.reqno LIKE $P{searchtext}

[getList1]
SELECT r.* 
FROM stockrequest r 
WHERE 1=1
AND r.state = $P{state}
AND r.reqno LIKE $P{searchtext}

[getItems]
SELECT sri.*
FROM stockrequestitem sri
INNER JOIN products p ON sri.item_objid = p.objid
WHERE sri.parentid=$P{objid}


[getConsolidatedItems]
SELECT parentid,item_objid,item_code,item_title,unit,SUM(qty) as qty
FROM stockrequestitem
WHERE 1=1
${filter}
GROUP BY item_objid

[getConsolidatedRequestItems]
SELECT * FROM stockrequest
WHERE parentid = $P{parentid}

[getAllItems]
SELECT * as qty
FROM stockrequestitem
WHERE 1=1
${filter}


[deleteRequest]
update stockrequest set state = 'DELETED' where objid =$P{objid} 

[closeConsolidatedRequest]
UPDATE stockrequest set state = 'CLOSED',parentid = $P{parentid} WHERE objid = $P{objid}