[getDocuments]
SELECT * FROM dts."tblDocument" 

[getCategory]
SELECT * FROM masterlistdev."tblOrdinanceResolutionCategory"

[getClassification]
SELECT * FROM masterlistdev."tblOrdinanceResolutionClassification"

[getSubjectMatter]
SELECT * FROM masterlistdev."tblOrdinanceResolutionSubjectMatter"

[getCommittee]
SELECT * FROM masterlistdev."tblOrdinanceResolutionConcernedCommittee"

[getEntity]
SELECT * FROM masterlistdev."tblOrdinanceResolutionEntity"

[getXEntity]
SELECT * FROM entity WHERE objid = $P{objid}


