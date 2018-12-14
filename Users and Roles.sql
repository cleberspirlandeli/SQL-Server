SELECT p.NAME
,m.NAME
FROM sys.database_role_members rm
JOIN sys.database_principals p
ON rm.role_principal_id = p.principal_id
JOIN sys.database_principals m
ON rm.member_principal_id = m.principal_id 
where m.name = 'smar' and p.name = 'RXO00100'