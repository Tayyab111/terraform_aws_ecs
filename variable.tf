variable "vpc" {}
variable "sg" {}
#variable "sg_config" {
  
#}
variable "sg_egress" {}

variable "rds_cluster" {}

variable "ecs_cluster" {
  default = "ok"
  }
variable "aws_secrete" {}
variable "alb" {}
variable "ecs_asg" {}
variable "cloudwatch_alarm" {}
variable "tags" {}