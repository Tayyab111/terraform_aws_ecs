resource "aws_appautoscaling_target" "ecs_autoscaling" {
  max_capacity = var.ecs_asg.max_capacity
  min_capacity = var.ecs_asg.min_capacity
  resource_id = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = var.ecs_asg.scalable_dimension
  service_namespace = var.ecs_asg.service_namespace
}

resource "aws_appautoscaling_policy" "scale_out_policy" {
  name               = var.ecs_asg.scale_out.name 
  policy_type        = var.ecs_asg.scale_out.policy_type
  resource_id        = aws_appautoscaling_target.ecs_autoscaling.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_autoscaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_autoscaling.service_namespace

  
  step_scaling_policy_configuration {
    adjustment_type         = var.ecs_asg.scale_out.adjustment_type
    cooldown                = var.ecs_asg.scale_out.cooldown
    metric_aggregation_type = var.ecs_asg.scale_out.metric_aggregation_type

    step_adjustment {
      scaling_adjustment = var.ecs_asg.scale_out.scaling_adjustment
      metric_interval_lower_bound = var.ecs_asg.scale_out.metric_interval_lower_bound
      metric_interval_upper_bound = var.ecs_asg.scale_out.metric_interval_upper_bound
    }
    step_adjustment {
      scaling_adjustment = var.ecs_asg.scale_out.scaling_adjustment_two
      metric_interval_lower_bound = var.ecs_asg.scale_out.metric_interval_more_then_80
    }
  }
}
resource "aws_appautoscaling_policy" "scale_in_policy" {
  name = var.ecs_asg.scale_in.name 
  policy_type = var.ecs_asg.scale_in.policy_type
  resource_id = aws_appautoscaling_target.ecs_autoscaling.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_autoscaling.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_autoscaling.service_namespace

  
  step_scaling_policy_configuration {
    adjustment_type         = var.ecs_asg.scale_in.adjustment_type
    cooldown                = var.ecs_asg.scale_in.cooldown
    metric_aggregation_type = var.ecs_asg.scale_in.metric_aggregation_type
    step_adjustment {
      scaling_adjustment = var.ecs_asg.scale_in.scaling_adjustment
      metric_interval_lower_bound = var.ecs_asg.scale_in.metric_interval_lower_bound
      metric_interval_upper_bound = var.ecs_asg.scale_in.metric_interval_upper_bound
   }
   step_adjustment {
     scaling_adjustment = 0
     metric_interval_lower_bound = 29
     metric_interval_upper_bound = null
   }
  }
}

# resource "aws_autoscaling_attachment" "ataching_asg_and-alb" {
#   autoscaling_group_name = aws_appautoscaling_target.ecs_autoscaling.id
#   lb_target_group_arn = var.tg_group_arn
# }