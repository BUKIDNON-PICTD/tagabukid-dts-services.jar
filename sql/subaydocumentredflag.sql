[getList]
SELECT * FROM subay_document_redflag WHERE refid=$P{objid}

[getOpenIssues]
SELECT * FROM subay_document_redflag WHERE resolved=0 AND refid=$P{refid} AND blockaction=$P{blockaction}

[findDocumentInfo]
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
WHERE d.objid=$P{refid} AND dt.state = 'redflag' AND dt.enddate IS NULL
ORDER BY d.title

[getByObjid]
SELECT * FROM sys_notification WHERE objid=$P{objid} 