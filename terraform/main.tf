############################################
# VPC (Private Only — Free Tier Compatible)
############################################

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-b"
  }
}

############################################
# S3 Buckets (Raw, Curated, Analytics)
############################################

resource "aws_s3_bucket" "raw" {
  bucket = "${var.project_name}-raw"

  tags = {
    Name = "${var.project_name}-raw"
  }
}

resource "aws_s3_bucket" "curated" {
  bucket = "${var.project_name}-curated"

  tags = {
    Name = "${var.project_name}-curated"
  }
}

resource "aws_s3_bucket" "analytics" {
  bucket = "${var.project_name}-analytics"

  tags = {
    Name = "${var.project_name}-analytics"
  }
}

############################################
# IAM Role for Glue
############################################

resource "aws_iam_role" "glue_role" {
  name = "${var.project_name}-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "glue.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "glue_s3_access" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "glue_basic" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

############################################
# IAM Role for Step Functions
############################################

resource "aws_iam_role" "step_functions_role" {
  name = "${var.project_name}-step-functions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "states.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "step_functions_basic" {
  role       = aws_iam_role.step_functions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
}

resource "aws_iam_role_policy" "step_functions_glue_access" {
  role = aws_iam_role.step_functions_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "glue:StartCrawler",
          "glue:GetCrawler",
          "glue:StartJobRun",
          "glue:GetJobRun"
        ],
        Resource = "*"
      }
    ]
  })
}

############################################
# CloudWatch Log Groups
############################################

resource "aws_cloudwatch_log_group" "glue_logs" {
  name              = "/aws/glue/${var.project_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "step_functions_logs" {
  name              = "/aws/states/${var.project_name}"
  retention_in_days = 14
}
