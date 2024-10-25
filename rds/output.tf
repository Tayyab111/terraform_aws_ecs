output "ecs_rds_endpoint" {
  value = aws_rds_cluster.db_cluster.endpoint
}

# output "rds_db_name" {
#   value = aws_rds_cluster_instance.db_cluster_instances[*].identifier
# }
output "rds_password" {
  value = aws_rds_cluster.db_cluster.master_password
}