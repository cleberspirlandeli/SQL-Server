/*
Crie o banco de dados treino com as tabelas conforme diagrama.
*/

CREATE DATABASE TREINO
GO
USE TREINO
--CRIAR TABELAS
--CRIANDO TABELA CIDADE
	CREATE TABLE CIDADE
		(
		ID_CIDADE INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		NOME_CIDADE VARCHAR(60)  NOT NULL,
		UF VARCHAR(2) NOT NULL
		);
--CRIANDO TABELA CATEGORIA DE PRODUTOS
--DROP TABLE CATEGORIA
	CREATE TABLE CATEGORIA
	(
	ID_CATEGORIA INT IDENTITY(1,1)NOT NULL PRIMARY KEY,
	NOME_CATEGORIA VARCHAR(20) NOT NULL
	);
--CRIANDO A TABELA UNIDADE DE MEDIDAS
	CREATE TABLE UNIDADE
	(
	ID_UNIDADE VARCHAR(3) NOT NULL PRIMARY KEY,
	DESC_UNIDADE VARCHAR(25) NOT NULL
	);
--CRIANDO A TABELA CLIENTE
	CREATE TABLE CLIENTE
	 (ID_CLIENTE INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	  NOME_CLIENTE VARCHAR(60) NOT NULL,
	  ENDERECO VARCHAR(60) NOT NULL,
	  NUMERO VARCHAR(10) NOT NULL,
	  ID_CIDADE INT NOT NULL,
	  CEP VARCHAR(9) NOT NULL,
	  CONSTRAINT FK_CLI1 FOREIGN KEY (ID_CIDADE) REFERENCES CIDADE(ID_CIDADE)
	  )


--CRIANDO TABELA VENDEDORES
	CREATE TABLE VENDEDORES
	(
	ID_VENDEDOR INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_VENDEDOR VARCHAR(60) NOT NULL ,
	SALARIO DECIMAL(10,2) NOT NULL
	)


--CRIANDO A TABELA DE 	
    CREATE TABLE PRODUTOS (
        ID_PROD INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
        NOME_PRODUTO VARCHAR(50) NOT NULL,
        ID_CATEGORIA INT NOT NULL,
		ID_UNIDADE VARCHAR(3) NOT NULL,
        PRECO decimal(10, 2) NOT NULL,
		CONSTRAINT FK_MAT1 FOREIGN KEY (ID_CATEGORIA) REFERENCES CATEGORIA(ID_CATEGORIA),
		CONSTRAINT FK_MAT2 FOREIGN KEY (ID_UNIDADE) REFERENCES UNIDADE(ID_UNIDADE)
    );


    --CRIA��O DA TABELA VENDAS 
	--DROP TABLE VENDAS
    CREATE TABLE VENDAS (
        NUM_VENDA INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
        DATA_VENDA DATETIME NOT NULL,
        ID_CLIENTE INT NOT NULL,
		ID_VENDEDOR INT NOT NULL,
		STATUS CHAR(1) NOT NULL DEFAULT('N'), --N NORMAL C-- CANCELADA
		CONSTRAINT FK_VND1 FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
		CONSTRAINT FK_VND2 FOREIGN KEY (ID_VENDEDOR) REFERENCES VENDEDORES(ID_VENDEDOR)
    )

--CRIA��O DA TABELA DETALHE VENDA ITEM
	CREATE TABLE VENDA_ITENS
	(
	 NUM_VENDA INT NOT NULL,
	 NUM_SEQ INT NOT NULL,
	 ID_PROD INT NOT NULL,
	 QTDE DECIMAL(10,2) NOT NULL,
	 VAL_UNIT DECIMAL(10,2) NOT NULL,
	 VAL_TOTAL DECIMAL(10,2),
	 CONSTRAINT FK_VNDIT1 FOREIGN KEY (ID_PROD) REFERENCES PRODUTOS(ID_PROD),
	 CONSTRAINT FK_VNDIT2 FOREIGN KEY (NUM_VENDA) REFERENCES VENDAS(NUM_VENDA),
	 CONSTRAINT PK_VNDIT1 PRIMARY KEY (NUM_VENDA,NUM_SEQ)
	 );



/*
Restaurar o arquivo  treino.bak no banco de dados criado.
*/
USE MASTER
RESTORE DATABASE TREINO FROM DISK =N'C:\EAD\SQL EXERCICIOS\TREINO.BAK'
WITH REPLACE
USE TREINO
GO
/*
Liste todos os clientes com seus nomes e com suas respectivas cidade e estados

*/
SELECT  A.ID_CLIENTE,A.NOME_CLIENTE,B.NOME_CIDADE,B.UF
   FROM  CLIENTE A
   INNER JOIN CIDADE B
   ON A.ID_CIDADE=B.ID_CIDADE

/*
Liste o c�digo do produto, descri��o do produto e descri��o das categorias dos produtos que tenham o valor unit�rio na 
faixa de R$ 10,00 a R$ 1500
*/

SELECT A.ID_PROD,A.NOME_PRODUTO,B.NOME_CATEGORIA,A.PRECO  
  FROM   PRODUTOS A
  INNER JOIN CATEGORIA B
  ON A.ID_CATEGORIA=B.ID_CATEGORIA
  WHERE A.PRECO BETWEEN  10 AND 1500

--WHERE A.PRECO BETWEEN 10 AND 1500;
/*
Liste o c�digo do produto, descri��o do produto e descri��o da categoria dos produtos, e tamb�m apresente uma coluna condicional  
com o  nome de "faixa de pre�o" 
Com os seguintes crit�rios
�	pre�o< 500 : valor da coluna ser�  igual  "pre�o abaixo de 500"
�	pre�o  >= 500 e <=1000 valor da coluna ser� igual  "pre�o entre 500 e 1000"
�	pre�o  > 1000 : valor da coluna ser� igual  "pre�o acima de 1000".
*/

SELECT A.ID_PROD,A.NOME_PRODUTO,B.NOME_CATEGORIA,A.PRECO,
  CASE WHEN A.PRECO < 500 THEN 'PRECO ABAIXO DE 500'
	   WHEN A.PRECO >=500 AND A.PRECO <=1000 THEN 'PRECO ENTRE 500 E 1000'
	   WHEN A.PRECO >1000 THEN 'PRECO ACIMA DE MIL' END FAIXA_PRECO 
  FROM   PRODUTOS A
  INNER JOIN CATEGORIA B
  ON A.ID_CATEGORIA=B.ID_CATEGORIA

/*
Adicione a coluna faixa_salario na tabela vendedor tipo char(1)
*/

ALTER TABLE VENDEDORES ADD FAIXA_SALARIO CHAR(1)
/*
Atualize o valor do campo faixa_salario da tabela vendedor com um update condicional .
Com os seguintes crit�rios
�	salario <1000 ,atualizar faixa = c
�	salario >=1000  and <2000 , atualizar faixa = b
�	salario >=2000  , atualizar faixa = a

**VERIFIQUE SE OS VALORES FORAM ATUALIZADOS CORRETAMENTE
*/

UPDATE VENDEDORES SET FAIXA_SALARIO=CASE WHEN SALARIO<1000 THEN 'C'
										 WHEN SALARIO >=1000 AND SALARIO <2000 THEN 'B'
										 WHEN SALARIO >=2000 THEN 'A' END 

--SELECT * FROM VENDEDORES
/*
Listar em ordem alfab�tica os vendedores e seus respectivos sal�rios, mais uma coluna, simulando aumento de 12% em seus sal�rios.
*/

SELECT A.NOME_VENDEDOR,
	   A.SALARIO AS SALARIO_ATUAL,
	   A.SALARIO*1.12 AS SALARIO_SIMULA
FROM VENDEDORES A
ORDER BY A.NOME_VENDEDOR ASC

/*
Listar os nome dos vendedores, sal�rio atual , coluna calculada com salario novo + reajuste de 18% sobre o sal�rio atual, 
calcular  a coluna acr�scimo e calcula uma coluna salario novo+ acresc.
Crit�rios
Se o vendedor for  da faixa �C�, aplicar  R$ 120 de acr�scimo , outras faixas de salario acr�scimo igual a 0(Zero )
*/
--DECLARA VARIAVEL
DECLARE @ACRES DECIMAL(10,2)=120;
DECLARE @PCT_AUMENTO DECIMAL(10,2)=0.18;
--SELECT DE DADOS
SELECT  A.NOME_VENDEDOR,
        A.FAIXA_SALARIO,
		A.SALARIO AS SALARIO_ATUAL,
		A.SALARIO*(1+@PCT_AUMENTO) AS SALARIO_NOVO,
		CASE WHEN A.FAIXA_SALARIO ='C' THEN @ACRES ELSE 0 END ACRESC,
		CASE WHEN A.FAIXA_SALARIO ='C' THEN @ACRES+A.SALARIO*(1+@PCT_AUMENTO) 
		    ELSE A.SALARIO*(1+@PCT_AUMENTO) END SALARIO_NOVO_ACRES
 FROM VENDEDORES A
 ORDER BY 4 DESC

/*
Listar o nome e sal�rio do vendedor com menor salario.
*/
SELECT TOP 1 A.NOME_VENDEDOR,A.SALARIO
FROM VENDEDORES A
ORDER BY A.SALARIO ASC

/*
Quantos vendedores ganham acima de R$ 2.000,00 de sal�rio fixo?
*/

SELECT COUNT(*)QTD  FROM VENDEDORES
WHERE SALARIO>2000



/*
Adicione o campo valor_total tipo decimal(10,2) na tabela venda.
*/

ALTER TABLE VENDAS ADD VALOR_TOTAL DECIMAL(10,2)
/*
Atualize o campo valor_total da tabela venda, com a soma dos produtos das respectivas vendas.
*/
UPDATE VENDAS SET VALOR_TOTAL=(SELECT SUM(VAL_TOTAL) FROM VENDA_ITENS A
  WHERE VENDAS.NUM_VENDA=A.NUM_VENDA)


/*
produtos da venda, listar as vendas em que ocorrer diferen�a.
*/
SELECT A.NUM_VENDA,A.VALOR_TOTAL,SUM(B.VAL_TOTAL)TOTAL_ITENS
FROM VENDAS A
INNER JOIN VENDA_ITENS B
ON A.NUM_VENDA=B.NUM_VENDA
GROUP BY A.NUM_VENDA,A.VALOR_TOTAL HAVING A.VALOR_TOTAL<>SUM(B.VAL_TOTAL);


/*
Listar o n�mero de produtos existentes, valor total , m�dia do valor unit�rio referente ao m�s 07/2018 agrupado por venda.
*/

SELECT A.NUM_VENDA,
      COUNT(B.NUM_SEQ) QTD_SKU,
	  SUM(B.QTDE) QTDE,
	  AVG(B.VAL_UNIT) MEDIA_UNIT,
	   A.VALOR_TOTAL
  FROM VENDAS A
  INNER JOIN VENDA_ITENS B
  ON A.NUM_VENDA=B.NUM_VENDA
  WHERE MONTH(A.DATA_VENDA)=7
  AND YEAR(A.DATA_VENDA)=2018
  AND A.STATUS='N'
  GROUP BY A.NUM_VENDA,A.VALOR_TOTAL

/*
Listar o n�mero de vendas, Valor do ticket m�dio, menor ticket e maior ticket referente ao m�s 07/2017.
*/

SELECT COUNT(*) QTD_VENDAS,
       AVG(A.VALOR_TOTAL) MEDIA,
	   MIN(A.VALOR_TOTAL) MENOR_TKT,
	   MAX(A.VALOR_TOTAL) MAIOR_TKT,
	   SUM(A.VALOR_TOTAL) TOT_G
FROM VENDAS A
WHERE MONTH(A.DATA_VENDA)=7
AND YEAR(A.DATA_VENDA)=2017
AND A.STATUS='N'


/*
Atualize o status das notas abaixo de normal(N) para cancelada (C)
--15,34,80,104,130,159,180,240,350,420,422,450,480,510,530,560,600,640,670,714

*/
UPDATE VENDAS SET STATUS='C'
WHERE NUM_VENDA IN (15,34,80,104,130,159,180,240,350,420,422,450,480,510,530,560,600,640,670,714)

/*
Quais clientes realizaram mais de 70 compras?
*/
SELECT A.NOME_CLIENTE,COUNT(B.NUM_VENDA) QTD
 FROM CLIENTE A
 INNER JOIN VENDAS B
 ON  A.ID_CLIENTE=B.ID_CLIENTE
 WHERE B.STATUS='N'
 GROUP BY A.NOME_CLIENTE HAVING COUNT(B.NUM_VENDA)<=70
 ORDER BY 2 DESC


/*
Listar os produtos que est�o inclu�dos em vendas que a quantidade total de produtos seja superior a 100 unidades.
*/
WITH T1 AS
(SELECT A.NUM_VENDA,SUM(B.QTDE) AS QTD 
 FROM VENDAS A
 INNER JOIN VENDA_ITENS B
 ON A.NUM_VENDA=B.NUM_VENDA
 WHERE A.STATUS='N'
 GROUP BY A.NUM_VENDA HAVING SUM(B.QTDE)>100
 )

 SELECT A.NUM_VENDA,B.ID_PROD,C.NOME_PRODUTO,B.QTDE
 FROM T1 A 
 INNER JOIN VENDA_ITENS B
 ON A.NUM_VENDA=B.NUM_VENDA
 INNER JOIN PRODUTOS C
 ON B.ID_PROD=C.ID_PROD
/*
Trazer total de vendas do ano 2017 por categoria e apresentar total geral
*/
SELECT 
	ISNULL(D.NOME_CATEGORIA,'Total Geral') as CATEGORIA,
	SUM(A.VALOR_TOTAL) VAL_TOTAL 

FROM VENDAS A
 INNER JOIN VENDA_ITENS B
 ON A.NUM_VENDA=B.NUM_VENDA
 INNER JOIN  PRODUTOS C
 ON B.ID_PROD=C.ID_PROD
 INNER JOIN CATEGORIA D
 ON C.ID_CATEGORIA=D.ID_CATEGORIA
 WHERE YEAR(A.DATA_VENDA)=2017
 GROUP BY ROLLUP (D.NOME_CATEGORIA)



/*
Listar total de vendas do ano 2017 por categoria e m�s a m�s apresentar subtotal dos meses e total geral ano.
*/

--SELECT SUBSTRING(CONVERT(VARCHAR(10),GETDATE(),103),4,10)
SELECT 
    ISNULL(SUBSTRING(CONVERT(VARCHAR(10),A.DATA_VENDA,103),4,10),'TOTAL GERAL') MES,
	ISNULL(D.NOME_CATEGORIA,'Total Mes') as CATEGORIA,
	SUM(A.VALOR_TOTAL) VAL_TOTAL 
FROM VENDAS A
 INNER JOIN VENDA_ITENS B
 ON A.NUM_VENDA=B.NUM_VENDA
 INNER JOIN  PRODUTOS C
 ON B.ID_PROD=C.ID_PROD
 INNER JOIN CATEGORIA D
 ON C.ID_CATEGORIA=D.ID_CATEGORIA
 WHERE YEAR(A.DATA_VENDA)=2017
 AND A.STATUS='N'
 GROUP BY ROLLUP (SUBSTRING(CONVERT(VARCHAR(10),A.DATA_VENDA,103),4,10),D.NOME_CATEGORIA)

/*
Listar total de vendas por vendedores referente ao ano 2017, m�s a m�s apresentar subtotal do m�s e total geral.
*/
SELECT 
    ISNULL(SUBSTRING(CONVERT(VARCHAR(10),A.DATA_VENDA,103),4,10),'TOTAL GERAL') MES,
	ISNULL(B.NOME_VENDEDOR,'Total Mes') as VENDEDOR,
	SUM(A.VALOR_TOTAL) VAL_TOTAL 
FROM VENDAS A
 INNER JOIN VENDEDORES B
 ON A.ID_VENDEDOR=B.ID_VENDEDOR
 WHERE YEAR(A.DATA_VENDA)=2017
 AND A.STATUS='N'
 GROUP BY ROLLUP (SUBSTRING(CONVERT(VARCHAR(10),A.DATA_VENDA,103),4,10),B.NOME_VENDEDOR)


/*
Listar os top 10 produtos mais vendidos por valor total de venda com suas respectivas categorias
*/

SELECT TOP 10 ROW_NUMBER() OVER (ORDER BY SUM(B.VAL_TOTAL) DESC) POSICAO,
        C.NOME_PRODUTO,
		D.NOME_CATEGORIA,
		SUM(B.VAL_TOTAL) AS TOTAL
FROM VENDAS A
  INNER JOIN VENDA_ITENS B
  ON A.NUM_VENDA=B.NUM_VENDA
  INNER JOIN PRODUTOS C
  ON B.ID_PROD=C.ID_PROD
  INNER JOIN CATEGORIA D
  ON C.ID_CATEGORIA=D.ID_CATEGORIA
  GROUP BY C.NOME_PRODUTO,D.NOME_CATEGORIA


/*
Listar os top 10 produtos mais vendidos por valor total de venda com suas respectivas categorias, calcular seu percentual de 
participa��o com rela��o ao total geral, referente ao ano de 2017
*/
DECLARE @ANO VARCHAR(4)='2017';
DECLARE @TOT_G DECIMAL(10,2);
--ATRIBUIR VALOR TOT_G
SELECT @TOT_G=SUM(X.VALOR_TOTAL) FROM VENDAS X WHERE YEAR(X.DATA_VENDA)=@ANO

SELECT TOP 10 ROW_NUMBER() OVER (ORDER BY SUM(B.VAL_TOTAL) DESC) POSICAO,
        C.NOME_PRODUTO,
		D.NOME_CATEGORIA,
		SUM(B.VAL_TOTAL) AS TOTAL,
		100/@TOT_G*SUM(B.VAL_TOTAL)  AS PCT_PARTICIP
FROM VENDAS A
  INNER JOIN VENDA_ITENS B
  ON A.NUM_VENDA=B.NUM_VENDA
  INNER JOIN PRODUTOS C
  ON B.ID_PROD=C.ID_PROD
  INNER JOIN CATEGORIA D
  ON C.ID_CATEGORIA=D.ID_CATEGORIA
  WHERE YEAR(A.DATA_VENDA)=@ANO
  AND A.STATUS='N'
  GROUP BY C.NOME_PRODUTO,D.NOME_CATEGORIA


/*
Listar apenas o produto mais vendido de cada M�s com seu  valor total referente ao ano de 2017.
*/
--ETAPA 1
SELECT MONTH(A.DATA_VENDA) AS MES,
       B.ID_PROD,
	   SUM(B.VAL_TOTAL) AS VALOR
	  INTO #ETAPA1
 FROM VENDAS A
 INNER JOIN VENDA_ITENS B
 ON A.NUM_VENDA=B.NUM_VENDA
 WHERE YEAR(A.DATA_VENDA)=2017
 GROUP BY  MONTH(A.DATA_VENDA),B.ID_PROD
 ORDER BY MONTH(A.DATA_VENDA) ASC,3 DESC
--ETAPA 2
--SELECT COM A #ETAPA1 PARA ALIMENTAR ETAPA 2
SELECT ROW_NUMBER() OVER (PARTITION BY MES ORDER BY MES ASC,VALOR DESC) POSICAO,
       MES,
	   ID_PROD,
	   VALOR
  INTO #ETAPA2
FROM #ETAPA1

--RESULTADO

SELECT A.POSICAO,A.MES,B.NOME_PRODUTO,A.VALOR
FROM #ETAPA2 A
INNER JOIN PRODUTOS  B
ON A.ID_PROD=B.ID_PROD
WHERE A.POSICAO=1
ORDER BY A.MES

--DROP TEMOP

DROP TABLE #ETAPA1;
DROP TABLE #ETAPA2;
/*
Listar os cliente e a data da �ltima compra de cada cliente.
*/
SELECT A.ID_CLIENTE,A.NOME_CLIENTE,CAST(B.DATA_VENDA AS DATE) AS DT_ULT_COMPRA ,B.NUM_VENDA
FROM  (SELECT ID_CLIENTE,MAX(DATA_VENDA) AS DATA_VENDA FROM VENDAS WHERE STATUS='N' GROUP BY ID_CLIENTE) AS X
INNER JOIN CLIENTE A
ON A.ID_CLIENTE=X.ID_CLIENTE
INNER JOIN VENDAS B
ON A.ID_CLIENTE=B.ID_CLIENTE
AND A.ID_CLIENTE=X.ID_CLIENTE
AND B.DATA_VENDA=X.DATA_VENDA

/*
Listar o a data da �ltima venda de cada produto.

*/

SELECT A.ID_PROD,A.NOME_PRODUTO,CAST(T1.DATA_VENDA AS DATE) AS DATA_VENDA
FROM PRODUTOS A
INNER JOIN (SELECT C.ID_PROD,MAX(B.DATA_VENDA) AS DATA_VENDA
FROM VENDAS B
INNER JOIN VENDA_ITENS C
ON B.NUM_VENDA=C.NUM_VENDA
GROUP BY C.ID_PROD) T1
ON A.ID_PROD=T1.ID_PROD
