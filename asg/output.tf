output "autoscaling_group_name" {
  value = aws_appautoscaling_target.ecs_autoscaling
}
output "scale_out_arn" {
  value = aws_appautoscaling_policy.scale_out_policy.arn
}

output "scale_in_arn" {
  value = aws_appautoscaling_policy.scale_in_policy.arn
}