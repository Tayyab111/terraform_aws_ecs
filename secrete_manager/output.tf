output "rds_password" {
  value = data.aws_secretsmanager_secret_version.rds_secrets_version.secret_string
}