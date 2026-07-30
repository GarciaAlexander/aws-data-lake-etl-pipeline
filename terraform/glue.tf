############################################
# Glue Database
############################################

resource "aws_glue_catalog_database" "raw_db" {
  name = "${var.project_name}-raw-db"
}

############################################
# Glue Crawler
############################################

resource "aws_glue_crawler" "raw_crawler" {
  name          = "${var.project_name}-raw-crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.raw_db.name

  s3_target {
    path = "s3://${aws_s3_bucket.raw.bucket}/"
  }

  classifiers = []
}
