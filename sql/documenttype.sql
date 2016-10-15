[getList]
SELECT * 
FROM document_type 
WHERE ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name

[getLists]
SELECT *
FROM document_type
WHERE state = 'APPROVED'
  AND ( code LIKE $P{searchtext} OR name LIKE $P{searchtext} )
ORDER BY name

[getDocumentTypeOrg]
SELECT *
FROM document_type_org
WHERE objid = $P{objid}

[findOrgById]
SELECT * FROM "references"."tblOrganizationUnit"
WHERE "OrgUnitId" = ${orgid} 

[deleteDocumentTypeOrg]
DELETE FROM document_type_org WHERE objid = $P{objid} AND organizationid = $P{organizationid}

[deleteAllDocumentTypeOrg]
DELETE FROM document_type_org WHERE objid = $P{objid}

[findById]
SELECT * FROM document_type WHERE objid = $P{objid}

[approve]
UPDATE document_type SET state = 'APPROVED' WHERE objid = $P{objid}

