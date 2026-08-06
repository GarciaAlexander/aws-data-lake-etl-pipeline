CREATE EXTERNAL TABLE IF NOT EXISTS curated_sales_data (
    id INT,
    name STRING,
    vendor STRING,
    amount FLOAT,
    date DATE
)
PARTITIONED BY (vendor STRING)
STORED AS PARQUET
LOCATION 's3://aws-data-lake-etl-curated/vendor_data/'
TBLPROPERTIES (
    'parquet.compression'='SNAPPY'
);
