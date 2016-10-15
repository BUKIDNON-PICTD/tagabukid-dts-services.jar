[getList]
SELECT * 
FROM ordinanceclassification 
WHERE ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name

[getLists]
SELECT *
FROM ordinanceclassification
WHERE state = 'APPROVED'
  AND ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name


[findById]
SELECT * FROM ordinanceclassification WHERE objid = $P{objid}

[approve]
UPDATE ordinanceclassification SET state = 'APPROVED' WHERE objid = $P{objid}

