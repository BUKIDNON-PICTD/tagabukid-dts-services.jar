[getList]
SELECT * FROM document_redflag WHERE refid=$P{objid}

[getOpenIssues]
SELECT * FROM document_redflag WHERE resolved=0 AND refid=$P{refid} AND blockaction=$P{blockaction}

[findDocumentInfo]
SELECT d.objid,
d.docstate,
d.din,
d.parentid,
d.documenttypeid,
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
dto.orgid,
dto.macaddress,
dto.name,
dto.address
FROM document d
INNER JOIN document_task dt ON dt.`refid` = d.`objid`
INNER JOIN document_task_org dto ON dto.`taskid` = dt.`objid`
WHERE d.objid=$P{refid} AND dt.state = 'redflag' AND dt.enddate IS NULL
ORDER BY d.title

[getByObjid]
SELECT * FROM sys_notification WHERE objid=$P{objid} 