SELECT 
       p.NAME,
       m.NAME
  FROM sys.database_role_members rm
  INNER JOIN sys.database_principals p ON p.principal_id = rm.role_principal_id
  INNER JOIN sys.database_principals m ON m.principal_id = rm.member_principal_id
  WHERE m.name = 'NAMEUSER' and p.name = 'RXO00100' -- ROLE
