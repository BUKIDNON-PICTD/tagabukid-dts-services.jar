[getList]
SELECT * 
FROM ordinancesubjectmatter 
WHERE ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name

[getLists]
SELECT *
FROM ordinancesubjectmatter
WHERE state = 'APPROVED'
  AND ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name


[findById]
SELECT * FROM ordinancesubjectmatter WHERE objid = $P{objid}

[approve]
UPDATE ordinancesubjectmatter SET state = 'APPROVED' WHERE objid = $P{objid}

