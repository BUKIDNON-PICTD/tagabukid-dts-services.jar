[getList]
SELECT * 
FROM ordinancecommittee
WHERE ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name

[getLists]
SELECT *
FROM ordinancecommittee
WHERE state = 'APPROVED'
  AND ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name


[findById]
SELECT * FROM ordinancecommittee WHERE objid = $P{objid}

[approve]
UPDATE ordinancecommittee SET state = 'APPROVED' WHERE objid = $P{objid}

