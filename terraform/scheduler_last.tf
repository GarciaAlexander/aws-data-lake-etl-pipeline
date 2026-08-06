resource "aws_scheduler_schedule" "etl_schedule" {
  name = "etl-pipeline-schedule"

  # WARNING:
  # Changing this schedule to a short interval (e.g., rate(5 minutes))
  # will repeatedly trigger the Glue ETL job and can generate charges.
  # Keep this at rate(1 day) unless you fully understand the cost impact.

  schedule_expression = "rate(1 day)"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn = aws_sfn_state_machine.etl_state_machine.arn
    role_arn = aws_iam_role.eventbridge_invoke_stepfunctions_role.arn
  }
}
