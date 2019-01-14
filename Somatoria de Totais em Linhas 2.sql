
 /*
 SELECT TOP 10
       * 
  FROM DATA_MASS01
 WHERE id < 1000030
 ORDER BY id
 */



SELECT TOP 5
       *
  FROM USERS
 WHERE id < 1000030
 ORDER BY id



 SELECT description = 'Mounth', 
		january		= MAX(CASE 
						   WHEN Y.number2 = 1 THEN Y.number2
						   ELSE 0.00 
					  END),
		february	= MAX(CASE 
						   WHEN Y.number2 = 2 THEN Y.number2
						   ELSE 0.00 
					  END),
		march		= MAX(CASE 
						   WHEN Y.number2 = 3 THEN Y.number2
						   ELSE 0.00 
					  END),
		april		= MAX(CASE 
						   WHEN Y.number2 = 4 THEN Y.number2
						   ELSE 0.00 
					  END),
		may			= MAX(CASE 
						   WHEN Y.number2 = 5 THEN Y.number2
						   ELSE 0.00 
					  END),
		june		= MAX(CASE 
						   WHEN Y.number2 = 6 THEN Y.number2
						   ELSE 0.00 
					  END),
		july		= MAX(CASE 
						   WHEN Y.number2 = 7 THEN Y.number2
						   ELSE 0.00 
					  END),
		august		= MAX(CASE 
						   WHEN Y.number2 = 8 THEN Y.number2
						   ELSE 0.00 
					  END),
		september	= MAX(CASE 
						   WHEN Y.number2 = 9 THEN Y.number2
						   ELSE 0.00 
					  END),
		october		= MAX(CASE 
						   WHEN Y.number2 = 10 THEN Y.number2
						   ELSE 0.00 
					  END),
		november	= MAX(CASE 
						   WHEN Y.number2 = 0 THEN 11
						   ELSE 0.00 
					  END),
		december	= MAX(CASE 
						   WHEN Y.number2 = 10 THEN Y.number2
						   ELSE 0.00 
					  END) +
					  MAX(CASE 
						   WHEN Y.number2 = 2 THEN Y.number2
						   ELSE 0.00 
					  END)
   FROM USERS USR
  INNER JOIN (SELECT 
					 X.number2,
					 total = SUM(number1)
			    FROM USERS X
			   GROUP BY X.number2
			 ) Y ON Y.number2 = USR.number2

UNION ALL

 SELECT description = 'Total',
		january		= MAX(CASE 
						   WHEN Y.number2 = 1 THEN Y.total
						   ELSE 0.00 
					  END),
		february	= MAX(CASE 
						   WHEN Y.number2 = 2 THEN Y.total
						   ELSE 0.00 
					  END),
		march		= MAX(CASE 
						   WHEN Y.number2 = 3 THEN Y.total
						   ELSE 0.00 
					  END),
		april		= MAX(CASE 
						   WHEN Y.number2 = 4 THEN Y.total
						   ELSE 0.00 
					  END),
		may			= MAX(CASE 
						   WHEN Y.number2 = 5 THEN Y.total
						   ELSE 0.00 
					  END),
		june		= MAX(CASE 
						   WHEN Y.number2 = 6 THEN Y.total
						   ELSE 0.00 
					  END),
		july		= MAX(CASE 
						   WHEN Y.number2 = 7 THEN Y.total
						   ELSE 0.00 
					  END),
		august		= MAX(CASE 
						   WHEN Y.number2 = 8 THEN Y.total
						   ELSE 0.00 
					  END),
		september	= MAX(CASE 
						   WHEN Y.number2 = 9 THEN Y.total
						   ELSE 0.00 
					  END),
		october		= MAX(CASE 
						   WHEN Y.number2 = 10 THEN Y.total
						   ELSE 0.00 
					  END),
		november	= MAX(CASE 
						   WHEN Y.number2 = 0 THEN Y.total
						   ELSE 0.00 
					  END),
		december	= MAX(CASE 
						   WHEN Y.number2 = 1 THEN Y.total
						   ELSE 0.00 
					  END) +
					  MAX(CASE 
						   WHEN Y.number2 = 2 THEN Y.total
						   ELSE 0.00 
					  END)
   FROM USERS USR
  INNER JOIN (SELECT 
					 X.number2,
					 total = SUM(number1)
			    FROM USERS X
			   GROUP BY X.number2
			 ) Y ON Y.number2 = USR.number2

