resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/fastapi-service"
  retention_in_days = 7
}