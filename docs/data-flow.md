# Data Flow Documentation

## 1. Raw Zone (S3)
Incoming vendor/application data is stored in the raw zone:
`s3://aws-data-lake-etl-raw/`

## 2. Schema Discovery (Glue Crawler)
The Glue Crawler scans raw data and updates the AWS Glue Data Catalog.

## 3. ETL Transformation (Glue PySpark)
The Glue ETL job:
- cleans messy fields
- normalizes vendor names
- casts types (amount, date)
- writes partitioned Parquet

Output is stored in:
`s3://aws-data-lake-etl-curated/vendor_data/`

## 4. Analytics Zone (Athena)
Athena queries curated Parquet files using the external table defined in `curated_schema.sql`.

## 5. Orchestration (Step Functions)
Step Functions coordinates:
1. RunCrawler
2. RunETLJob

## 6. Scheduling (EventBridge)
EventBridge triggers the pipeline daily.

## 7. Monitoring (CloudWatch)
CloudWatch provides:
- Glue job logs
- Step Functions logs
- ETL failure alarms (SNS)
