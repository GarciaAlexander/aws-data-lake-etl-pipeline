resource "aws_glue_job" "etl_job" {
  name     = "${var.project_name}-etl-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.raw.bucket}/scripts/etl_job.py"
    python_version  = "3"
  }

  glue_version = "4.0"

  default_arguments = {
    "--job-language"                      = "python"
    "--enable-continuous-cloudwatch-log"  = "true"
  }
}
