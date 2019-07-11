# SQL-Server
Scripts generally in T-SQL Server

___
<br />

Date and Time Conversions Using SQL Server <br />

<br />
<br />

**FORMATO DE DATAS** <br />

Format    | Query     | Resultado Exemplo
--------- | --------- | ---------
  1	   | SELECT CONVERT(VARCHAR, GETDATE(), 1)	    | 12/30/19
  2	   | SELECT CONVERT(VARCHAR, GETDATE(), 2)	    | 19.12.30
  3	   | SELECT CONVERT(VARCHAR, GETDATE(), 3)	    | 30/12/19
  4	   | SELECT CONVERT(VARCHAR, GETDATE(), 4)	    | 30.12.19
  5	   | SELECT CONVERT(VARCHAR, GETDATE(), 5)	    | 30-12-19
  6	   | SELECT CONVERT(VARCHAR, GETDATE(), 6)	    | 30 DEC 19
  7	   | SELECT CONVERT(VARCHAR, GETDATE(), 7)	    | DEC 30, 19
  10   | SELECT CONVERT(VARCHAR, GETDATE(), 10)	    | 12-30-19
  11   | SELECT CONVERT(VARCHAR, GETDATE(), 11)	    | 19/12/30
  12   | SELECT CONVERT(VARCHAR, GETDATE(), 12)	    | 191230
  23   | SELECT CONVERT(VARCHAR, GETDATE(), 23)	    | 2019-12-30
  101  | SELECT CONVERT(VARCHAR, GETDATE(), 101)    | 12/30/2019
  102  | SELECT CONVERT(VARCHAR, GETDATE(), 102)    | 2019.12.30
  103  | SELECT CONVERT(VARCHAR, GETDATE(), 103)    | 30/12/2019
  104  | SELECT CONVERT(VARCHAR, GETDATE(), 104)    | 30.12.2019
  105  | SELECT CONVERT(VARCHAR, GETDATE(), 105)    | 30-12-2019
  106  | SELECT CONVERT(VARCHAR, GETDATE(), 106)    | 30 DEC 2019
  107  | SELECT CONVERT(VARCHAR, GETDATE(), 107)    | DEC 30, 2019
  110  | SELECT CONVERT(VARCHAR, GETDATE(), 110)    | 12-30-2019
  111  | SELECT CONVERT(VARCHAR, GETDATE(), 111)    | 2019/12/30
  112  | SELECT CONVERT(VARCHAR, GETDATE(), 112)    | 20191230

<br />
<br />

**FORMATO DE HORAS** <br />

Format    | Query     | Resultado Exemplo
--------- | --------- | ---------
8	  | SELECT CONVERT(VARCHAR, GETDATE(), 8)         | 00:38:54
14	| SELECT CONVERT(VARCHAR, GETDATE(), 14)        | 00:38:54:840
24	| SELECT CONVERT(VARCHAR, GETDATE(), 24)        | 00:38:54
108 | SELECT CONVERT(VARCHAR, GETDATE(), 108)       | 00:38:54
114 | SELECT CONVERT(VARCHAR, GETDATE(), 114)       | 00:38:54:840

<br />
<br />

**FORMATO DE DATAS E HORAS** <br />

Format | Query                                    | Resultado Exemplo
------ | ------ | ------ 
0	   | SELECT CONVERT(VARCHAR, GETDATE(), 0)    | DEC 19 2006 12:38AM
9	   | SELECT CONVERT(VARCHAR, GETDATE(), 9)    | DEC 30 2019 12:38:54:840AM
13	   | SELECT CONVERT(VARCHAR, GETDATE(), 13)   | 30 DEC 2019 00:38:54:840AM
20	   | SELECT CONVERT(VARCHAR, GETDATE(), 20)	  | 2019-12-30 00:38:54
21	   | SELECT CONVERT(VARCHAR, GETDATE(), 21)	  | 2019-12-30 00:38:54.840
22	   | SELECT CONVERT(VARCHAR, GETDATE(), 22)	  | 12/30/19 12:38:54 AM
25	   | SELECT CONVERT(VARCHAR, GETDATE(), 25)	  | 2019-12-30 00:38:54.840
100    | SELECT CONVERT(VARCHAR, GETDATE(), 100)  | DEC 30 2019 12:38AM
109    | SELECT CONVERT(VARCHAR, GETDATE(), 109)  | DEC 30 2019 12:38:54:840AM
113    | SELECT CONVERT(VARCHAR, GETDATE(), 113)  | 30 DEC 2019 00:38:54:840
120    | SELECT CONVERT(VARCHAR, GETDATE(), 120)  | 2019-12-30 00:38:54
121    | SELECT CONVERT(VARCHAR, GETDATE(), 121)  | 2019-12-30 00:38:54.840
126    | SELECT CONVERT(VARCHAR, GETDATE(), 126)  | 2019-12-30T00:38:54.840
127    | SELECT CONVERT(VARCHAR, GETDATE(), 127)  | 2019-12-30T00:38:54.840

<br />
<br />

**REMOVER PONTOS TRAÇOS**<br />

Query |   Resultado
------- | -------
SELECT REPLACE(CONVERT(VARCHAR, GETDATE(),101),'/','') | 12302019 
SELECT REPLACE(CONVERT(VARCHAR, GETDATE(),101),'/','') + <br /> REPLACE(CONVERT(VARCHAR, GETDATE(),108),':','') | 12302019004426

<br />
<br />


SQL Server Import and Export Wizard 
<br />
SQL Server Profiler
<br />
<br />
___

### License
Copyright (c) 2017 Cleber R. Spirlandeli (contato.spirlandeli@gmail.com)



![image](http://d1.awsstatic.com/logos/partners/microsoft/logo-SQLServer-vert.c0cb0df0cd1d6c8469d792abb5929239da36611a.png)
<br />
<br />
<br />
<br />

![Project Image](https://github.com/jamesqquick/markdown-worksheet/blob/master/screenshot.png)
