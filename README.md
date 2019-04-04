# SQL-Server
Scripts generally in T-SQL Server

___

Date and Time Conversions Using SQL Server
**Formato de Datas**
**Format - Query                                    - Resultado Exemplo** <br />
  1	     - SELECT CONVERT(VARCHAR, GETDATE(), 1)	  - 12/30/19 <br />
  2	     - SELECT CONVERT(VARCHAR, GETDATE(), 2)	  - 19.12.30 <br />
  3	     - SELECT CONVERT(VARCHAR, GETDATE(), 3)	  - 30/12/19 <br />
  4	     - SELECT CONVERT(VARCHAR, GETDATE(), 4)	  - 30.12.19 <br />
  5	     - SELECT CONVERT(VARCHAR, GETDATE(), 5)	  - 30-12-19 <br />
  6	     - SELECT CONVERT(VARCHAR, GETDATE(), 6)	  - 30 DEC 19 <br />
  7	     - SELECT CONVERT(VARCHAR, GETDATE(), 7)	  - DEC 30, 19 <br />
  10	   - SELECT CONVERT(VARCHAR, GETDATE(), 10)	  - 12-30-19 <br />
  11	   - SELECT CONVERT(VARCHAR, GETDATE(), 11)	  - 19/12/30 <br />
  12	   - SELECT CONVERT(VARCHAR, GETDATE(), 12)	  - 191230 <br />
  23	   - SELECT CONVERT(VARCHAR, GETDATE(), 23)	  - 2019-12-30 <br />
  101    - SELECT CONVERT(VARCHAR, GETDATE(), 101)	- 12/30/2019 <br />
  102    - SELECT CONVERT(VARCHAR, GETDATE(), 102)	- 2019.12.30 <br />
  103    - SELECT CONVERT(VARCHAR, GETDATE(), 103)	- 30/12/2019 <br />
  104    - SELECT CONVERT(VARCHAR, GETDATE(), 104)	- 30.12.2019 <br />
  105    - SELECT CONVERT(VARCHAR, GETDATE(), 105)	- 30-12-2019 <br />
  106    - SELECT CONVERT(VARCHAR, GETDATE(), 106)	- 30 DEC 2019 <br />
  107    - SELECT CONVERT(VARCHAR, GETDATE(), 107)	- DEC 30, 2019 <br />
  110    - SELECT CONVERT(VARCHAR, GETDATE(), 110)	- 12-30-2019 <br />
  111    - SELECT CONVERT(VARCHAR, GETDATE(), 111)	- 2019/12/30 <br />
  112    - SELECT CONVERT(VARCHAR, GETDATE(), 112)	- 20191230 <br />



**Formato de Horas** 
**Format - Query                                    - Resultado Exemplo** <br />
8	  - SELECT CONVERT(VARCHAR, GETDATE(), 8)   - 00:38:54
14	- SELECT CONVERT(VARCHAR, GETDATE(), 14)  - 00:38:54:840
24	- SELECT CONVERT(VARCHAR, GETDATE(), 24)  - 00:38:54
108 - SELECT CONVERT(VARCHAR, GETDATE(), 108) - 00:38:54
114 - SELECT CONVERT(VARCHAR, GETDATE(), 114) - 00:38:54:840
