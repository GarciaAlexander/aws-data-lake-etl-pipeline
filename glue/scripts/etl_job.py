import sys
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions
from pyspark.sql.functions import col, when, to_date

args = getResolvedOptions(sys.argv, ["JOB_NAME"])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# 1. Read raw CSV from S3
raw_path = "s3://aws-data-lake-etl-raw/messy_vendor_data.csv"
df = spark.read.option("header", True).csv(raw_path)

# 2. Clean messy data
df = df.replace("N/A", None)
df = df.withColumn("amount", col("amount").cast("float"))
df = df.withColumn("date", to_date(col("date"), "yyyy-MM-dd"))
df = df.withColumn(
    "vendor",
    when(col("vendor").isNull(), "Unknown").otherwise(col("vendor"))
)

# 3. Write curated Parquet partitioned by vendor
curated_path = "s3://aws-data-lake-etl-curated/vendor_data/"
df.write.mode("overwrite").partitionBy("vendor").parquet(curated_path)

job.commit()
