

if exists (select * from sysobjects where id = object_id('dbo.ABC12300'))	drop PROCEDURE dbo.ABC12300
GO 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
CREATE PROCEDURE dbo.ABC12300 (@idparcalc   INT, 
                               @idcontrato  INT, 
                               @operacao    INT) AS
------------------------------------------------------------------------------------------------------
-- <Padrao> 
-- @operacao = 0 Iniciar  alteração na tabela RFT01700
-- @operacao = 1 Cancelar alteração na tabela RFT01700
-- @operacao = 2 Concluir alteração na tabela RFT01700
------------------------------------------------------------------------------------------------------
BEGIN
SET NOCOUNT ON
   
   DECLARE @informada         BIT,
           @mensagemError     VARCHAR(3000),
           @cnpj              VARCHAR(18),
           @mensagemErrorTran VARCHAR(3000),
           @totalVencimento   DECIMAL(15,2),
           @totalDesconto     DECIMAL(15,2),
           @totalLiquido      DECIMAL(15,2);
           
   SET @informada = 0           
   
   -- ================================================================================================
   -- Verificar se o campo INFORMADA é igual a 1       
   SET @informada =  (SELECT TOP 1
                             F017.informada
                        FROM RFT01700 F017
                       INNER JOIN RFT01600 F016 ON F016.idfunselec = F017.idfunselec
                       INNER JOIN RFT00900 F009 ON F009.idparcalc  = F016.idparcalc
                       WHERE F009.idparcalc  = @idparcalc
                         AND F017.idcontrato = @idcontrato)
                         
   IF @informada = 0
   BEGIN
      SET @mensagemError = 'Verba não informada, proibido alterar sem informar!'
      EXEC RXD09300 @mensagemError, '#EMPRESA#', 1
   END                         
   -- ================================================================================================
   
   BEGIN TRY
       BEGIN TRAN
         
         -- @operacao 0 - Início da alteração, clonar a tabela RFT01700
         IF @operacao = 0
         BEGIN        
            DELETE dbo.RFT01701         
            
            INSERT INTO dbo.RFT01701
            SELECT F017.*
              FROM RFT01700 F017
             INNER JOIN RFT01600 F016 ON F016.idfunselec = F017.idfunselec
             WHERE F016.idparcalc  = @idparcalc  
               AND F017.idcontrato = @idcontrato  
              
            
         END -- @operacao 0
         
         -- @operacao 1 - Cancelar alteração na tabela RFT01700
         ELSE IF @operacao = 1
         BEGIN
            DELETE dbo.RFT01701
         END -- @operacao 1
         
         -- @operacao 2 - Concluir alteração na tabela RFT01700
         ELSE IF @operacao = 2
         BEGIN
            IF EXISTS (SELECT 'TRUE' FROM dbo.RFT01701)
            BEGIN
            
               -- PROCURAR POR VERBAS DELETADAS 
               EXEC RXD03000 '#DEL_BKP'
               SELECT F017.*
                 INTO #DEL_BKP
                 FROM RFT01700 F017
                INNER JOIN RFT01600 F016 ON F016.idfunselec = F017.idfunselec
                INNER JOIN RFT00900 F009 ON F009.idparcalc  = F016.idparcalc
                INNER JOIN RFT00300 F003 ON F003.idverba    = F017.idverba
                WHERE F009.idparcalc  = @idparcalc
                  AND F017.idcontrato = @idcontrato
                  AND F017.informada   = 1 
                  AND F017.idverba NOT IN (SELECT BKP.idverba FROM dbo.RFT01701 BKP)
                  
                  
               -- PROCURAR POR NOVAS VERBAS - INSERIDAS/INCLUÍDAS
               EXEC RXD03000 '#INS_BKP'
               SELECT BKP.*
                 INTO #INS_BKP
                 FROM dbo.RFT01701 BKP
                WHERE BKP.idverba NOT IN  (SELECT F017.idverba 
                                             FROM RFT01700 F017 
                                            INNER JOIN RFT01701 BKP01 ON F017.idfunselec = BKP01.idfunselec
                                            WHERE F017.idverba = BKP01.idverba)
                                             
                                             
               -- PROCURAR POR VERBAS EDITADAS/ALTERADAS
               EXEC RXD03000 '#UPD_BKP'
               SELECT BKP.*
                 INTO #UPD_BKP
                 FROM dbo.RFT01701 BKP
                INNER JOIN RFT01700 F017 ON F017.idfunselec  = BKP.idfunselec
                                        AND F017.idverba     = BKP.idverba  
                WHERE F017.informada  = 1
                  AND (BKP.qtdeverba <> F017.qtdeverba 
                       OR BKP.valorverba <> F017.valorverba)
           
            END
            
            IF EXISTS (SELECT 'TRUE' FROM #DEL_BKP)
            BEGIN
               PRINT 'DEL'
               DELETE RFT01700
                WHERE idcalculo IN (SELECT BKP.idcalculo FROM #DEL_BKP BKP)
            END
                    
            IF EXISTS (SELECT 'TRUE' FROM #INS_BKP)
            BEGIN
               PRINT 'INS'
               INSERT RFT01700 (idcontrato, anoreferenc, mesreferenc, tipodefolha, tipoverba, idverba, numprocalc, qtdeverba, valorverba, idfunselec, informada)
               SELECT idcontrato, anoreferenc, mesreferenc, tipodefolha, tipoverba, idverba, numprocalc, qtdeverba, valorverba, idfunselec, informada 
                 FROM #INS_BKP
            END
            
            IF EXISTS (SELECT 'TRUE' FROM #UPD_BKP)
            BEGIN
               PRINT 'UPD'
               UPDATE RFT01700
                  SET RFT01700.qtdeverba  = BKP.qtdeverba,
                      RFT01700.valorverba = BKP.valorverba 
                 FROM RFT01700 AS F017
                INNER JOIN #UPD_BKP AS BKP ON BKP.idcalculo = F017.idcalculo
                WHERE BKP.idverba    = F017.idverba
                  AND BKP.idfunselec = F017.idfunselec 
            
            END
            
            -- ATUALIZAR TOTAIS 
            SET @totalVencimento = (SELECT ISNULL(SUM(BKP.valorverba), 0.00)
                                      FROM RFT01701 BKP 
                                     WHERE BKP.tipoverba = 0)
            
            SET @totalDesconto = (SELECT ISNULL(SUM(BKP.valorverba), 0.00)
                                    FROM RFT01701 BKP
                                   WHERE BKP.tipoverba = 1)
                                     
            SET @totalLiquido = @totalVencimento - @totalDesconto;
            
            UPDATE RFT01700
               SET valorverba = CASE                       
                                    WHEN F003.codverba = 2001 THEN 
                                       @totalVencimento
                                    WHEN F003.codverba = 2002 THEN
                                       @totalDesconto
                                    WHEN F003.codverba = 2003 THEN 
                                       @totalLiquido
                                 END
              FROM RFT01700 AS F017
             INNER JOIN RFT01600 F016 ON F016.idfunselec = F017.idfunselec
             INNER JOIN RFT00300 F003 ON F003.idverba    = F017.idverba
             INNER JOIN RFT01701 BKP  ON BKP.idfunselec  = F017.idfunselec
                                     AND BKP.idverba     = F017.idverba
             WHERE F016.idparcalc  = @idparcalc
               AND F017.idcontrato = @idcontrato
               AND F003.codverba IN(2001, 2002, 2003)       
               
               
            EXEC RXD03000 '#DEL_BKP'
            EXEC RXD03000 '#INS_BKP'
            EXEC RXD03000 '#UPD_BKP'
            DELETE dbo.RFT01701 
                                                 
         END -- @operacao 2
         
         IF @@TRANCOUNT > 0         
            COMMIT
   END TRY
   
   BEGIN CATCH
      IF @@TRANCOUNT > 0
         ROLLBACK
           
      SET @cnpj = (SELECT Cgc FROM XXT01000)
      SET @mensagemErrorTran = ERROR_MESSAGE()
      --PRINT @mensagemErrorTran
      SET @mensagemError = ' Houve um problema não esperado, entre em contato com o suporte TI. ABC12300 - CNPJ:' + @cnpj + ' - Error: ' + @mensagemErrorTran
      EXEC RXD09300 @mensagemError, '#SMARAPD#', 0
   END CATCH

END
-------------------------------------------------------------------------------
--CRSPIRLANDELI  03/01/2019
GO