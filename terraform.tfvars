tags = {
      Name = "ecs"
    }
vpc = {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    public_subnet = {
        cidr_block = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
        map_public_ip_on_launch = true
        availability_zone = ["us-east-1a", "us-east-1b"]
    }
    public_route_table = {
        cidr_block = "0.0.0.0/0"
    }
    private_route_table = {
        cidr_block = "0.0.0.0/0"
    }
    private_subnet = {
        cidr_block = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
        availability_zone = ["us-east-1a", "us-east-1b"]
    }
}
###################
sg = {
    ct_sg = {
        name = "ecs_sg"
        ingress_rules = {
            rule_1 = {

        description      = "Example Ingress 1"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      },

      rule_3 = {
        description      = "Example Ingress 3"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }

      rule_4 = {
        description      = "Example Ingress 3"
        from_port        = 8000
        to_port          = 8000
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }
        }
    }
    rds_sg = {
        name = "rds_sg"
        ingress_rules = {
            rule_1 = {

        description      = "Example Ingress 1"
        from_port        = 3306
        to_port          = 3306
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }
    }
  }
}
sg_egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_block = ["0.0.0.0/0"]
}
######################
rds_cluster = {
  db_subnet_group_name = "rds_subnet_group"
    
  cluster_identifier = "mysql-cluster"
  engine = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.11.3"
  availability_zones = ["us-east-1a", "us-east-1b"] #, "us-east-1c"]
  database_name = "mydb"
  master_username = "tayab"
  
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  
  skip_final_shapshot = true

  cluster_instance = {
    identifier = ["my-db"]
    instance_class = "db.t3.small"
    publicly_accessible = false 
    apply_immediately   = true
  }
}
##################
ecs_cluster = {
  cluster_name = { name = "python_ecs_cluster" }  
  task_definition = {
    family = "Farget_task_definition"
    requires_compatibilities = ["FARGATE"]
    cpu = 256
    memory = 512
    network_mode = "awsvpc"

    container = {
      "name" = "python_contianer",
      "image" = "654654575882.dkr.ecr.us-east-1.amazonaws.com/new_ecr:latest",
      #"cpu" = 512,
      #"memory" = 512,
      "essentials" = "true",

      # log_configuration = {
      #   log_driver = "awslogs"
      #   options = {
      #     "awslogs-group"         = ""
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
      environment = [
        {
          name  = "DB_HOST"
          value = ""
        },
        {
          name  = "DB_USER"
          value = ""
        },
        {
          name  = "DB_PASSWORD"
          value = ""
        },
        {
          name = "DB_NAME"
          value = ""
        }
      ]
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
#########################
aws_secrete = {
  pass_length = 9
  exclude_numbers = false
  exclude_uppercase = false
  exclude_lowercase = false
  exclude_characters = "!@#$%^&*()?> <.=:;|-_+}]/,"

  secrete_manager_name = "my_secrete_for_rdsaaaaaaaaaa"

  u_name_for_secrete = "tayyab"
}
################
alb = {
  name = "ecs_alb"
  load_balancer_type = "application"
  internal = "false"
  idle_timeout = 400
  ip_address_type = "ipv4"
  
  alb_listener = {
    port = 80
    protocol = "HTTP"

    default_action_type = "forward"
  }
  alb_tg_group = {
    healthy_threshold = 3
    unhealthy_threshold = 10
    timeout = 5
    interval = 10
    matcher = "200-303"
  }
}
#############
ecs_asg = {
  max_capacity = 2
  min_capacity =1
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"

  scale_out = {
    name = "scale_out_policy"
    policy_type = "StepScaling"
    adjustment_type = "ChangeInCapacity"
    cooldown = 60
    metric_aggregation_type = "Average"

    scaling_adjustment = 1
    metric_interval_lower_bound = 30
    metric_interval_upper_bound = 80

    # if cpu is more then 80
    scaling_adjustment_two = 2
    metric_interval_more_then_80 = 80
  }
  scale_in = {
    name = "scale_in_policy"
    policy_type = "StepScaling"
    adjustment_type = "ChangeInCapacity"
    cooldown = 60
    metric_aggregation_type = "Average"

    scaling_adjustment = -2
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 30
  
  }
}
############################
cloudwatch_alarm = {
  high_cpu = {
    alarm_name = "high_cpu_alarm"
    alrm_name = "decrease_in_cpu_alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods        = 2
    metric_name               = "CPUUtilization"
    namespace                 = "AWS/EC2"
    period                    = 120
    statistic                 = "Average"
    threshold                 = "30"
    alarm_description         = "This metric monitors ec2 cpu utilization, if it goes above 40% for 2 periods it will trigger an alarm"
    insufficient_data_actions = []
    ok_actions                = []
  }
  low_cpu = {
    alarm_name = "low_cpu_alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods        = 2
    metric_name               = "CPUUtilization"
    namespace                 = "AWS/EC2"
    period                    = 120
    statistic                 = "Average"
    threshold                 = "30"
    alarm_description         = "This metric monitors ec2 cpu utilization, if it goes below 40% for 2 periods it will trigger an alarm."
    insufficient_data_actions = []
    ok_actions = []
  }
  sns_topic = {
    name = "ecs_cpu_alarm_sns"
    protocol = "email"
    endpoint = "tayyabafridi843@gmail.com"
  }
}
