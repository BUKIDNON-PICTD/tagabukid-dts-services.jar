[getList]
SELECT di.*,ty.`Entity_Name` AS org_name,ty.`Entity_AcronymAbbreviation` AS org_code
FROM subay_din_inventory di
INNER JOIN subay_org_unit ty ON ty.`OrgUnitId` = di.`org_objid`
ORDER BY recordlog_datecreated DESC

[findById]
SELECT * FROM subay_din_inventory WHERE objid = $P{objid}

[approve]
UPDATE subay_din_inventory SET state = 'APPROVED' WHERE objid = $P{objid}

[findCurrentSeries]
SELECT nextSeries AS currentSeries FROM sys_sequence WHERE objid = $P{objid} 

[incrementNextSeries]
UPDATE sys_sequence SET nextSeries = nextSeries + $P{dincount} WHERE objid = $P{objid} 

