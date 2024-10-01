output "ecs_cloudwatch_logs" {
  value = aws_cloudwatch_log_group.ecs_logs.name
}