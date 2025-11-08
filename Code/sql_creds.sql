-- CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AzureSynapse@123';
-- CREATE DATABASE SCOPED CREDENTIAL bhaveshadmin WITH IDENTITY = 'Managed Identity';

-- SELECT * FROM sys.database_credentials;

CREATE EXTERNAL FILE FORMAT extfileformat WITH (
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
);


CREATE EXTERNAL DATA SOURCE goldlayer WITH (
    LOCATION = 'https://olist1storageaccount.dfs.core.windows.net/olistcontainer/gold',
    CREDENTIAL = bhaveshadmin
);


CREATE EXTERNAL TABLE gold.finaltable WITH (
        LOCATION = 'Serving',
        DATA_SOURCE = goldlayer,
        FILE_FORMAT = extfileformat
) AS
SELECT * FROM gold.final;
