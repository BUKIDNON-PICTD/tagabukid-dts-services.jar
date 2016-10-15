[getList]
SELECT * 
FROM btacs_approver
WHERE ( lastname LIKE $P{searchtext} OR firstname LIKE $P{searchtext} OR middlename LIKE $P{searchtext} )
ORDER BY lastname


[getLists]
SELECT *
FROM btacs_approver
WHERE ( lastname LIKE $P{searchtext} OR firstname LIKE $P{searchtext} OR middlename LIKE $P{searchtext} )
ORDER BY lastname


[findById]
SELECT * FROM btacs_approver WHERE objid = $P{objid}

[approve]
UPDATE btacs_approver SET state = 'APPROVED' WHERE objid = $P{objid}

[getProfile]
SELECT * FROM "hrmis"."tblProfile"
WHERE UPPER("Name_LastName") LIKE $P{searchtext} 
OR UPPER("Name_FirstName") LIKE $P{searchtext} 
OR UPPER("Name_MiddleName") LIKE $P{searchtext} 
ORDER BY "Name_LastName"

[getSignatoryList]
SELECT * FROM Signatory 
WHERE UPPER(NAME) LIKE $P{searchtext} 
ORDER BY NAME

[getLeaveClassList]
SELECT * FROM LeaveClass 
WHERE UPPER(LeaveName) LIKE $P{searchtext} 
ORDER BY LeaveName