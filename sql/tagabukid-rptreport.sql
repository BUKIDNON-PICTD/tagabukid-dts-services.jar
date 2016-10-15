[getFormNo3Taxable]
SELECT p.`name`,
(SELECT COUNT(*) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.classification_objid = p.objid AND r.rputype = 'land' AND f.txntimestamp LIKE $P{currenttimestamp} ) AS noofrpus,
(SELECT IFNULL(SUM(totalareasqm),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.classification_objid = p.objid AND r.rputype = 'land' AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp} ) AS landareasqm,
@4:=(SELECT IFNULL(SUM(totalbmv),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.classification_objid = p.objid AND r.rputype = 'land' AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp} ) AS totallandmv,
@5:=(SELECT IFNULL(SUM(totalbmv),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.classification_objid = p.objid AND r.rputype = 'bldg' AND totalmv > 175000 AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp} ) AS totalbldgmvgt175,
@6:=(SELECT IFNULL(SUM(totalbmv),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.classification_objid = p.objid AND r.rputype = 'bldg' AND totalmv < 175000 AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp} ) AS totalbldgmvlt175,
@7:=(SELECT IFNULL(SUM(totalbmv),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.classification_objid = p.objid AND r.rputype = 'mach' AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp} ) AS totalmachmv,
@8:= (SELECT IFNULL(SUM(totalbmv),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.classification_objid = p.objid AND r.rputype NOT IN ('land','bldg','mach') AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp} ) AS totalothermv,
CAST(@9:=@4+@5+@6+@7+@8 AS DECIMAL(12,4))AS totalmv,
@10:=(SELECT IFNULL(SUM(totalav),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.classification_objid = p.objid AND r.rputype = 'land' AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp} ) AS totallandav,
@11:=(SELECT IFNULL(SUM(totalav),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.classification_objid = p.objid AND r.rputype = 'bldg' AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp} ) AS totalbldgav,
@12:=(SELECT IFNULL(SUM(totalav),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.classification_objid = p.objid AND r.rputype = 'mach' AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp} ) AS totalmachav,
@13:= (SELECT IFNULL(SUM(totalav),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.classification_objid = p.objid AND r.rputype NOT IN ('land','bldg','mach') AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp} ) AS totalotherav,
CAST(@14:=@10+@11+@12+@13 AS DECIMAL(12,4))AS totalav,
@15:=(SELECT IFNULL(SUM(totalav),0.0)
FROM
faas f
INNER JOIN rpu r ON f.rpuid = r.objid
WHERE r.classification_objid = p.objid AND f.restrictionid = 'CARP' AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp}) AS restrictioncarp,
@16:=(SELECT IFNULL(SUM(totalav),0.0)
FROM
faas f
INNER JOIN rpu r ON f.rpuid = r.objid
WHERE r.classification_objid = p.objid AND f.restrictionid = 'UNDER_LITIGATION' AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp}) AS restrictionulitigation,
@17:=(SELECT IFNULL(SUM(totalav),0.0)
FROM
faas f
INNER JOIN rpu r ON f.rpuid = r.objid
WHERE r.classification_objid = p.objid AND f.restrictionid = 'OTHER' AND r.exemptiontype_objid IS NULL AND f.txntimestamp LIKE $P{currenttimestamp}) AS restrictionother,
CAST(@18:=@14+@15+@16+@17 AS DECIMAL(12,4)) AS totalnetavwithrestriction,
CAST(@14 * 0.01 AS DECIMAL(12,4)) AS  collectiblebasic,
CAST(@14 * 0.01 AS DECIMAL(12,4)) AS collectiblesef
FROM
propertyclassification p
ORDER BY p.orderno


[getFormNo3Exempt]
SELECT e.`name`,
(SELECT COUNT(*) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.exemptiontype_objid = e.objid AND r.rputype = 'land'  AND f.txntimestamp LIKE $P{currenttimestamp}) AS noofrpus,
(SELECT IFNULL(SUM(totalareasqm),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.exemptiontype_objid = e.objid AND r.rputype = 'land'  AND f.txntimestamp LIKE $P{currenttimestamp}) AS landareasqm,
@4:=(SELECT IFNULL(SUM(totalbmv),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.exemptiontype_objid = e.objid AND r.rputype = 'land'  AND f.txntimestamp LIKE $P{currenttimestamp}) AS totallandmv,
@5:=(SELECT IFNULL(SUM(totalbmv),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.exemptiontype_objid = e.objid AND r.rputype = 'bldg' AND totalmv > 175000  AND f.txntimestamp LIKE $P{currenttimestamp}) AS totalbldgmvgt175,
@6:=(SELECT IFNULL(SUM(totalbmv),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.exemptiontype_objid = e.objid AND r.rputype = 'bldg' AND totalmv < 175000  AND f.txntimestamp LIKE $P{currenttimestamp}) AS totalbldgmvlt175,
@7:=(SELECT IFNULL(SUM(totalbmv),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.exemptiontype_objid = e.objid AND r.rputype = 'mach'  AND f.txntimestamp LIKE $P{currenttimestamp}) AS totalmachmv,
@8:= (SELECT IFNULL(SUM(totalbmv),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.exemptiontype_objid = e.objid AND r.rputype NOT IN ('land','bldg','mach')   AND f.txntimestamp LIKE $P{currenttimestamp}) AS totalothermv,
CAST(@9:=@4+@5+@6+@7+@8 AS DECIMAL(12,4)) AS totalmv,
@10:=(SELECT IFNULL(SUM(totalav),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.exemptiontype_objid = e.objid AND r.rputype = 'land'  AND f.txntimestamp LIKE $P{currenttimestamp}) AS totallandav,
@11:=(SELECT IFNULL(SUM(totalav),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.exemptiontype_objid = e.objid AND r.rputype = 'bldg'  AND f.txntimestamp LIKE $P{currenttimestamp}) AS totalbldgav,
@12:=(SELECT IFNULL(SUM(totalav),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.exemptiontype_objid = e.objid AND r.rputype = 'mach'  AND f.txntimestamp LIKE $P{currenttimestamp}) AS totalmachav,
@13:= (SELECT IFNULL(SUM(totalav),0.0) FROM rpu r INNER JOIN faas f ON f.rpuid = r.objid WHERE r.exemptiontype_objid = e.objid AND r.rputype NOT IN ('land','bldg','mach')  AND f.txntimestamp LIKE $P{currenttimestamp}) AS totalotherav,
CAST(@14:=@10+@11+@12+@13 AS DECIMAL(12,4)) AS totalav
FROM
exemptiontype e
ORDER BY e.orderno

[getStatAgriLandUse]
SELECT b.`name`,
@1:=(SELECT ifnull(SUM(l.area),0) FROM lcuvspecificclass
INNER JOIN landdetail l ON l.specificclass_objid = lcuvspecificclass.objid
INNER JOIN landrpu m ON l.landrpuid = m.objid
INNER JOIN rpu n ON m.objid = n.objid
INNER JOIN faas o ON o.rpuid = n.objid
INNER JOIN realproperty p ON o.realpropertyid = p.objid
WHERE lcuvspecificclass.`name` = 'RICE LAND (UPLAND)' AND p.barangayid = b.objid) as riceu,
@2:=(SELECT ifnull(SUM(l.area),0) FROM lcuvspecificclass
INNER JOIN landdetail l ON l.specificclass_objid = lcuvspecificclass.objid
INNER JOIN landrpu m ON l.landrpuid = m.objid
INNER JOIN rpu n ON m.objid = n.objid
INNER JOIN faas o ON o.rpuid = n.objid
INNER JOIN realproperty p ON o.realpropertyid = p.objid
WHERE lcuvspecificclass.`name` = 'RICE LAND (LOWLAND-W/O IRRIGATION FACILITIES)' AND p.barangayid = b.objid ) as ricewo,
@3:=(SELECT ifnull(SUM(l.area),0) FROM lcuvspecificclass
INNER JOIN landdetail l ON l.specificclass_objid = lcuvspecificclass.objid
INNER JOIN landrpu m ON l.landrpuid = m.objid
INNER JOIN rpu n ON m.objid = n.objid
INNER JOIN faas o ON o.rpuid = n.objid
INNER JOIN realproperty p ON o.realpropertyid = p.objid
WHERE lcuvspecificclass.`name` = 'RICE LAND (LOWLAND-W/ IRRIGATION FACILITIES)' AND p.barangayid = b.objid  ) as ricewi,
CAST(@4:=@1+@2+@3 as DECIMAL(14,4)) as totalrice,
(SELECT ifnull(SUM(l.area),0) FROM lcuvspecificclass
INNER JOIN landdetail l ON l.specificclass_objid = lcuvspecificclass.objid
INNER JOIN landrpu m ON l.landrpuid = m.objid
INNER JOIN rpu n ON m.objid = n.objid
INNER JOIN faas o ON o.rpuid = n.objid
INNER JOIN realproperty p ON o.realpropertyid = p.objid
WHERE lcuvspecificclass.`name` = 'CORN LAND' AND p.barangayid = b.objid) as corn,
(SELECT ifnull(SUM(l.area),0) FROM lcuvspecificclass
INNER JOIN landdetail l ON l.specificclass_objid = lcuvspecificclass.objid
INNER JOIN landrpu m ON l.landrpuid = m.objid
INNER JOIN rpu n ON m.objid = n.objid
INNER JOIN faas o ON o.rpuid = n.objid
INNER JOIN realproperty p ON o.realpropertyid = p.objid
WHERE lcuvspecificclass.`name` = 'RUBBER LAND' AND p.barangayid = b.objid) as rubber,
(SELECT ifnull(SUM(l.area),0) FROM lcuvspecificclass
INNER JOIN landdetail l ON l.specificclass_objid = lcuvspecificclass.objid
INNER JOIN landrpu m ON l.landrpuid = m.objid
INNER JOIN rpu n ON m.objid = n.objid
INNER JOIN faas o ON o.rpuid = n.objid
INNER JOIN realproperty p ON o.realpropertyid = p.objid
WHERE lcuvspecificclass.`name` = 'SUGAR LAND' AND p.barangayid = b.objid) as sugar,
@5:=(SELECT ifnull(SUM(l.area),0) FROM lcuvspecificclass
INNER JOIN landdetail l ON l.specificclass_objid = lcuvspecificclass.objid
INNER JOIN landrpu m ON l.landrpuid = m.objid
INNER JOIN rpu n ON m.objid = n.objid
INNER JOIN faas o ON o.rpuid = n.objid
INNER JOIN realproperty p ON o.realpropertyid = p.objid
WHERE lcuvspecificclass.`name` = 'BANANA LAND (LOCAL)' AND p.barangayid = b.objid) as bananaloc,
@6:=(SELECT ifnull(SUM(l.area),0) FROM lcuvspecificclass
INNER JOIN landdetail l ON l.specificclass_objid = lcuvspecificclass.objid
INNER JOIN landrpu m ON l.landrpuid = m.objid
INNER JOIN rpu n ON m.objid = n.objid
INNER JOIN faas o ON o.rpuid = n.objid
INNER JOIN realproperty p ON o.realpropertyid = p.objid
WHERE lcuvspecificclass.`name` = 'BANANA LAND (EXPORT)' AND p.barangayid = b.objid) as bananaex,
CAST(@7:=@5+@6 as DECIMAL (14,4)) as totalbanana,
(SELECT ifnull(SUM(l.area),0) FROM lcuvspecificclass
INNER JOIN landdetail l ON l.specificclass_objid = lcuvspecificclass.objid
INNER JOIN landrpu m ON l.landrpuid = m.objid
INNER JOIN rpu n ON m.objid = n.objid
INNER JOIN faas o ON o.rpuid = n.objid
INNER JOIN realproperty p ON o.realpropertyid = p.objid
WHERE lcuvspecificclass.`name` = 'COCONUT LAND' AND p.barangayid = b.objid) as coconut,
(SELECT ifnull(SUM(l.area),0) FROM lcuvspecificclass
INNER JOIN landdetail l ON l.specificclass_objid = lcuvspecificclass.objid
INNER JOIN landrpu m ON l.landrpuid = m.objid
INNER JOIN rpu n ON m.objid = n.objid
INNER JOIN faas o ON o.rpuid = n.objid
INNER JOIN realproperty p ON o.realpropertyid = p.objid
WHERE lcuvspecificclass.`name` = 'COFFEE LAND' AND p.barangayid = b.objid) as coffee,
(SELECT ifnull(SUM(l.area),0) FROM lcuvspecificclass
INNER JOIN landdetail l ON l.specificclass_objid = lcuvspecificclass.objid
INNER JOIN landrpu m ON l.landrpuid = m.objid
INNER JOIN rpu n ON m.objid = n.objid
INNER JOIN faas o ON o.rpuid = n.objid
INNER JOIN realproperty p ON o.realpropertyid = p.objid
WHERE lcuvspecificclass.`name` = 'ORCHARD LAND' AND p.barangayid = b.objid) as orchard,
(SELECT ifnull(SUM(l.area),0) FROM lcuvspecificclass
INNER JOIN landdetail l ON l.specificclass_objid = lcuvspecificclass.objid
INNER JOIN landrpu m ON l.landrpuid = m.objid
INNER JOIN rpu n ON m.objid = n.objid
INNER JOIN faas o ON o.rpuid = n.objid
INNER JOIN realproperty p ON o.realpropertyid = p.objid
WHERE lcuvspecificclass.`name` = 'PASTURE/GRAZELAND' AND p.barangayid = b.objid) as pasture
FROM 
barangay b
ORDER BY b.indexno



