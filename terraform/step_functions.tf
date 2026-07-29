resource "aws_sfn_state_machine" "etl_state_machine" {
  name     = "${var.project_name}-etl-state-machine"
  role_arn = aws_iam_role.step_functions_role.arn

  definition = file("${path.module}/../step-functions/state_machine.json")
}
