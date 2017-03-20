[getDocumentInfos]
SELECT di.*, 
d.caption  AS attribute_caption, 
d.datatype AS attribute_datatype, 
d.sortorder AS attribute_sortorder,
d.category AS attribute_category,
d.handler AS attribute_handler
FROM subay_document_info di 
INNER JOIN subay_document_variable d ON d.objid=di.attribute_objid
WHERE di.documentid=$P{documentid} AND di.type = 'documentinfo'
ORDER BY d.category, d.sortorder 

[removeDocumentInfos]
DELETE FROM subay_document_info WHERE documentid=$P{documentid} AND type = 'documentinfo'

[cleanupInfos]
DELETE FROM subay_document_info 
WHERE documentid=$P{documentid} 
	AND documenttype_objid IS NOT NULL 
	AND documenttype_objid <> $P{documenttypeid}