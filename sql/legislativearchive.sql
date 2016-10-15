[getList]
SELECT * 
FROM legislativearchive 
WHERE ( ordresno LIKE $P{searchtext} OR rsno LIKE $P{searchtext} OR spno LIKE $P{searchtext} 
OR title LIKE $P{searchtext} OR remarks LIKE $P{searchtext} )
${filter}
ORDER BY ordresno

[getLists]
SELECT *
FROM legislativearchive
WHERE ( ordresno LIKE $P{searchtext} OR rsno LIKE $P{searchtext} OR spno LIKE $P{searchtext} 
OR title LIKE $P{searchtext} OR remarks LIKE $P{searchtext} )
ORDER BY ordresno


[findById]
SELECT * FROM legislativearchive WHERE objid = $P{objid}

[getlegislativearchiveauthor]
SELECT o.* FROM legislativearchive_authors l
INNER JOIN ordinanceentity o ON o.objid = l.ordinanceentityid
WHERE l.objid = $P{objid}

[getlegislativearchivecoauthor]
SELECT o.* FROM legislativearchive_coauthors l
INNER JOIN ordinanceentity o ON o.objid = l.ordinanceentityid
WHERE l.objid = $P{objid}

[getlegislativearchivecommittee]
SELECT o.* FROM legislativearchive_committee l
INNER JOIN ordinancecommittee o ON o.objid = l.ordinancecommitteeid
WHERE l.objid = $P{objid}

[getlegislativearchiveclassification]
SELECT o.* FROM legislativearchive_classification l
INNER JOIN ordinanceclassification o ON o.objid = l.ordinanceclassificationid
WHERE l.objid = $P{objid}

[getlegislativearchivecategory]
SELECT o.* FROM legislativearchive_category l
INNER JOIN ordinancecategory o ON o.objid = l.ordinancecategoryid
WHERE l.objid = $P{objid}

[getlegislativearchivesubjectmatter]
SELECT * FROM legislativearchive_subjectmatter l
INNER JOIN ordinancesubjectmatter o ON o.objid = l.ordinancesubjectmatterid
WHERE l.objid = $P{objid}

[deleteCategory]
DELETE FROM legislativearchive_category WHERE objid = $P{objid} AND ordinancecategoryid = $P{ordinancecategoryid}
[deleteClassification]
DELETE FROM legislativearchive_classification WHERE objid = $P{objid} AND ordinanceclassificationid = $P{ordinanceclassificationid}
[deleteSubjectMatter]
DELETE FROM legislativearchive_subjectmatter WHERE objid = $P{objid} AND ordinancesubjectmatterid = $P{ordinancesubjectmatterid}
[deleteCommittee]
DELETE FROM legislativearchive_committee WHERE objid = $P{objid} AND ordinancecommitteeid = $P{ordinancecommitteeid}
[deleteAuthor]
DELETE FROM legislativearchive_authors WHERE objid = $P{objid} AND ordinanceentityid = $P{ordinanceentityid}
[deleteCoAuthor]
DELETE FROM legislativearchive_coauthors WHERE objid = $P{objid} AND ordinanceentityid = $P{ordinanceentityid}

[deleteAllCategoryItems]
DELETE FROM legislativearchive_category WHERE objid = $P{objid}
[deleteAllClassificationItems]
DELETE FROM legislativearchive_classification WHERE objid = $P{objid}
[deleteAllSubjectMatterItems]
DELETE FROM legislativearchive_subjectmatter WHERE objid = $P{objid}
[deleteAllCommitteeItems]
DELETE FROM legislativearchive_committee WHERE objid = $P{objid}
[deleteAllAuthorItems]
DELETE FROM legislativearchive_authors WHERE objid = $P{objid}
[deleteAllCoAuthorItems]
DELETE FROM legislativearchive_coauthors WHERE objid = $P{objid}

[approve]
UPDATE legislativearchive 
SET state = 'APPROVED'
WHERE objid = $P{objid}


[updatestate]
UPDATE legislativearchive 
SET state = $P{state},
recordlog_dateoflastupdate = $P{recordlog_dateoflastupdate},
recordlog_lastupdatedbyuserid = $P{recordlog_lastupdatedbyuserid},
recordlog_lastupdatedbyuser = $P{recordlog_lastupdatedbyuser}
WHERE objid = $P{objid}

[getArchive]
SELECT * FROM legislativearchive;


