[getRootNodes]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`orgid`,node.`lft`,node.`rgt`
FROM subay_cabinet AS node,
        subay_cabinet AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND node.orgid IN ('ROOT',$P{orgid}) AND node.parentid IS NULL AND  node.type='cabinet'
GROUP BY node.title
ORDER BY node.lft

[getRootNodes1]
SELECT a.* FROM subay_cabinet a  WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND a.parentid IS NULL and a.type='cabinet' ORDER BY a.code

[getChildNodes]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`orgid`,node.`lft`,node.`rgt`
FROM subay_cabinet AS node,
        subay_cabinet AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND node.parentid=$P{objid} AND node.type <> 'document'
GROUP BY node.title
ORDER BY node.lft

[getChildNodes1]
SELECT a.* FROM subay_cabinet a WHERE 
a.parentid=$P{objid} AND a.type='cabinet' ORDER BY a.code

[getList]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`orgid`,node.`lft`,node.`rgt`
FROM subay_cabinet AS node,
        subay_cabinet AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND node.orgid IN ('ROOT',$P{orgid}) AND node.parentid=$P{objid}
GROUP BY node.title
ORDER BY node.lft

[getList1]
SELECT * FROM subay_cabinet WHERE 
orgid IN ('ROOT',$P{orgid}) AND parentid=$P{objid} ORDER BY code 

[getListDetails]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`orgid`,node.`lft`,node.`rgt`
FROM subay_cabinet AS node,
        subay_cabinet AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND node.orgid IN ('ROOT',$P{orgid}) AND (node.title LIKE $P{searchtext} OR node.code LIKE $P{searchtext}) AND  node.type='folder'
GROUP BY node.title
ORDER BY node.lft

[getListDetails1]
SELECT DISTINCT a.* FROM 
( 
  SELECT * FROM subay_cabinet WHERE 
  code LIKE $P{searchtext}
  UNION 
  SELECT * FROM subay_cabinet WHERE 
  title LIKE $P{searchtext}
) a
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND  a.type='folder'
ORDER BY a.code 

[getSearch]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`orgid`,node.`lft`,node.`rgt`
FROM subay_cabinet AS node,
        subay_cabinet AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND node.orgid IN ('ROOT',$P{orgid}) AND (node.title LIKE $P{searchtext} OR node.code LIKE $P{searchtext})
GROUP BY node.title
ORDER BY node.lft

[getSearch1]
SELECT DISTINCT a.* FROM 
( 
  SELECT * FROM subay_cabinet WHERE 
  code LIKE $P{searchtext}
  UNION 
  SELECT * FROM subay_cabinet WHERE 
  title LIKE $P{searchtext}
) a
WHERE a.orgid IN ('ROOT',$P{orgid})
ORDER BY a.code 

[findInfo]
SELECT a.*, p.code AS parent_code, p.title AS parent_title 
FROM subay_cabinet a
LEFT JOIN subay_cabinet p ON a.parentid = p.objid
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND a.objid=$P{objid}

[getLookup]
SELECT CONCAT( REPEAT( '-', (COUNT(parent.title) - 1) ), node.title) AS location,node.title, node.objid,node.`parentid`,node.`state`,node.`code`,node.`type`,node.`orgid`,node.`lft`,node.`rgt`
FROM subay_cabinet AS node,
        subay_cabinet AS parent
WHERE (node.lft BETWEEN parent.lft AND parent.rgt) AND node.orgid = $P{orgid} AND node.type <> 'document'
GROUP BY node.title
ORDER BY node.lft

[getLookup1]
SELECT a.* FROM 
(
	SELECT objid,code,title,type FROM subay_cabinet t WHERE 
	t.orgid IN ('ROOT',$P{orgid}) AND t.code LIKE $P{searchtext} AND type=$P{type} AND parentid LIKE $P{parentid}
	UNION
	SELECT objid,code,title,type FROM subay_cabinet t WHERE 
	t.orgid IN ('ROOT',$P{orgid}) AND t.title LIKE $P{searchtext} AND type=$P{type} AND parentid LIKE $P{parentid} 
) a
ORDER BY a.code

[getLookupForMapping]
SELECT a.* FROM 
(
	SELECT objid,code,title,type FROM subay_cabinet t WHERE 
	a.orgid IN ('ROOT',$P{orgid}) AND t.code LIKE $P{searchtext} 
	UNION
	SELECT objid,code,title,type FROM subay_cabinet t WHERE 
	a.orgid IN ('ROOT',$P{orgid}) AND t.title LIKE $P{searchtext}
) a
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND a.type IN ( 'folder', 'subaccount' )
ORDER BY a.code

[approve]
UPDATE subay_cabinet SET state='APPROVED' WHERE 
objid=$P{objid} 

[changeParent]
UPDATE subay_cabinet SET parentid=$P{parentid},lft=$P{lft},rgt=$P{rgt} WHERE 
objid=$P{objid} 

[getSubAccounts]
SELECT a.* FROM subay_cabinet a WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND a.parentid=$P{objid} AND a.type='subaccount' ORDER BY a.code

[getRevenueItemList]
SELECT r.objid,r.code,r.title,
a.objid AS account_objid, a.title AS account_title, a.code AS account_code
FROM itemaccount r 
LEFT JOIN sre_revenue_mapping m ON m.revenueitemid=r.objid
LEFT JOIN subay_cabinet a ON a.objid=m.acctid
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND r.title LIKE $P{searchtext} 
ORDER BY r.code

[getRevenueItemListByCode]
SELECT r.objid,r.code,r.title,
a.objid AS account_objid, a.title AS account_title, a.code AS account_code
FROM itemaccount r 
LEFT JOIN sre_revenue_mapping m ON m.revenueitemid=r.objid
LEFT JOIN subay_cabinet a ON a.objid=m.acctid
WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND r.code LIKE $P{searchtext} 
ORDER BY r.code

[getAccountcabinets]
SELECT 
  objid,
  CASE WHEN parentid IS NULL THEN 'ROOT' ELSE parentid END AS parentid,
  code,
  title,
  type,
  0 AS amount 
FROM subay_cabinet 
ORDER BY code


[findParent]
SELECT * FROM subay_cabinet WHERE objid = $P{parentid}

[changeNodeRight]
UPDATE subay_cabinet SET rgt = rgt + 2 WHERE rgt > $P{myRight}

[changeNodeLeft]
UPDATE subay_cabinet SET lft = lft + 2 WHERE lft > $P{myRight}

[changeParentRight]
UPDATE subay_cabinet SET rgt = rgt + 2 WHERE rgt > $P{myLeft}

[changeParentLeft]
UPDATE subay_cabinet SET lft = lft + 2 WHERE lft > $P{myLeft}

