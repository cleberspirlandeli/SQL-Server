-- DETALHE DE CADA COLUNA REFERENTE A TABELA

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'RFT01600'
ORDER BY ORDINAL_POSITION