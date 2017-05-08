[closeTaskById]
UPDATE subay_document_task dt
SET dt.enddate = $P{enddate}
WHERE dt.objid = $P{taskid}

[closePrevTask]
UPDATE subay_document_task dt
INNER JOIN subay_document_task_org dto ON dto.`taskid` = dt.`objid`
SET dt.enddate = $P{enddate}
WHERE dt.refid = $P{refid} AND dt.enddate IS NULL ${filter}

[deleteTask]
DELETE FROM subay_document_task WHERE lft > $P{mylft} AND rgt < $P{myrgt} AND refid = $P{refid}

[deleteTaskById]
DELETE FROM subay_document_task WHERE objid = $P{taskid}

[updateDeletedTaskrgt]
UPDATE subay_document_task SET rgt = rgt - $P{mywidth} WHERE rgt > $P{myrgt} AND refid = $P{refid}

[updateDeletedTasklft]
UPDATE subay_document_task SET lft = lft - $P{mywidth} WHERE lft > $P{myrgt} AND refid = $P{refid}

[findTask]
SELECT * FROM subay_document_task WHERE objid = $P{objid}

[findParentNode]
SELECT * FROM 
(SELECT node.*, (COUNT(parent.objid) - 1) AS depth
FROM subay_document_task AS node,
subay_document_task AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
AND node.refid = $P{refid}
AND parent.refid = $P{refid}
GROUP BY node.objid
ORDER BY node.lft)xx
WHERE depth = (SELECT (COUNT(parent.objid) - 1) AS depth
FROM subay_document_task AS node,
subay_document_task AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
AND node.refid = $P{refid}
AND parent.refid = $P{refid}
AND node.`objid` = $P{taskid}
GROUP BY node.objid
ORDER BY node.lft) - 1;

[updateParentNode]
UPDATE subay_document_task SET enddate = NULL WHERE objid = $P{taskid}

[cancelSend]
UPDATE subay_document_task dt
SET dt.enddate = NULL
WHERE dt.refid = $P{refid} AND objid = $P{taskid}

[getTaskListByRef2]
SELECT dt.*,dto.*
FROM subay_document_task dt
INNER JOIN subay_document_task_org dto ON dto.`taskid` = dt.`objid`
WHERE dt.refid=$P{refid} 
ORDER BY dt.startdate

[getTaskListByRef]
SELECT xx.*, dto.* 
FROM (SELECT dtp.*
FROM subay_document_task dt, subay_document_task dtp
WHERE dt.lft BETWEEN dtp.lft AND dtp.rgt
AND dt.objid = $P{taskid} 
AND dtp.refid = $P{refid} 
ORDER BY dtp.lft)xx
INNER JOIN subay_document_task_org dto ON dto.`taskid` = xx.`objid`;

[attachChildTask]
UPDATE subay_document_task 
SET enddate = $P{enddate},
state = $P{state},
message = $P{message},
parentprocessid = $P{parentprocessid}
WHERE refid = $P{refid} AND enddate IS NULL AND state = 'processing'

[findPrevTask]
SELECT * FROM subay_document_task dt
INNER JOIN subay_document_task_org dto ON dto.`taskid` = dt.`objid`
WHERE dt.refid = $P{refid} AND dt.enddate IS NULL ${filter}

[changeRight]
UPDATE subay_document_task SET rgt = rgt + (2 * $P{child}) WHERE rgt > $P{myleft} AND refid = $P{refid}

[changeLeft]
UPDATE subay_document_task SET lft = lft + (2 * $P{child}) WHERE lft > $P{myleft} AND refid = $P{refid}

[getChildTask3]
SELECT d.objid,
d.docstate,
d.din,
(SELECT objid FROM subay_document_link WHERE taskid = dt.objid)  AS parentid,
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
d.dininventoryid,
d.isoffline,
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
WHERE dt.objid IN (
SELECT node.objid
FROM subay_document_task AS node,
        subay_document_task AS parent,
        subay_document_task AS sub_parent,
        (
                SELECT node.objid, (COUNT(parent.objid) - 1) AS depth
                FROM subay_document_task AS node,
                subay_document_task AS parent
                WHERE node.lft BETWEEN parent.lft AND parent.rgt
                AND node.objid = $P{taskid}
                AND node.refid = $P{refid}
                AND parent.refid = $P{refid}
                GROUP BY node.objid
                ORDER BY node.lft
        )AS sub_tree
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
        AND sub_parent.objid = sub_tree.objid
        AND node.refid = $P{refid}
        AND parent.refid = $P{refid}
        AND sub_parent.refid = $P{refid}
        AND node.enddate IS NULL
GROUP BY node.objid
ORDER BY node.lft)
ORDER BY dt.startdate

[getChildTask]
SELECT xx.*,dto.* FROM (
SELECT node.*, (COUNT(parent.objid) - (sub_tree.depth + 1)) AS depth
FROM subay_document_task AS node,
        subay_document_task AS parent,
        subay_document_task AS sub_parent,
        (
                SELECT node.objid, (COUNT(parent.objid) - 1) AS depth
                FROM subay_document_task AS node,
                subay_document_task AS parent
                WHERE node.lft BETWEEN parent.lft AND parent.rgt
                AND node.objid = $P{taskid}
                AND node.refid = $P{refid}
                AND parent.refid = $P{refid}
                GROUP BY node.objid
                ORDER BY node.lft
        )AS sub_tree
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
        AND sub_parent.objid = sub_tree.objid
        AND node.refid = $P{refid}
        AND parent.refid = $P{refid}
        AND sub_parent.refid = $P{refid}
        AND node.enddate IS NULL
GROUP BY node.objid
ORDER BY node.lft)xx
INNER JOIN subay_document_task_org dto ON dto.`taskid` = xx.`objid`;

[getChildTask1]
SELECT xx.*,dto.* FROM (
SELECT node.*, (COUNT(parent.objid) - (sub_tree.depth + 1)) AS depth
FROM subay_document_task AS node,
        subay_document_task AS parent,
        subay_document_task AS sub_parent,
        (
                SELECT node.objid, (COUNT(parent.objid) - 1) AS depth
                FROM subay_document_task AS node,
                subay_document_task AS parent
                WHERE node.lft BETWEEN parent.lft AND parent.rgt
                AND node.objid = $P{taskid}
                AND node.refid = $P{refid}
		AND parent.refid = $P{refid}
                GROUP BY node.objid
                ORDER BY node.lft
        )AS sub_tree
WHERE node.lft BETWEEN parent.lft AND parent.rgt
        AND node.lft BETWEEN sub_parent.lft AND sub_parent.rgt
        AND sub_parent.objid = sub_tree.objid
	AND node.refid = $P{refid}
	AND parent.refid = $P{refid}
	AND sub_parent.refid = $P{refid}
GROUP BY node.objid
ORDER BY node.lft)xx
INNER JOIN subay_document_task_org dto ON dto.`taskid` = xx.`objid`
WHERE xx.depth = 1;

[getChildTasks]
SELECT * FROM 
(SELECT node.*, (COUNT(parent.objid) - 1) AS depth
FROM subay_document_task AS node,
subay_document_task AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
AND node.refid = $P{refid}
AND parent.refid = $P{refid}
GROUP BY node.objid
ORDER BY node.lft)xx
WHERE depth = (SELECT (COUNT(parent.objid) - 1) AS depth
FROM subay_document_task AS node,
subay_document_task AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
AND node.refid = $P{refid}
AND parent.refid = $P{refid}
AND node.`objid` = $P{taskid}
GROUP BY node.objid
ORDER BY node.lft)