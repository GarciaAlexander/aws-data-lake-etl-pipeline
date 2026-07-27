output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets" {
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

output "raw_bucket" {
  value = aws_s3_bucket.raw.bucket
}

output "curated_bucket" {
  value = aws_s3_bucket.curated.bucket
}

output "analytics_bucket" {
  value = aws_s3_bucket.analytics.bucket
}

output "glue_role_arn" {
  value = aws_iam_role.glue_role.arn
}

output "step_functions_role_arn" {
  value = aws_iam_role.step_functions_role.arn
}
