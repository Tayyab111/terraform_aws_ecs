# data "aws_secretsmanager_random_password" "random_password_generate" {
#   password_length     = var.aws_secrete.pass_length 
#   exclude_numbers     = var.aws_secrete.exclude_numbers
#   exclude_uppercase   = var.aws_secrete.exclude_uppercase
#   exclude_lowercase   = var.aws_secrete.exclude_lowercase
#   exclude_characters  = var.aws_secrete.exclude_characters
# }

# resource "aws_secretsmanager_secret" "my_secret" {
#   name = var.aws_secrete.secrete_manager_name
#   tags = merge(var.tags, {Name = var.aws_secrete.secrete_manager_name})
# }

# resource "aws_secretsmanager_secret_version" "my_secret_for_rds" {
#   secret_id     = aws_secretsmanager_secret.my_secret.id
  
#   secret_string = jsonencode({
#     username = var.aws_secrete.u_name_for_secrete #"tayyab" #var.user_name
#     password = data.aws_secretsmanager_random_password.random_password_generate
#   })
# }
data "aws_secretsmanager_secret" "secrets" {
  arn = "arn:aws:secretsmanager:us-east-1:654654575882:secret:my_rds_secretss-iQiojQ"
}


data "aws_secretsmanager_secret_version" "rds_secrets_version" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}