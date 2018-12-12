
--PROC_GERA_NF
--TABELAS ORIGEM PED_VENDAS, PED_VENDAS_ITENS, PED_COMPRAS, PED_COMPRAS_ITENS
--TABELAS DESTINO NOTA_FISCAL, NOTA_FISCAL_ITENS
--ATUALIZA STATUS PEDIDOS COMO SITUACAO =F FINALIZADO
--DROP  PROCEDURE PROC_GERA_NF 
--FASE 1 PEDIDO DE VENDA
--FASE 2 ORDEM DE PRODUCAO
--FASE 3 PEDIDO DE COMPRAS
--FASE 4 GERA ESTOQUE
--FASE 5 GERA NOTAS FISCAIS E/S 
--PARAMETROS @COD_EMPRESA,@TIP_MOV,@DOCTO,@CFOP,@DATA_EMIS,@DATA_ENTREGA
--EXEC PROC_GERA_NF 'S',4,'5.101','2017-01-30','2017-01-30'

--OBS AJUSTE O CAMPO QTD TABELA NF_FISCAL_ITENS PARA DECIMAL(10,2)
ALTER TABLE NOTA_FISCAL_ITENS ALTER COLUMN QTD DECIMAL(10,2)

CREATE  PROCEDURE PROC_GERA_NF (@COD_EMPRESA INT,
                               @TIP_MOV AS CHAR(1),--E = ENTRADA S= SAIDA
                               @DOCTO INT, --PEDIDO DE VENDA SAIDA- PEDIDO COMPPRAS -ENTRADA
							   @CFOP VARCHAR(5),
							   @DATA_EMIS DATE,
							   @DATA_ENTREGA DATE)
AS 
 BEGIN 
 --ATRIBUIR VALOR DO OUTPUT
DECLARE @NOTA_TB TABLE
(
    NF  INT
)
--DECLARA VARIAVEIS
DECLARE @DOCT INT,
        @NUM_NF INT,
		@ID INT,
		@COD_PAGTO INT,
		@NUM_PEDIDO INT,
		@SEQ_MAT INT,
		@COD_MAT INT,
		@QTD DECIMAL(10,2),
		@VAL_UNIT DECIMAL (10,2),
		@SUB_TOT_NFE DECIMAL(10,2),
		@TOTAL_NFE DECIMAL(10,2),
		@ERRO_INTERNO INT

		SET @SUB_TOT_NFE=0
		SET @TOTAL_NFE=0 
--INICIA TRANSA��O
BEGIN TRANSACTION
--INICIA BEGIN TRY
BEGIN TRY

		IF (@DATA_EMIS>GETDATE() OR @DATA_ENTREGA>GETDATE())
		BEGIN
			PRINT 'NAO PERMITIDO LANCAMENTOS FUTUROS!' 
			SET @ERRO_INTERNO=1
		END
		ELSE IF @TIP_MOV<>'S' AND  @TIP_MOV<>'E'
		BEGIN 
			PRINT 'OPERACAO NAO PERMITIDA E CANCELADA!'
			SET @ERRO_INTERNO=1
		END
		ELSE IF @TIP_MOV='S' AND (SELECT COUNT(*) FROM PED_VENDAS A
		   WHERE COD_EMPRESA=@COD_EMPRESA AND A.NUM_PEDIDO=@DOCTO
		         AND A.SITUACAO<>'F')=0
		BEGIN 
		   PRINT 'NAO A PEDIDO DE VENDAS DISPONIVEL PARA SAIDA'
		   SET @ERRO_INTERNO=1
		END 
		ELSE IF @TIP_MOV='E' AND (SELECT COUNT(*) FROM PED_COMPRAS A
		   WHERE COD_EMPRESA=@COD_EMPRESA AND A.NUM_PEDIDO=@DOCTO
		         AND A.SITUACAO<>'F')=0
		BEGIN 
		   PRINT 'NAO A PEDIDO DE COMPRAS DISPONIVEL PARA ENTRADA'
		   SET @ERRO_INTERNO=1
		END 
--INICIO NOTA FISCAL DE SAIDA
		ELSE IF @TIP_MOV='S' 
		BEGIN 
		--ABRINDO CURSOR SAIDA
		DECLARE NOTA_FISCAL CURSOR FOR 

		SELECT A.COD_EMPRESA,A.NUM_PEDIDO,A.ID_CLIENTE,A.COD_PAGTO
		FROM  PED_VENDAS A
		WHERE A.COD_EMPRESA=@COD_EMPRESA
		AND A.NUM_PEDIDO=@DOCTO
		AND A.SITUACAO<>'F' --FINALIZADO

		OPEN NOTA_FISCAL
		FETCH NEXT FROM NOTA_FISCAL
		INTO @COD_EMPRESA,@NUM_PEDIDO,@ID,@COD_PAGTO
		WHILE @@FETCH_STATUS = 0
		BEGIN

		--PEGANDO NUMERO DO PEDIDO
		PRINT 'UPDATE DE PARAMETROS'
		UPDATE PARAMETROS SET VALOR=VALOR+1
		OUTPUT INSERTED.VALOR INTO @NOTA_TB
		WHERE COD_EMPRESA=@COD_EMPRESA
		AND PARAM='NOTA_FISCAL';
		
		--ATRIBUI NUMERO NF A VARIALVEL
		SELECT @NUM_NF=NF FROM @NOTA_TB

		--SELECT * FROM PARAMETROS
			INSERT INTO NOTA_FISCAL 
			OUTPUT INSERTED.NUM_NF --VISUALIZA NF
			VALUES
			(@COD_EMPRESA,@NUM_NF,@TIP_MOV,@CFOP,@ID,@COD_PAGTO,@DATA_EMIS,@DATA_ENTREGA,0,'N','N')
			PRINT @@ERROR

			--IMPRIMININDO CABECALHO
			SELECT @COD_EMPRESA COD_EMPRESA,@NUM_NF NUM_NF,@TIP_MOV TIP_MOV,@CFOP CFOP,@ID ID,@COD_PAGTO COD_PAGTO,
			@DATA_EMIS DAT_EMIS,@DATA_ENTREGA DATA_ENTREG

	--INICIO CURSOR DETALHES NFE
	--CURSOR DETALHE PED INICIO
	DECLARE NF_ITENS CURSOR FOR 
	SELECT A.COD_EMPRESA,A.SEQ_MAT,A.COD_MAT,A.QTD,A.VAL_UNIT 
		FROM PED_VENDAS_ITENS A
		WHERE COD_EMPRESA=@COD_EMPRESA
		AND A.NUM_PEDIDO=@DOCTO
		ORDER BY A.SEQ_MAT

	OPEN NF_ITENS
		FETCH NEXT FROM NF_ITENS
		INTO @COD_EMPRESA,@SEQ_MAT,@COD_MAT,@QTD,@VAL_UNIT
		WHILE @@FETCH_STATUS = 0
			BEGIN
			INSERT INTO NOTA_FISCAL_ITENS VALUES
			(@COD_EMPRESA,@NUM_NF,@SEQ_MAT,@COD_MAT,@QTD,@VAL_UNIT,@DOCTO);
			PRINT @@ERROR
			--APRESENTANDO VALORES
			SELECT @COD_EMPRESA COD_EMPRESA,@NUM_NF NUM_NF,@SEQ_MAT SEQ ,@COD_MAT COD_MAT,@QTD QTD ,
			@VAL_UNIT VAL_UNIT,@DOCTO PED_ORIG
			--ATRIBUINDO VALORES
			SET @SUB_TOT_NFE=@QTD*@VAL_UNIT;
			SET @TOTAL_NFE=@TOTAL_NFE+@SUB_TOT_NFE;
			--SELECT @TOTAL_NFE
		FETCH NEXT FROM NF_ITENS
		INTO @COD_EMPRESA,@SEQ_MAT,@COD_MAT,@QTD,@VAL_UNIT
		END
	  
		CLOSE NF_ITENS;
        DEALLOCATE NF_ITENS;
	--FINAL CURSOR DETALHES
	  
	   --ATUALIZANDO TOTAL NFE
		UPDATE NOTA_FISCAL SET TOTAL_NF=@TOTAL_NFE WHERE COD_EMPRESA=@COD_EMPRESA AND NUM_NF=@NUM_NF;
		--ATUALIZADO STATUS PARA FECHADO NFE
		UPDATE PED_VENDAS  SET SITUACAO='F' WHERE COD_EMPRESA=@COD_EMPRESA AND NUM_PEDIDO=@DOCTO;

		FETCH NEXT FROM NOTA_FISCAL
		INTO @COD_EMPRESA,@NUM_PEDIDO,@ID,@COD_PAGTO
	END
	--FINAL CURSOR NFE
	CLOSE NOTA_FISCAL;
    DEALLOCATE NOTA_FISCAL;
  END --END IF SAIDA
  --FIM NOTA FISCAL DE SAIDA
  --INICIO NOTA FISCAL ENTRADA
  ELSE IF @TIP_MOV='E' 
		BEGIN 
		
		DECLARE NOTA_FISCAL CURSOR FOR 

		SELECT @COD_EMPRESA,A.NUM_PEDIDO,A.ID_FOR,A.COD_PAGTO
		FROM  PED_COMPRAS A
		WHERE COD_EMPRESA=@COD_EMPRESA
		AND A.NUM_PEDIDO=@DOCTO
		AND A.SITUACAO<>'F' --FINALIZADO

		OPEN NOTA_FISCAL
		FETCH NEXT FROM NOTA_FISCAL
		INTO @COD_EMPRESA,@NUM_PEDIDO,@ID,@COD_PAGTO
		WHILE @@FETCH_STATUS = 0
			BEGIN
		
		--PEGANDO NUMERO DO PEDIDO
		PRINT 'UPDATE DE PARAMETROS'
		UPDATE PARAMETROS SET VALOR=VALOR+1
		OUTPUT INSERTED.VALOR INTO @NOTA_TB
		WHERE COD_EMPRESA=@COD_EMPRESA
		AND PARAM='NOTA_FISCAL';
		
		--ATRIBUI NUMERO NF A VARIALVEL
		SELECT @NUM_NF=NF FROM @NOTA_TB
    --INSERINDO REGISTO
			INSERT INTO NOTA_FISCAL 
			VALUES
			(@COD_EMPRESA,@NUM_NF,@TIP_MOV,@CFOP,@ID,@COD_PAGTO,@DATA_EMIS,@DATA_ENTREGA,0,'N','N')
			PRINT @@ERROR
			
			--APRESENTANDO VALORES CABECALHO
			SELECT @COD_EMPRESA COD_EMPRESA,@NUM_NF NUM_NF,@TIP_MOV TIP_MOV,@CFOP CFOP,@ID ID,@COD_PAGTO COD_PAGTO,
			@DATA_EMIS DAT_EMIS,@DATA_ENTREGA DATA_ENTREG

	--INICIO CURSRO DETALHES NFE
	--CURSOR DETALHE PED INICIO
	DECLARE NF_ITENS CURSOR FOR 

	SELECT @COD_EMPRESA COD_EMPRESA,A.SEQ_MAT,A.COD_MAT,A.QTD,A.VAL_UNIT 
		FROM PED_COMPRAS_ITENS A
		WHERE COD_EMPRESA=@COD_EMPRESA
		AND A.NUM_PEDIDO=@DOCTO
		ORDER BY A.SEQ_MAT

	OPEN NF_ITENS
		FETCH NEXT FROM NF_ITENS
		INTO @COD_EMPRESA,@SEQ_MAT,@COD_MAT,@QTD,@VAL_UNIT
		WHILE @@FETCH_STATUS = 0
			BEGIN
			INSERT INTO NOTA_FISCAL_ITENS VALUES
			(@COD_EMPRESA,@NUM_NF,@SEQ_MAT,@COD_MAT,@QTD,@VAL_UNIT,@DOCTO);
			PRINT @@ERROR
			--APRESENTANDO VALORES DO ITENS INSERIDOS
			SELECT @COD_EMPRESA COD_EMPRESA ,@NUM_NF NUM_NF,@SEQ_MAT SEQ ,@COD_MAT COD_MAT,@QTD QTD ,@VAL_UNIT VAL_UNIT,@DOCTO PED_ORIG
			SET @SUB_TOT_NFE=@QTD*@VAL_UNIT;
			SET @TOTAL_NFE=@TOTAL_NFE+@SUB_TOT_NFE;
			--SELECT @TOTAL_NFE
		FETCH NEXT FROM NF_ITENS
		INTO @COD_EMPRESA,@SEQ_MAT,@COD_MAT,@QTD,@VAL_UNIT
		
		END
	   
		CLOSE NF_ITENS;
        DEALLOCATE NF_ITENS;
	--FINAL CURSOR DETALHES

	 --ATUALIZANDO TOTAL NFE
		UPDATE NOTA_FISCAL SET TOTAL_NF=@TOTAL_NFE WHERE COD_EMPRESA=@COD_EMPRESA  AND NUM_NF=@NUM_NF;
		--ATUALIZADO STATUS PARA FECHADO NFE
		UPDATE PED_COMPRAS  SET SITUACAO='F' WHERE COD_EMPRESA=@COD_EMPRESA AND NUM_PEDIDO=@DOCTO;

		FETCH NEXT FROM NOTA_FISCAL
		INTO @COD_EMPRESA,@NUM_PEDIDO,@ID,@COD_PAGTO
	END
	--FINAL CURSOR NFE
	CLOSE NOTA_FISCAL;
    DEALLOCATE NOTA_FISCAL;
  END
  --FIM NOTA FISCAL ENTRADA
 --VALIDACOES FINAIS
	IF @@ERROR <>0
	 BEGIN 
		ROLLBACK TRANSACTION
		PRINT 'OPERACAO CANCELADA'
	 END
	ELSE IF @ERRO_INTERNO=1
		BEGIN
		ROLLBACK TRANSACTION
		PRINT 'OPERACAO CANCELADA COM SUCESSO' 
		END
	ELSE
		BEGIN
		    PRINT 'OPERACAO FINALIZADA COM SUCESSO'
			COMMIT TRANSACTION
		END
END TRY
BEGIN CATCH
SELECT  
        ERROR_NUMBER() AS ErrorNumber,  
        ERROR_SEVERITY() AS ErrorSeverity , 
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure , 
        ERROR_LINE() AS ErrorLine,  
        ERROR_MESSAGE() AS ErrorMessage;  

		IF (SELECT CURSOR_STATUS('global', 'NOTA_FISCAL')) = 1 
		BEGIN
			CLOSE NOTA_FISCAL	
			DEALLOCATE NOTA_FISCAL	
		END
		IF (SELECT CURSOR_STATUS('global', 'NF_ITENS')) = 1 
		BEGIN
			CLOSE NF_ITENS	
			DEALLOCATE NF_ITENS	
		END	
		
		SET XACT_ABORT ON;
		IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION;  
	 
	END CATCH

END --END PROCEDURE


--TESTANDO
--PARAMETROS @COD_EMPRESA,@TIP_MOV,@DOCTO,@CFOP,@DATA_EMIS,@DATA_ENTREGA
EXEC PROC_GERA_NF 1,'X',1,'1.101','2018-01-30','2018-01-30'  

SELECT * FROM PED_COMPRAS

EXEC PROC_GERA_NF 1,'E',1,'1.101','2018-01-30','2018-01-30'  
EXEC PROC_GERA_NF 1,'E',2,'1.101','2018-01-30','2018-01-30'  
EXEC PROC_GERA_NF 1,'E',3,'1.101','2018-01-30','2018-01-30'  
EXEC PROC_GERA_NF 1,'E',4,'1.101','2018-01-30','2018-01-30' 

EXEC PROC_GERA_NF 1,'S',1,'5.101','2018-01-30','2018-01-30'  
EXEC PROC_GERA_NF 1,'S',2,'5.101','2018-02-28','2018-02-28'  
EXEC PROC_GERA_NF 1,'S',3,'5.101','2018-03-30','2018-03-30'  
EXEC PROC_GERA_NF 1,'S',4,'5.101','2018-04-30','2018-04-30' 
 
/*
SELECT * FROM NOTA_FISCAL_ITENS
SELECT * FROM NOTA_FISCAL
DELETE FROM NOTA_FISCAL_ITENS
DELETE FROM NOTA_FISCAL

SELECT  * FROM PED_VENDAS
SELECT  * FROM PED_COMPRAS
SELECT TOP 1 * FROM NOTA_FISCAL
SELECT TOP 1 * FROM NOTA_FISCAL_ITENS
SELECT TOP 1 * FROM PED_VENDAS_ITENS
SELECT TOP 1 * FROM PED_COMPRAS_ITENS
SELECT * FROM PARAMETROS
UPDATE PARAMETROS SET VALOR=0 WHERE COD_EMPRESA=1 AND PARAM='NOTA_FISCAL'
SELECT * FROM PED_VENDAS
UPDATE PED_VENDAS SET SITUACAO='P' WHERE COD_EMPRESA=1 AND SITUACAO='F'
UPDATE PED_COMPRAS SET SITUACAO='P' WHERE COD_EMPRESA=1 AND SITUACAO='F'
*/
--CONFERINDO QTD NF ITENS X TOTAL NFE
--APENAS LISTANDO DIFEREN�AS SE OCORREREM
SELECT A.COD_EMPRESA, A.NUM_NF,A.TOTAL_NF, SUM(B.QTD*B.VAL_UNIT) TOT_ITENS
FROM NOTA_FISCAL A
INNER JOIN NOTA_FISCAL_ITENS B
ON A.COD_EMPRESA=B.COD_EMPRESA
AND A.NUM_NF=B.NUM_NF
GROUP BY A.COD_EMPRESA, A.NUM_NF,A.TOTAL_NF
HAVING A.TOTAL_NF<>SUM(B.QTD*B.VAL_UNIT)

