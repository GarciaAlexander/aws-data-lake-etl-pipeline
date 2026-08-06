resource "aws_iam_role" "eventbridge_invoke_stepfunctions_role" {
  name = "eventbridge-invoke-stepfunctions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "events.amazonaws.com",
            "scheduler.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "eventbridge_invoke_stepfunctions_policy" {
  role = aws_iam_role.eventbridge_invoke_stepfunctions_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "states:StartExecution"
        Resource = aws_sfn_state_machine.etl_state_machine.arn
      }
    ]
  })
}