
[getReportOfCollectionByIncomeAccount1]
SELECT 
    cr.formno, 
    cr.receiptno, 
    cr.receiptdate, 
    cr.formtype, 
    CASE WHEN vr.objid IS NULL THEN cr.paidby ELSE '*** VOIDED ***' END AS payorname, 
    CASE WHEN vr.objid IS NULL THEN cr.paidbyaddress ELSE '' END AS payoraddress, 
    CASE WHEN vr.objid IS NULL  THEN cri.item_title ELSE '' END AS accttitle, 
    CASE WHEN vr.objid IS NULL  THEN ri.fund_title ELSE '' END AS fundname, 
    CASE WHEN vr.objid IS NULL  THEN cri.amount ELSE 0.0 END AS amount, 
    CASE WHEN vr.objid IS NULL  THEN cri.remarks ELSE '' END AS accttitle, 
    cr.collector_name AS collectorname, 
    cr.collector_title AS collectortitle  
FROM cashreceipt cr 
  INNER JOIN remittance_cashreceipt rc ON cr.objid = rc.objid 
  INNER JOIN remittance r ON r.objid = rc.remittanceid 
  INNER JOIN cashreceiptitem cri ON cri.receiptid = cr.objid
  INNER JOIN itemaccount ri ON ri.objid = cri.item_objid 
  LEFT JOIN cashreceipt_void vr ON cr.objid = vr.receiptid  
where r.remittancedate BETWEEN $P{startdate} AND $P{enddate}  
    ${filter} 
order by cr.formno, cr.receiptno

[getReportOfCollectionByIncomeAccount]
select 
  cr.formno as afid, cr.receiptno as serialno, cr.receiptdate as txndate, 
  ai.fund_title as fundname, cr.remarks as remarks, 
  case when xx.voided=0 then cr.paidby else '***VOIDED***' END AS payer,
  case when xx.voided=0 then cri.item_title else '***VOIDED***' END AS particulars,
  case when xx.voided=0 then cr.paidbyaddress else '' END AS payeraddress,
  case when xx.voided=0 then cri.amount else 0.0 END AS amount 
from ( 
  select rc.*, 
    (select count(*) from cashreceipt_void where receiptid=rc.objid) as voided 
  FROM remittance_cashreceipt rc 
  INNER JOIN remittance r ON r.objid = rc.remittanceid 
  WHERE r.remittancedate BETWEEN $P{startdate} AND $P{enddate}  
)xx 
  inner join cashreceipt cr on xx.objid = cr.objid 
  inner join cashreceiptitem cri on cr.objid = cri.receiptid 
  inner join itemaccount ai on cri.item_objid = ai.objid 
WHERE ai.objid LIKE $P{accountid}  
order by afid, serialno, payer 


[getReportOfCollectionByIncomeAccountSummary]
SELECT 
  ai.fund_title AS fundname, cri.item_objid AS acctid, 
  cri.item_title AS acctname, cri.item_code AS acctcode, 
  SUM( cri.amount ) AS amount 
FROM ( 
  SELECT rc.*, 
    (SELECT COUNT(*) FROM cashreceipt_void WHERE receiptid=rc.objid) AS voided 
  FROM remittance_cashreceipt rc 
  INNER JOIN remittance r ON r.objid = rc.remittanceid 
  WHERE r.remittancedate BETWEEN $P{startdate} AND $P{enddate}  
)xx 
  INNER JOIN cashreceipt cr ON xx.objid = cr.objid 
  INNER JOIN cashreceiptitem cri ON cr.objid = cri.receiptid 
  INNER JOIN itemaccount ai ON cri.item_objid = ai.objid 
WHERE ai.objid LIKE $P{accountid} AND xx.voided=0
GROUP BY 
  ai.fund_title, cri.item_objid,  
  cri.item_title, cri.item_code 
ORDER BY fundname, acctcode 

[getCollectionByCollector]
SELECT 
    ri.fund_title AS fundname, cri.item_objid AS acctid, cri.item_title AS acctname,
    cri.item_code AS acctcode, SUM( cri.amount ) AS amount,cr.collector_name AS collectorname, 
    cr.collector_title AS collectortitle 
FROM cashreceipt cr 
  INNER JOIN remittance_cashreceipt rc ON cr.objid = rc.objid 
  INNER JOIN remittance r ON r.objid = rc.remittanceid 
  INNER JOIN cashreceiptitem cri ON cri.receiptid = cr.objid
  INNER JOIN itemaccount ri ON ri.objid = cri.item_objid 
  LEFT JOIN cashreceipt_void vr ON cr.objid = vr.receiptid  
WHERE r.remittancedate BETWEEN $P{fromdate} AND $P{todate} 
  AND vr.objid IS NULL ${filter} 
GROUP BY ri.fund_title, cri.item_objid, cri.item_code, cri.item_title 
ORDER BY collectorname,fundname, acctcode, acctname


[updateafcontrol]
UPDATE af_control SET  
  endseries = endseries + $P{qtyadjustment} 
WHERE objid = $P{objid} 

[adjustInventory]
UPDATE af_inventory SET  
  endseries = endseries + $P{qtyadjustment}, 
  qtyin = qtyin + $P{qtyadjustment}, 
  qtybalance = qtybalance + $P{qtyadjustment} 
WHERE objid = $P{objid} 

[adjustInventoryDetail]
UPDATE af_inventory_detail c SET  
  c.qtyreceived = c.qtyreceived + $P{qtyadjustment},  
  c.qtyending = c.qtyending + $P{qtyadjustment},  
  c.qtybegin = c.qtybegin + $P{qtyadjustment}, 
  c.endingstartseries = c.endingstartseries + $P{qtyadjustment},
  c.beginendseries = c.beginendseries + $P{qtyadjustment},
  c.receivedendseries = c.receivedendseries + $P{qtyadjustment}
WHERE controlid = $P{objid}  

[getafcontrol]
SELECT * FROM af_control where objid = $P{objid}

[getinventory]
SELECT * FROM af_inventory where objid = $P{objid}
