USE MASTER
GO
IF DB_ID('SQL_PERFORMANCE') IS NOT NULL
BEGIN
	DROP   DATABASE SQL_PERFORMANCE
	CREATE DATABASE SQL_PERFORMANCE
END
ELSE
	CREATE DATABASE SQL_PERFORMANCE
GO
USE SQL_PERFORMANCE



-- CREATING TABLES FOR EXAMPLE
-- DROP TABLE USERS
CREATE TABLE USERS(
	id			BIGINT IDENTITY(1,1),
	nameuser	VARCHAR(300),
	number1		DECIMAL(9,2),
	number2		INT,
	number3		INT
)

-- DROP TABLE DATA_MASS01
CREATE TABLE DATA_MASS01(
	id			BIGINT,
	msg1		VARCHAR(500),
	msg2		VARCHAR(300),
	msg3		VARCHAR(300),
	msg4		VARCHAR(300),
	msg5		VARCHAR(300),
	number1		BIT,
	number2		DECIMAL(15,2),
	number3		INT,
	number4		INT,
	number5		INT,
	number6		INT,
	number7		INT
)

-- DROP TABLE DATA_MASS02
CREATE TABLE DATA_MASS02(
	id			BIGINT IDENTITY(1,1),
	msg1		VARCHAR(500),
	msg2		VARCHAR(300),
	number1		BIT,
	number2		BIGINT,
	number3		INT
)












BEGIN TRAN

-- INSERTING DATA ON TABLES
DECLARE @i			BIGINT = 1,
		@nameuser	VARCHAR(300),
		@number1	DECIMAL(9,2),
		@number2	INT,
		@number3	INT,
		@numberBIT  BIT,
		@numberDM2  DECIMAL(15,2),
		@numberDM3  INT,
		@numberDM4  INT,
		@numberDM5  INT,
		@numberDM6  INT,
		@numberDM7  INT;

WHILE @i <= 3500000
BEGIN
	BEGIN TRY 
		SET @nameuser = (SELECT CONVERT(varchar(255), NEWID()))
		SET @number1  = (SELECT RAND())
		SET @number2  = @number1 * 10
		SET @number3  = CAST(REPLACE(@number1, '.','') AS INTEGER)

		IF @i / 2 = 0
			SET @numberBIT = 0
		ELSE 
			SET @numberBIT = 1
	

		INSERT INTO dbo.USERS (nameuser, number1, number2, number3)
		VALUES(@nameuser, @number1, @number2, @number3)
	

		SET @numberDM3 = (SELECT CAST(REPLACE((RAND() * 11), '.','') AS INT))
		SET @numberDM4 = (SELECT CAST(REPLACE((RAND() * 12), '.','') AS INT))
		SET @numberDM5 = (SELECT CAST(REPLACE((RAND() * 13), '.','') AS INT))
		SET @numberDM6 = (SELECT CAST(REPLACE((RAND() * 14), '.','') AS INT))
		SET @numberDM7 = (SELECT CAST(REPLACE((RAND() * 15), '.','') AS INT))

		INSERT INTO dbo.DATA_MASS01 (id, msg1, msg2, msg3, msg4, msg5,
									 number1, number2, number3, number4, number5, number6, number7)
								 --  BIT	  DECIMAL(15,2)
		VALUES(	
			@i, -- ID
			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + -- MSG1 
			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + 
			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()),

			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + -- MSG2
			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()),

			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + -- MSG3
			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()),

			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + -- MSG4
			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()),

			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + -- MSG5
			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()),

			@numberBIT,			-- @number1
			RAND() * 10,		-- @number2
			@numberDM3, -- @number3
			@numberDM4, -- @number4
			@numberDM5, -- @number5
			@numberDM6, -- @number6
			@numberDM7  -- @number7
		)


		INSERT INTO dbo.DATA_MASS02 (msg1, msg2, number1, number2, number3)
		VALUES(
			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + -- MSG1 
			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + 
			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()),

			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + -- MSG2
			CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()),

			@numberBIT, -- @number1
			CAST(REPLACE((RAND() * 35), '.','') AS INT), -- @number2
			CAST(REPLACE((RAND() * 35), '.','') AS INT)  -- @number3
		)

		IF ((@number1 * 10) < 7)
			SET @i = @i + 1
		ELSE 
			SET @i = @i + 2

		PRINT '================> ID: ' +CAST(@i AS VARCHAR(8000))
	END TRY
	BEGIN CATCH
		PRINT '================> @numberDM3: ' + CAST(@numberDM3 AS VARCHAR(8000))
		PRINT '================> @numberDM4: ' + CAST(@numberDM4 AS VARCHAR(8000))
		PRINT '================> @numberDM5: ' + CAST(@numberDM5 AS VARCHAR(8000))
		PRINT '================> @numberDM6: ' + CAST(@numberDM6 AS VARCHAR(8000))
		PRINT '================> @numberDM7: ' + CAST(@numberDM7 AS VARCHAR(8000))
	END CATCH
END



/*
DELETE USERS
DELETE DATA_MASS01
DELETE DATA_MASS02



TRUNCATE TABLE  USERS
TRUNCATE TABLE  DATA_MASS01
TRUNCATE TABLE  DATA_MASS02


ROLLBACK
COMMIT
*/
-- RANDOM CARACTER
SELECT CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID())

-- RANDOM NUMBER
DECLARE @A DECIMAL(9,2)
SET @A = (SELECT RAND())
SELECT @A, @A*10, CASE WHEN ((@A*10) > 5) THEN 'MAIOR QUE 5' ELSE 'MENOR OU 5' END


SELECT 38 / 5 AS Integer, 38 % 5 AS Remainder 

select CAST(REPLACE((RAND() * 55), '.','') AS INT)

SELECT COUNT(ID) FROM USERS		  -- 2682672
SELECT COUNT(ID) FROM DATA_MASS01 -- 2682558
SELECT COUNT(ID) FROM DATA_MASS02 -- 2682551

SELECT CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + 
		CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID()) + CONVERT(varchar(255), NEWID())


SELECT RAND() * 1000

DELETE DATA_MASS01