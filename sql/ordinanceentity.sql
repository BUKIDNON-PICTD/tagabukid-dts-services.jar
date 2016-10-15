[getList]
SELECT * 
FROM ordinanceentity

[getEntityList]
SELECT 
	e.objid, e.entityno, e.name, e.address_text, e.address_objid, e.type, 
	(SELECT bldgno FROM entity_address WHERE objid=e.address_objid) as address_bldgno, 
	(SELECT bldgname FROM entity_address WHERE objid=e.address_objid) as address_bldgname,  
	(SELECT unitno FROM entity_address WHERE objid=e.address_objid) as address_unitno , 
	(SELECT street FROM entity_address WHERE objid=e.address_objid) as address_street ,  
	(SELECT subdivision FROM entity_address WHERE objid=e.address_objid) as address_subdivision, 
	(SELECT barangay_name FROM entity_address WHERE objid=e.address_objid) as address_barangay_name, 
	(SELECT city FROM entity_address WHERE objid=e.address_objid) as address_city, 
	(SELECT municipality FROM entity_address WHERE objid=e.address_objid) as address_municipality, 
	(SELECT province FROM entity_address WHERE objid=e.address_objid) as address_province 
FROM entity e 
WHERE e.entityname LIKE $P{searchtext} 
 ${filter} 
ORDER BY e.entityname 

[getLists]
SELECT *
FROM ordinanceentity



[findById]
SELECT * FROM ordinanceentity WHERE objid = $P{objid}

[approve]
UPDATE ordinanceentity SET state = 'APPROVED' WHERE objid = $P{objid}

