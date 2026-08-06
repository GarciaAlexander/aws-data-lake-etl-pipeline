resource "aws_sns_topic" "etl_alerts" {
  name = "etl-failure-alerts"
}

resource "aws_sns_topic_subscription" "etl_alerts_email" {
  topic_arn = aws_sns_topic.etl_alerts.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"
}

resource "aws_cloudwatch_metric_alarm" "glue_etl_failure" {
  alarm_name          = "GlueETLJobFailure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "glue.job.failed"
  namespace           = "AWS/Glue"
  period              = 300
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    JobName = "aws-data-lake-etl-etl-job"
  }

  alarm_description = "Alarm when the Glue ETL job fails"
  alarm_actions     = [aws_sns_topic.etl_alerts.arn]
}
