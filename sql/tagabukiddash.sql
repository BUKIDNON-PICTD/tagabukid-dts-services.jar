[getDashData]
(SELECT 'forremittance' AS label,IFNULL(SUM(c.`amount`),0) AS total, 'double' as `type` FROM cashreceipt c
LEFT JOIN remittance_cashreceipt rc ON c.`objid` = rc.`objid`
LEFT JOIN cashreceipt_void cv ON cv.`receiptid` = c.`objid`
WHERE YEAR(c.receiptdate) = YEAR(NOW())
AND rc.`objid` IS NULL
AND cv.`objid` IS NULL) 
UNION
(SELECT 'forliquidation',IFNULL(SUM(r.`amount`),0) AS total, 'double' AS `type` FROM remittance r
LEFT JOIN liquidation_remittance lr ON lr.`objid` = r.`objid`
WHERE lr.`objid` IS NULL AND YEAR(r.dtposted) = YEAR(NOW()))
UNION
(SELECT 'ltforremittance' AS label,IFNULL(SUM(c.`amount`),0) AS total, 'double' AS `type` FROM cashreceipt c
LEFT JOIN remittance_cashreceipt rc ON c.`objid` = rc.`objid`
LEFT JOIN cashreceipt_void cv ON cv.`receiptid` = c.`objid`
WHERE YEAR(c.receiptdate) = YEAR(NOW())
AND rc.`objid` IS NULL
AND cv.`objid` IS NULL
AND c.formno = 56)
UNION
(SELECT 'totalclient' AS label, SUM(xx.paidby) AS total, 'int' AS `type` FROM 
(SELECT COUNT(*) AS paidby FROM cashreceipt c
LEFT JOIN cashreceipt_void cv ON cv.`receiptid` = c.`objid`
WHERE YEAR(c.receiptdate) = YEAR(NOW())
AND cv.`objid` IS NULL
GROUP BY c.`paidby`)xx)


[getDashData2]
SELECT COUNT(*) AS documentcount, dto.`name`,xx.`orgcode`,
SUM(IF(dt.state = "outgoing",1,0)) AS outgoing,
SUM(IF(dt.state = "enroute",1,0)) AS incoming,
SUM(IF(dt.state = "processing",1,0)) AS processing
FROM document d
INNER JOIN document_task dt ON dt.`refid` = d.`objid`
INNER JOIN document_task_org dto ON dto.`taskid` = dt.`objid`
INNER JOIN (SELECT DISTINCT orgname,orgcode FROM user_organization)xx on dto.`name` = xx.orgname
WHERE dt.`enddate` IS NULL
GROUP BY dto.`orgid`
ORDER BY 6 desc
limit 10
