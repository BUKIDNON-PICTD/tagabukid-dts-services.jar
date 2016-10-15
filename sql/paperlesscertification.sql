[getList]
SELECT * 
FROM certification
WHERE (title like $P{searchtext}
or bldglocation like $P{searchtext}
or outdate like $P{searchtext}
or statuses like $P{searchtext}
or applications like $P{searchtext})
${filter}
order by outdate asc

[getLookup]
SELECT r.* FROM bldglocation r 
WHERE  (r.name LIKE $P{name})
${filter}
ORDER BY r.name

[getLookupInvOff]
SELECT r.* FROM involvedoffices r 
WHERE  (r.name LIKE $P{name})
${filter}
ORDER BY r.name

[getCertificationReport]
select * from certification c 
inner join offices o on o.certid = c.objid
where c.objid = $P{objid}

[getCertitems]
select *
from offices
where certid = $P{objid}

[updatestate]
UPDATE certification 
SET state = $P{state},
recordlog_dateoflastupdate = $P{recordlog_dateoflastupdate},
recordlog_lastupdatedbyuserid = $P{recordlog_lastupdatedbyuserid},
recordlog_lastupdatedbyuser = $P{recordlog_lastupdatedbyuser}
WHERE objid = $P{objid}