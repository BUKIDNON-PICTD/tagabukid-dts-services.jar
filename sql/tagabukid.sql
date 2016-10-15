[getitemfortransmittal]
SELECT xx.state,
xx.objid as refid,
'faas' as filetype,
xx.txntype_objid,
xx.tdno,
xx.owner_name,
xx.owner_address,
xx.fullpin,
CASE WHEN xx.cadastrallotno IS NULL THEN '-' ELSE xx.cadastrallotno END AS cadastrallotno,
xx.totalareaha,
xx.totalareasqm,
xx.totalmv,
xx.totalav,
null
FROM (SELECT 
	f.*,
	pc.code AS classification_code, 
	pc.code AS classcode, 
	pc.name AS classification_name, 
	pc.name AS classname, 
	r.ry, r.realpropertyid as realpropertyid2, r.rputype, r.fullpin as fullpin2, r.totalmv, r.totalav,
	r.totalareasqm, r.totalareaha, r.suffix, 
	rp.barangayid, rp.cadastrallotno, rp.blockno, rp.surveyno, rp.lgutype as lgutype2, rp.pintype, 
	rp.section, rp.parcel, 
	b.name AS barangay_name,
	t.trackingno
FROM faas f
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	LEFT JOIN rpttracking t ON f.objid = t.objid 
WHERE 1=1  AND f.state <> 'PENDING' AND f.state IN ('CURRENT','CANCELLED')	
ORDER BY f.tdno)xx;