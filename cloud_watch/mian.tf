# increase one ec2 f cpu is greater then 30. 
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name                = var.cloudwatch_alarm.high_cpu.alarm_name
  comparison_operator       = var.cloudwatch_alarm.high_cpu.comparison_operator
  evaluation_periods        = var.cloudwatch_alarm.high_cpu.evaluation_periods
  metric_name               = var.cloudwatch_alarm.high_cpu.metric_name
  namespace                 = var.cloudwatch_alarm.high_cpu.namespace
  period                    = var.cloudwatch_alarm.high_cpu.period
  statistic                 = var.cloudwatch_alarm.high_cpu.statistic
  threshold                 = var.cloudwatch_alarm.high_cpu.threshold
  alarm_description         = var.cloudwatch_alarm.high_cpu.alarm_description
  insufficient_data_actions = var.cloudwatch_alarm.high_cpu.insufficient_data_actions
  ok_actions = var.cloudwatch_alarm.high_cpu.ok_actions
  alarm_actions = [
      "${aws_sns_topic.my_sns_topic.arn}",
      #var.autoscaling_policy_scale_out_arn
  ]
#   dimensions = {
#     AutoScalingGroupName = var.autoscaling_name_for_alarm
  tags = merge(var.tags, {Name = var.cloudwatch_alarm.high_cpu.alarm_name})
#     }
   }

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  
  alarm_name = lookup(var.cloudwatch_alarm.low_cpu, "alarm_name", var.cloudwatch_alarm.high_cpu.alrm_name)
  comparison_operator = var.cloudwatch_alarm.low_cpu.comparison_operator
  evaluation_periods = var.cloudwatch_alarm.low_cpu.evaluation_periods
  metric_name = var.cloudwatch_alarm.low_cpu.metric_name
  namespace = var.cloudwatch_alarm.low_cpu.namespace
  period = var.cloudwatch_alarm.low_cpu.period
  statistic = var.cloudwatch_alarm.low_cpu.statistic
  threshold = var.cloudwatch_alarm.low_cpu.threshold
  alarm_description = var.cloudwatch_alarm.low_cpu.alarm_description
  insufficient_data_actions = var.cloudwatch_alarm.low_cpu.insufficient_data_actions
  ok_actions = var.cloudwatch_alarm.low_cpu.ok_actions
  alarm_actions = [
    aws_sns_topic.my_sns_topic.arn,
    #var.autoscaling_policy_scale_in_arn
  ]
#   dimensions = {
#     AutoScalingGroupName = var.autoscaling_name_for_alarm
#     }
  tags = merge(var.tags, {Name = var.cloudwatch_alarm.low_cpu.alarm_name})
  }

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "ecs_logs"
}

resource "aws_sns_topic" "my_sns_topic" {
  name = var.cloudwatch_alarm.sns_topic.name
  tags = merge(var.tags, {Name = var.cloudwatch_alarm.sns_topic.name})
}

resource "aws_sns_topic_subscription" "my_sns_topic_subscription" {
  topic_arn = aws_sns_topic.my_sns_topic.arn
  protocol  = var.cloudwatch_alarm.sns_topic.protocol
  endpoint  = var.cloudwatch_alarm.sns_topic.endpoint
}