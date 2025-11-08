CREATE SCHEMA gold

CREATE VIEW gold.final 
AS
SELECT
    *
FROM
    OPENROWSET(
        BULK 'https://olist1storageaccount.dfs.core.windows.net/olistcontainer/silver/',
        FORMAT = 'PARQUET'
    ) AS result1


SELECT * FROM gold.final