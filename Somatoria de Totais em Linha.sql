DECLARE @idfunselec INT
SET @idfunselec = 72406

SELECT f017.idfunselec
      ,TotalVencto = MAX(CASE
                           WHEN RS.tipoverba = 0 THEN RS.Total
                           ELSE 0.00
                         END)
      ,TotalDescto = MAX(CASE
                           WHEN RS.tipoverba = 1 THEN RS.Total
                           ELSE 0.00
                         END)
      ,TotalLiquid = MAX(CASE
                           WHEN RS.tipoverba = 0 THEN RS.Total
                           ELSE 0.00
                         END) -
                     MAX(CASE
                           WHEN RS.tipoverba = 1 THEN RS.Total
                           ELSE 0.00
                         END)
FROM   [dbo].[RFT01701] F017
INNER  JOIN (SELECT F017x.idfunselec,  f017x.tipoverba, total = SUM(f017x.valorverba)
            FROM   dbo.RFT01700 F017x
            WHERE  F017x.idfunselec = @idfunselec
            AND    F017x.tipoverba  IN (0,1)
            GROUP  BY F017x.idfunselec,  f017x.tipoverba
           ) RS ON RS.idfunselec = F017.idfunselec
WHERE  F017.idfunselec = @idfunselec
AND    F017.tipoverba  IN (0,1)
GROUP BY F017.idfunselec