[getListForVerification]
SELECT objid,docstate,title,description,tags,author
FROM subay_document 
WHERE title LIKE $P{title}
ORDER BY title

[getDocumentbyDIN]
SELECT d.objid,
d.docstate,
d.din,
dl.objid AS parentid,
d.documenttype_objid,
d.title,
d.description,
d.tags,
d.author,
d.recordlog_datecreated,
d.recordlog_createdbyuserid,
d.recordlog_createdbyuser,
d.recordlog_dateoflastupdate,
d.recordlog_lastupdatedbyuserid,
d.recordlog_lastupdatedbyuser,
dt.objid AS taskid,
dt.refid,
dt.parentprocessid,
dt.state,
dt.startdate,
dt.assignee_objid,
dt.assignee_name,
dt.assignee_title,
dt.enddate,
dt.actor_objid,
dt.actor_name,
dt.actor_title,
dt.signature,
dt.lft,
dt.rgt,
dto.org_objid,
dto.macaddress,
dto.org_name,
dto.org_address,
dtyp.code AS documenttype_code,
dtyp.name AS documenttype_name,
dtyp.description AS documenttype_description,
dtyp.haschild AS documenttype_haschild
FROM subay_document d
INNER JOIN subay_document_type dtyp ON dtyp.`objid` = d.`documenttype_objid`
INNER JOIN subay_document_task dt ON dt.`refid` = d.`objid`
INNER JOIN subay_document_task_org dto ON dto.`taskid` = dt.`objid`
LEFT JOIN subay_document_link dl ON dl.`taskid` = dt.`objid`
WHERE ${filter}
ORDER BY d.title

[getEtracsUser]
SELECT * FROM sys_user
WHERE name LIKE $P{searchtext} 
ORDER BY lastname

[getOrgUnit]
SELECT * FROM subay_org_unit
WHERE UPPER(Entity_Name) LIKE $P{searchtext} 
OR UPPER(Entity_AcronymAbbreviation) LIKE $P{searchtext} 
ORDER BY Entity_Name

[getUserOrg]
SELECT org_objid,org_name,org_code FROM subay_user_organization
WHERE org_name LIKE $P{searchtext} 
OR org_code LIKE $P{searchtext} 
GROUP BY org_objid ORDER BY org_name

[getList]
SELECT d.objid,
d.docstate,
d.din,
dl.objid AS parentid,
d.documenttype_objid,
d.title,
d.description,
d.tags,
d.author,
d.recordlog_datecreated,
d.recordlog_createdbyuserid,
d.recordlog_createdbyuser,
d.recordlog_dateoflastupdate,
d.recordlog_lastupdatedbyuserid,
d.recordlog_lastupdatedbyuser,
ug.org_objid AS originorg_objid,
ug.org_name AS originorg_name,
ug.org_code AS originorg_code,
dt.objid AS taskid,
dt.refid,
dt.parentprocessid,
dt.state,
dt.startdate,
dt.assignee_objid,
dt.assignee_name,
dt.assignee_title,
dt.enddate,
dt.actor_objid,
dt.actor_name,
dt.actor_title,
dt.message,
dt.signature,
dt.lft,
dt.rgt,
dto.org_objid AS locationorg_objid,
dto.org_name AS locationorg_name,
dto.org_code AS locationorg_code,
dtyp.code AS documenttype_code,
dtyp.name AS documenttype_name,
dtyp.description AS documenttype_description,
dtyp.haschild AS documenttype_haschild,
ug2.org_objid AS senderorg_objid,
ug2.org_name AS senderorg_name,
ug2.org_code AS senderorg_code
FROM subay_document d
INNER JOIN subay_user_organization ug ON ug.objid = d.`recordlog_createdbyuserid`
INNER JOIN subay_document_task dt ON dt.`refid` = d.`objid`
INNER JOIN subay_document_task_org dto ON dto.`taskid` = dt.`objid`
INNER JOIN subay_document_type dtyp ON dtyp.`objid` = d.`documenttype_objid`
INNER JOIN subay_user_organization ug2 ON ug2.`objid` = dt.`actor_objid`
LEFT JOIN subay_document_link dl ON dl.`taskid` = dt.`objid`
WHERE 1=1
${filter}
ORDER BY dt.startdate

[findDocumentbyBarcode]
SELECT d.objid,
d.docstate,
d.din,
dl.objid AS parentid,
d.documenttype_objid,
d.title,
d.description,
d.tags,
d.author,
d.recordlog_datecreated,
d.recordlog_createdbyuserid,
d.recordlog_createdbyuser,
d.recordlog_dateoflastupdate,
d.recordlog_lastupdatedbyuserid,
d.recordlog_lastupdatedbyuser,
ug.org_objid AS originorg_objid,
ug.org_name AS originorg_name,
ug.org_code AS originorg_code,
dt.objid AS taskid,
dt.refid,
dt.parentprocessid,
dt.state,
dt.startdate,
dt.assignee_objid,
dt.assignee_name,
dt.assignee_title,
dt.enddate,
dt.actor_objid,
dt.actor_name,
dt.actor_title,
dt.message,
dt.signature,
dt.lft,
dt.rgt,
dto.org_objid AS locationorg_objid,
dto.org_name AS locationorg_name,
dto.org_code AS locationorg_code,
dtyp.code AS documenttype_code,
dtyp.name AS documenttype_name,
dtyp.description AS documenttype_description,
dtyp.haschild AS documenttype_haschild,
ug2.org_objid AS senderorg_objid,
ug2.org_name AS senderorg_name,
ug2.org_code AS senderorg_code
FROM subay_document d
INNER JOIN subay_user_organization ug ON ug.objid = d.`recordlog_createdbyuserid`
INNER JOIN subay_document_task dt ON dt.`refid` = d.`objid`
INNER JOIN subay_document_task_org dto ON dto.`taskid` = dt.`objid`
INNER JOIN subay_document_type dtyp ON dtyp.`objid` = d.`documenttype_objid`
INNER JOIN subay_user_organization ug2 ON ug2.`objid` = dt.`actor_objid`
LEFT JOIN subay_document_link dl ON dl.`taskid` = dt.`objid`
WHERE ${filter}
AND (dt.enddate IS NULL OR dt.state IN ('archived','attached','linked'))
ORDER BY d.title

[getDocumentbyBarcode]
SELECT d.objid,
d.docstate,
d.din,
dl.objid AS parentid,
d.documenttype_objid,
d.title,
d.description,
d.tags,
d.author,
d.recordlog_datecreated,
d.recordlog_createdbyuserid,
d.recordlog_createdbyuser,
d.recordlog_dateoflastupdate,
d.recordlog_lastupdatedbyuserid,
d.recordlog_lastupdatedbyuser,
ug.org_objid AS originorgid,
ug.org_name AS originorgname,
ug.org_code AS originorgcode,
dt.objid AS taskid,
dt.refid,
dt.parentprocessid,
dt.state,
dt.startdate,
dt.assignee_objid,
dt.assignee_name,
dt.assignee_title,
dt.enddate,
dt.actor_objid,
dt.actor_name,
dt.actor_title,
dt.message,
dt.signature,
dt.lft,
dt.rgt,
dto.org_objid,
dto.macaddress,
dto.org_name,
dto.org_address,
dtyp.code AS documenttype_code,
dtyp.name AS documenttype_name,
dtyp.description AS documenttype_description,
dtyp.haschild AS documenttype_haschild
FROM subay_document d
INNER JOIN subay_user_organization ug ON ug.objid = d.`recordlog_createdbyuserid`
INNER JOIN subay_document_task dt ON dt.`refid` = d.`objid`
INNER JOIN subay_document_task_org dto ON dto.`taskid` = dt.`objid`
INNER JOIN subay_document_type dtyp ON dtyp.`objid` = d.`documenttype_objid`
LEFT JOIN subay_document_link dl ON dl.`taskid` = dt.`objid`
WHERE ${filter}
AND (dt.enddate IS NULL OR dt.state IN ('archived','attached','linked'))
ORDER BY d.title, dt.startdate

[getDocumentChild]
SELECT d.objid,
d.docstate,
d.din,
dl.`objid` AS parentid,
d.documenttype_objid,
d.title,
d.description,
d.tags,
d.author,
d.recordlog_datecreated,
d.recordlog_createdbyuserid,
d.recordlog_createdbyuser,
d.recordlog_dateoflastupdate,
d.recordlog_lastupdatedbyuserid,
d.recordlog_lastupdatedbyuser,
ug.org_objid AS originorgid,
ug.org_name AS originorgname,
ug.org_code AS originorgcode,
dt.objid AS taskid,
dt.refid,
dt.parentprocessid,
dt.state,
dt.startdate,
dt.assignee_objid,
dt.assignee_name,
dt.assignee_title,
dt.enddate,
dt.actor_objid,
dt.actor_name,
dt.actor_title,
dt.message,
dt.signature,
dt.lft,
dt.rgt,
dto.org_objid,
dto.macaddress,
dto.org_name,
dto.org_address,
dtyp.code AS documenttype_code,
dtyp.name AS documenttype_name,
dtyp.description AS documenttype_description,
dtyp.haschild AS documenttype_haschild
FROM subay_document d
INNER JOIN subay_user_organization ug ON ug.objid = d.`recordlog_createdbyuserid`
INNER JOIN subay_document_task dt ON dt.`refid` = d.`objid`
INNER JOIN subay_document_task_org dto ON dto.`taskid` = dt.`objid`
INNER JOIN subay_document_type dtyp ON dtyp.`objid` = d.`documenttype_objid`
LEFT JOIN subay_document_link dl ON dl.`taskid` = dt.`objid`
WHERE ${filter}
AND dt.state IN ('archived','attached','linked')
ORDER BY d.title, dt.startdate

[updateparent]
UPDATE document SET parentid = $P{parentid} WHERE objid = $P{objid}

[getChild]
SELECT * FROM subay_document WHERE parentid = $P{objid}

[findDocumentInv]
SELECT * FROM subay_din_inventory 
WHERE prefix = $P{prefix} 
AND $P{sequence} BETWEEN startseries AND endseries
AND org_objid = $P{orgid}

[findDocStatsByOrg]
SELECT COUNT(*) AS total,
       SUM(IF(dt.state = "outgoing",1,0)) AS outgoing,
       SUM(IF(dt.state = "enroute",1,0)) AS enroute,
       SUM(IF(dt.state = "processing",1,0)) AS processing,
       SUM(IF(dt.state = "archived",1,0)) AS archived,
       SUM(IF(dt.state = "attached",1,0)) AS attached
	
FROM subay_document d
INNER JOIN subay_user_organization ug ON ug.objid = d.`recordlog_createdbyuserid`
INNER JOIN subay_document_task dt ON dt.`refid` = d.`objid`
INNER JOIN subay_document_task_org dto ON dto.`taskid` = dt.`objid`
INNER JOIN subay_document_type dtyp ON dtyp.`objid` = d.`documenttype_objid`
WHERE (dt.enddate IS NULL 
OR dt.state IN ('attached','archived','closed')) 
AND dto.org_objid = $P{userorgid}
ORDER BY d.title, dt.startdate

