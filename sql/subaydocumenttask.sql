[closePrevTask]
UPDATE document_task dt
INNER JOIN document_task_org dto ON dto.`taskid` = dt.`objid`
SET dt.enddate = $P{enddate}
WHERE dt.refid = $P{refid} AND dt.enddate IS NULL ${filter}

[deleteTask]
DELETE FROM document_task WHERE lft > $P{mylft} AND rgt < $P{myrgt} AND refid = $P{refid}

[deleteTaskById]
DELETE FROM document_task WHERE objid = $P{taskid}

[updateDeletedTaskrgt]
UPDATE document_task SET rgt = rgt - $P{mywidth} WHERE rgt > $P{myrgt} AND refid = $P{refid}

[updateDeletedTasklft]
UPDATE document_task SET lft = lft - $P{mywidth} WHERE lft > $P{myrgt} AND refid = $P{refid}

[findTask]
SELECT * FROM document_task WHERE objid = $P{objid}

[findParentNode]
SELECT * FROM 
(SELECT node.*, (COUNT(parent.objid) - 1) AS depth
FROM document_task AS node,
document_task AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
AND node.refid = $P{refid}
AND parent.refid = $P{refid}
GROUP BY node.objid
ORDER BY node.lft)xx
WHERE depth = (SELECT (COUNT(parent.objid) - 1) AS depth
FROM document_task AS node,
document_task AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
AND node.refid = $P{refid}
AND parent.refid = $P{refid}
AND node.`objid` = $P{taskid}
GROUP BY node.objid
ORDER BY node.lft) - 1;

[updateParentNode]
UPDATE document_task SET enddate = NULL WHERE objid = $P{taskid}

[cancelSend]
UPDATE document_task dt
SET dt.enddate = NULL
WHERE dt.refid = $P{refid} AND objid = $P{taskid}

[getTaskListByRef2]
SELECT dt.*,dto.*
FROM ${taskTablename} dt
INNER JOIN document_task_org dto ON dto.`taskid` = dt.`objid`
WHERE dt.refid=$P{refid} 
ORDER BY dt.startdate

[getTaskListByRef]
SELECT xx.*, dto.* 
FROM (SELECT dtp.*
FROM document_task dt, document_task dtp
WHERE dt.lft BETWEEN dtp.lft AND dtp.rgt
AND dt.objid = $P{taskid} 
AND dtp.refid = $P{refid} 
ORDER BY dtp.lft)xx
INNER JOIN document_task_org dto ON dto.`taskid` = xx.`objid`;

[attachChildTask]
UPDATE document_task 
SET enddate = $P{enddate},
state = $P{state},
message = $P{message},
parentprocessid = $P{parentprocessid}
WHERE refid = $P{refid} AND enddate IS NULL AND state = 'processing'

[findPrevTask]
SELECT * FROM document_task dt
INNER JOIN document_task_org dto ON dto.`taskid` = dt.`objid`
WHERE dt.refid = $P{refid} AND dt.enddate IS NULL ${filter}

[changeRight]
UPDATE document_task SET rgt = rgt + 2 WHERE rgt > $P{myleft} AND refid = $P{refid}

[changeLeft]
UPDATE document_task SET lft = lft + 2 WHERE lft > $P{myleft} AND refid = $P{refid}

[getChildTask]
SELECT xx.*,dto.* FROM (
SELECT node.*, (COUNT(parent.objid) - (sub_tree.depth + 1)) AS depth
FROM document_task AS node,
        document_task AS parent,
        document_task AS sub_parent,
        (
                SELECT node.objid, (COUNT(parent.objid) - 1) AS depth
                FROM document_task AS node,
                document_task AS parent
                WHERE node.lft BETWEEN parent.lft AND parent.rgt
                AND node.`objid` = $P{taskid}
              
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
INNER JOIN document_task_org dto ON dto.`taskid` = xx.`objid`
WHERE xx.depth = 1;

[getChildTasks]
SELECT * FROM 
(SELECT node.*, (COUNT(parent.objid) - 1) AS depth
FROM document_task AS node,
document_task AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
AND node.refid = $P{refid}
AND parent.refid = $P{refid}
GROUP BY node.objid
ORDER BY node.lft)xx
WHERE depth = (SELECT (COUNT(parent.objid) - 1) AS depth
FROM document_task AS node,
document_task AS parent
WHERE node.lft BETWEEN parent.lft AND parent.rgt
AND node.refid = $P{refid}
AND parent.refid = $P{refid}
AND node.`objid` = $P{taskid}
GROUP BY node.objid
ORDER BY node.lft)