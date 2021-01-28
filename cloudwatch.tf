resource "aws_cloudwatch_log_group" "main" {
  name = "aws_cloudwatch_log_app"

  tags = {
    Environment = "development"
    Application = "operations-task-app"
  }
}
