

/* ====================== */
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.Columns WHERE TABLE_NAME = 'RAT11000' ORDER BY ordinal_position; 



/* ====================== */
SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.TYPE where TABLE_NAME = 'RAT11000';



/* ====================== */
SELECT COUNT(COLUMN_NAME) 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_CATALOG = 'SMARapd' AND TABLE_SCHEMA = 'dbo'
AND TABLE_NAME = 'RAT11000' 



/* ====================== */
exec sp_columns 'RAT11000'



/* ====================== */
select COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
       NUMERIC_PRECISION, DATETIME_PRECISION, 
       IS_NULLABLE 
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME= 'RAT11000'
order by COLUMN_NAME
