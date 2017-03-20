[getList]
SELECT *
FROM subay_document_variable
WHERE name LIKE $P{searchtext}
ORDER BY sortorder ASC, objid ASC

[approve]
UPDATE subay_document_variable 
SET state = 'APPROVED'
WHERE objid = $P{objid}

[findInfo]
SELECT name, caption, datatype, arrayvalues, sortorder, category, handler
FROM subay_document_variable WHERE objid=$P{objid} 

[getLookup]
SELECT *
FROM subay_document_variable
WHERE name LIKE $P{searchtext}
ORDER BY sortorder ASC, objid ASC

[getLookupByType]
SELECT *
FROM subay_document_variable
WHERE name LIKE $P{searchtext}
AND datatype = $P{datatype}
ORDER BY sortorder ASC, objid ASC
