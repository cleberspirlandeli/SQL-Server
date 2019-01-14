DECLARE @idfunselec INT
SET @idfunselec = 72406

SELECT X17.idfunselec
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
FROM   [dbo].[XYZ171] X17
INNER  JOIN (SELECT X17x.idfunselec,  X17x.tipoverba, total = SUM(X17x.valorverba)
            FROM   dbo.XZY170 X17x
            WHERE  X17x.idfunselec = @idfunselec
            AND    X17x.tipoverba  IN (0,1)
            GROUP  BY X17x.idfunselec,  X17x.tipoverba
           ) RS ON RS.idfunselec = X17.idfunselec
WHERE  X17.idfunselec = @idfunselec
AND    X17.tipoverba  IN (0,1)
GROUP BY X17.idfunselec