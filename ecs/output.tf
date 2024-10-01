output "ecs_cluster_name" {
  value = aws_ecs_cluster.my_ecs_cluster.name
}
output "ecs_service_name" {
  value = aws_ecs_service.python_app_service.name
}