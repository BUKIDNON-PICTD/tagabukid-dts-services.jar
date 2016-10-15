[getList]
SELECT * 
FROM ordinancecategory 
WHERE ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name

[getLists]
SELECT *
FROM ordinancecategory
WHERE state = 'APPROVED'
  AND ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name


[findById]
SELECT * FROM ordinancecategory WHERE objid = $P{objid}

[approve]
UPDATE ordinancecategory SET state = 'APPROVED' WHERE objid = $P{objid}

