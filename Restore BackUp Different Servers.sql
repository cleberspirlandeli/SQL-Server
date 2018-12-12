/*
Restoring Database Backup. In this problem it was not possible to perform a TRUNCATE and insert the data again because the system continued entering data. You would have to parse the data that you deleted and re-insert only the deleted data.
"Change the wheel of the car with the car moving." LOL

pt-br
Restaurando backup de banco de dados. Nesse problema não era possivel realizar um TRUNCATE e inserir os dados novamente pois o sistema continuou inserindo dados. Teria que ser analisado os dados que foi excluido e inserir novamente somente os dados excluidos.
"Trocar a roda do carro com o carro andando". rs
*/



/* 

ROLLBACK

*/

BEGIN TRAN
   
   EXEC dbo.RXD03000 '#Parametrizacao'  
   CREATE TABLE #Parametrizacao (  
      idtitulo     INT,  
      idfolsintcol INT,  
      nrocoluna    INT,  
      idtabdiv     INT,  
      itemtabdiv   INT,  
      idverba      INT,  
      codverba     INT  
   )  

   -- Parametriza��o de Relat�rio NBCASP  
   INSERT INTO #Parametrizacao (idtitulo, idfolsintcol, nrocoluna, idtabdiv, itemtabdiv, idverba, codverba)  
   SELECT F040.idtitulo, F037.idfolsintcol, F037.nrocoluna, F038.idtabdiv, X001.itemtabdiv, X012.idverba, F003.codverba  
     FROM      [000.000.0.000\SQL_ALPHA].[NAME_DATABASE_20181122].[dbo].[RFT04000] F040  
    INNER JOIN [000.000.0.000\SQL_ALPHA].[NAME_DATABASE_20181122].[dbo].[RFT03700] F037 ON F037.idtitulo     = F040.idtitulo     
    INNER JOIN [000.000.0.000\SQL_ALPHA].[NAME_DATABASE_20181122].[dbo].[RFT03801] F038 ON F038.idfolsintcol = F037.idfolsintcol  
    INNER JOIN [000.000.0.000\SQL_ALPHA].[NAME_DATABASE_20181122].[dbo].[RXT00100] X001 ON X001.idtabdiv     = F038.idtabdiv  
                                                                                 AND X001.codtabdiv    = 75  
    INNER JOIN [000.000.0.000\SQL_ALPHA].[NAME_DATABASE_20181122].[dbo].[RXT01200] X012 ON X012.idtabdiv     = X001.idtabdiv  
    INNER JOIN [000.000.0.000\SQL_ALPHA].[NAME_DATABASE_20181122].[dbo].[RFT00300] F003 ON F003.idverba      = X012.idverba  
    WHERE F040.nomerelatorio = 'NBCASP'  
   
   
   EXEC dbo.RXD03000 '#RFT09401'  
   SELECT F094.idfunselec,  
          F094.idparcalc,  
          F094.idcontrato,  
          p.idverba,  
          valorverba = ABS(SUM(CASE F094.adicional WHEN 1 THEN F094.valor ELSE -F094.valor END))  
   INTO #RFT09401  
   FROM [000.000.0.000\SQL_ALPHA].[NAME_DATABASE_20181122].[dbo].[RFT09400] F094  
   INNER JOIN #Parametrizacao p ON p.nrocoluna = F094.nrocoluna  
   WHERE EXISTS (SELECT 'TRUE' FROM [000.000.0.000\SQL_ALPHA].[NAME_DATABASE_20181122].[dbo].[RFT01700] F017  
                 WHERE F017.idfunselec = F094.idfunselec  
                   AND F017.idverba    = p.idverba)  
   GROUP BY F094.idfunselec, F094.idparcalc, F094.idcontrato, p.idverba, p.itemtabdiv  
   HAVING ((SUM(CASE F094.adicional WHEN 1 THEN F094.valor ELSE -F094.valor END) > 0 AND p.itemtabdiv BETWEEN 10  AND  49) OR -- Adicionais de Provis�o  
           (SUM(CASE F094.adicional WHEN 1 THEN F094.valor ELSE -F094.valor END) < 0 AND p.itemtabdiv BETWEEN 100 AND 149     -- Estornos de provis�o  
                                                                                     AND p.itemtabdiv NOT IN (109,110,111)))  -- Exceto estornos de INSS,RPPS,FGTS de f�rias em pec�nia  
     
/*
  INSERT INTO [dbo].[RFT01700] (
        idcalculo, idcontrato, anoreferenc,  mesreferenc, tipodefolha, tipoverba,
        idverba, numprocalc, qtdeverba, valorverba, idfunselec, informada
  )
*/        
   
SELECT BKP.idcalculo, BKP.idcontrato, BKP.anoreferenc, BKP. mesreferenc, BKP.tipodefolha, BKP.tipoverba,
       BKP.idverba, BKP.numprocalc, BKP.qtdeverba, BKP.valorverba, BKP.idfunselec, BKP.informada
  INTO #TEMP
  FROM [000.000.0.000\SQL_ALPHA].[NAME_DATABASE_20181122].[dbo].[RFT01700] BKP
 INNER JOIN #Parametrizacao TMP ON TMP.idverba = BKP.idverba
 INNER JOIN [000.000.0.000\SQL_ALPHA].[NAME_DATABASE_20181122].[dbo].[RFT01600] F016 ON F016.idfunselec = BKP.idfunselec
 INNER JOIN [000.000.0.000\SQL_ALPHA].[NAME_DATABASE_20181122].[dbo].[RFT00900] F009 ON F009.idparcalc  = F016.idparcalc                                
 WHERE BKP.anoreferenc = 2018   
   AND NOT EXISTS (SELECT 'TRUE' FROM dbo.RFT01700 F017
                   WHERE  F017.idcontrato  = bkp.idcontrato
                   AND    F017.tipodefolha = bkp.tipodefolha
                   AND    F017.anoreferenc = bkp.anoreferenc
                   AND    F017.mesreferenc = bkp.mesreferenc
                   AND    F017.idverba     = bkp.idverba)

/* SEARCH DATA */
SELECT 
       F003.idverba,
       F003.codverba,
       F003.desredverba,
       F003.desnorverba,
       F003.tipoverba 
  FROM #Parametrizacao P
 INNER JOIN RFT00300 F003 ON F003.idverba = P.idverba
 
 
/* SEARCH DATA */ 
SELECT * FROM RFT00300 F003
WHERE F003.idverba IN ( 2163,2164,2166,2167,2168,2169,2170,2171,2172,2366,2367,2368,2369,
                        2370,2371,2372,2373,2374,2173,2174,2175,2176,2177,2178,2179,2180,
                        2181,2182,2183,2184,2185,2186,2187,2188,2189,2190,2191,2192,2238,
                        2239,2240,2363,2364,2365,2375,2376,2377,2378,2379,2380)
