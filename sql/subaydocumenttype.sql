[getList]
SELECT * 
FROM subay_document_type 
WHERE ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name

[getLists]
SELECT *
FROM subay_document_type
WHERE state = 'APPROVED'
  AND ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name

[getDocumentTypeOrg]
SELECT *
FROM subay_document_type_org
WHERE objid = $P{objid}

[findOrgById]
SELECT * FROM subay_org_unit
WHERE OrgUnitId = ${orgid} 

[deleteDocumentTypeOrg]
DELETE FROM subay_document_type_org WHERE objid = $P{objid} AND organizationid = $P{organizationid}

[deleteAllDocumentTypeOrg]
DELETE FROM subay_document_type_org WHERE objid = $P{objid}

[findById]
SELECT * FROM subay_document_type WHERE objid = $P{objid}

[approve]
UPDATE subay_document_type SET state = 'APPROVED' WHERE objid = $P{objid}

