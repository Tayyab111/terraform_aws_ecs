
locals {
  #pass = jsondecode(module.secret_mngr.rds_password) ["password"]
  #pass = jsondecode(data.aws_secretsmanager_secret_version.rds_secrets_version.secret_string) ["password"]
  new_env_vars = [
        {
          name  = "DB_HOST"
          value = module.rds.ecs_rds_endpoint
        },       
        {
          name  = "DB_USER"
          value = "tayab"
        },
        {
         name  = "DB_PASSWORD"
         #value = local.pass
         value = module.secret_mngr.rds_password
       },
        {
          name = "DB_NAME"
          value = "mydb"
        }
  ]
  # ecs_logs_vars = [
  #   name = ""
  # ]
  new_ecs_cluster = {
    cluster_name = "python_ecs_cluster"
  task_definition = {
    family = "Farget_task_definition"
    requires_compatibilities = ["FARGATE"]
    cpu = 256
    memory = 512
    network_mode = "awsvpc"

    container = {
      "name" = "python_contianer",
      "image" = "654654575882.dkr.ecr.us-east-1.amazonaws.com/new-ecr:latest",
      "essentials" = "true",

    #    "secrets": [{
    #   "name": "DB_PASSWORD",
    #   "valueFrom": "arn:aws:secretsmanager:us-east-1:654654575882:secret:tayyab-xFCEvc:password::"
    # }]
  
      # log_configuration = {
      #   log_driver = "awslogs"
      #   options = {
      #     "awslogs-group"         = import
      #     "awslogs-region"        = "your-region"
      #     "awslogs-stream-prefix" = "ecs"
      #   }
      # } 

      "portMappings" = [
        {
          containerPort = 8000
          hostPort = 8000
          protocol = "tcp"
      
        }
      ]
      environment = local.new_env_vars
    }
  }
  ecs_service = {
    name = "python_service"
    desired_count = 1
    deployment_minimum_healty_percent = 50
    deployment_maximum_percent = 200
    launch_type = "FARGATE"
    assign_public_ip = true
    #tg_port_for_app = 8000
  }
  }

}

#########################################
module "vpc" {
  source = "./vpc"
  vpc = var.vpc
  tags = var.tags
}

output "rds_endpoint" {
  value = module.rds.ecs_rds_endpoint
}
 output "rds_pass" {
   value =jsondecode(module.secret_mngr.rds_password) ["password"]
   #value = module.secret_mngr.rds_password
   sensitive = true
 }
module "security_group" {
  source = "./security_group" 
  for_each = var.sg
  sg_config = each.value
  vpc_id = module.vpc.vpc_id 
  sg_egress = var.sg_egress
  tags = var.tags

}

module "rds" {
  source = "./rds"
  rds_cluster = var.rds_cluster
  private_subnet_ids = module.vpc.private_subnet_ids
  sg_ids = [module.security_group["rds_sg"].sg_ids]
  rds_password = module.secret_mngr.rds_password
  tags = var.tags
}

module "ecs" {
  source = "./ecs"
  sg_ids = [module.security_group["ct_sg"].sg_ids]
  public_subnet_ids =  module.vpc.public_subnet_ids
  ecs_cluster = local.new_ecs_cluster
  tg_group_arn = module.alb.alb_tg_group_arn
  tags = var.tags 
  
}

module "secret_mngr" {
  source = "./secrete_manager"
  aws_secrete = var.aws_secrete
  tags = var.tags
  
}

module "alb" {
  source = "./alb"
  public_subnet = module.vpc.public_subnet_ids
  sg =  [module.security_group["ct_sg"].sg_ids]
  vpc_id = module.vpc.vpc_id
  alb = var.alb 
  tags = var.tags
}

# module "asg" {
#   source = "./asg"
#   ecs_asg = var.ecs_asg 
#   ecs_cluster_name = module.ecs.ecs_cluster_name
#   ecs_service_name = module.ecs.ecs_service_name
#   tg_group_arn = module.alb.alb_tg_group_arn
# }

module "cloudwatch" {
  source = "./cloud_watch"
  cloudwatch_alarm = var.cloudwatch_alarm
  tags = var.tags
  #autoscaling_policy_scale_out_arn = module.asg.scale_out_arn 
  #autoscaling_policy_scale_in_arn = module.asg.scale_in_arn
}  
