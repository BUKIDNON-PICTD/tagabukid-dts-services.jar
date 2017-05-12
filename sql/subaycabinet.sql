[getRootNodes]
SELECT a.* FROM subay_cabinet a  WHERE 
a.orgid IN ('ROOT',$P{orgid}) AND a.parentid IS NULL and a.type='cabinet' ORDER BY a.code

[getChildNodes]
SELECT a.* FROM subay_cabinet a WHERE 
a.parentid=$P{objid} AND a.type='cabinet' ORDER BY a.code

[getList]
SELECT * FROM subay_cabinet WHERE 
orgid IN ('ROOT',$P{orgid}) AND parentid=$P{objid} ORDER BY code 

[getListDetails]
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
UPDATE subay_cabinet SET parentid=$P{parentid} WHERE 
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