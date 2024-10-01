resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = var.ecs_cluster.cluster_name
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.ecs_cluster.task_definition.family
  requires_compatibilities = var.ecs_cluster.task_definition.requires_compatibilities
  execution_role_arn       = "arn:aws:iam::654654575882:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::654654575882:role/ecsTaskExecutionRole"
  cpu                      = var.ecs_cluster.task_definition.cpu
  memory                   = var.ecs_cluster.task_definition.memory
  network_mode             = var.ecs_cluster.task_definition.network_mode

  container_definitions = jsonencode([var.ecs_cluster.task_definition.container])
  #tags = merge(var.ecs_cluster.cluster_name.namee, {Name = "task_definition"})
  #tags = merge(var.ecs_cluster.cluster_name, {Name = "task"})
}


resource "aws_ecs_service" "python_app_service" {
  tags = merge(var.tags, {Name = var.ecs_cluster.ecs_service.name})
  name = var.ecs_cluster.ecs_service.name
  cluster = aws_ecs_cluster.my_ecs_cluster.id 
  task_definition = aws_ecs_task_definition.ecs_task_definition.id
  desired_count = var.ecs_cluster.ecs_service.desired_count
  deployment_minimum_healthy_percent =  var.ecs_cluster.ecs_service.deployment_minimum_healty_percent
  deployment_maximum_percent =  var.ecs_cluster.ecs_service.deployment_maximum_percent
  launch_type = var.ecs_cluster.ecs_service.launch_type
  network_configuration {
    subnets         = var.public_subnet_ids
    assign_public_ip = var.ecs_cluster.ecs_service.assign_public_ip
    security_groups = var.sg_ids
  }
  load_balancer {
    target_group_arn = var.tg_group_arn
    container_name = var.ecs_cluster.task_definition.container.name
    // This port is for the app which is running inside conatainer
    // The tg_port_for_app getting form main.tf
    container_port = 8000 #var.ecs_cluster.ecs_service.tg_port_for_app
  }

}