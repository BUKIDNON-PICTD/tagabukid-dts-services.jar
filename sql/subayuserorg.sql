[getList]
SELECT * 
FROM subay_user_organization
WHERE 
${filter} 

[getEtracsUser]
SELECT *
FROM sys_user
WHERE (username LIKE $P{searchtext} 
OR name LIKE $P{searchtext}
OR firstname LIKE $P{searchtext}
OR lastname LIKE $P{searchtext}
OR middlename LIKE $P{searchtext})
ORDER BY lastname

[getOrgById]
SELECT * FROM subay_org_unit
WHERE OrgUnitId = ${orgid} 

[findById]
SELECT * FROM subay_user_organization WHERE objid = $P{objid}

[approve]
UPDATE subay_user_organization SET state = 'APPROVED' WHERE objid = $P{objid}

[getUserByOrg]
SELECT * 
FROM subay_user_organization
WHERE organizationid = $P{orgid}
