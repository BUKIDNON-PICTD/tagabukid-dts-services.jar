
[getPlantTreeAssessmentTagabukid]
SELECT 
	'PLANT/TREE' AS propertytype,
	pt.name AS planttreename,
	ptuv.name AS subname, 
	pc.code AS classcode,
	pc.name AS classification,
	ptal.code AS actualusecode,
	ptal.name AS actualuse,
	bra.assesslevel, 
	ptd.`marketvalue`,
	ptd.assessedvalue,
	ptd.`areacovered` AS AREA,
	'SQM' AS areatype
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN rpu_assessment bra ON r.objid = bra.rpuid 
	INNER JOIN planttreeassesslevel ptal ON bra.actualuse_objid = ptal.objid 
	INNER JOIN planttreedetail ptd ON ptd.`landrpuid` = f.`rpuid`
	INNER JOIN planttree pt ON ptd.planttree_objid = pt.objid 
	INNER JOIN planttreeunitvalue ptuv  ON ptd.planttreeunitvalue_objid = ptuv.objid 
WHERE f.objid = $P{faasid}		