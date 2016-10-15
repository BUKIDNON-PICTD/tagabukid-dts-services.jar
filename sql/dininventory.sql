[getList]
SELECT * 
FROM din_inventory
ORDER BY recordlog_datecreated

[findById]
SELECT * FROM din_inventory WHERE objid = $P{objid}

[approve]
UPDATE din_inventory SET state = 'APPROVED' WHERE objid = $P{objid}

[findCurrentSeries]
SELECT nextSeries AS currentSeries FROM sys_sequence WHERE objid = $P{objid} 

[incrementNextSeries]
UPDATE sys_sequence SET nextSeries = nextSeries + $P{dincount} WHERE objid = $P{objid} 

