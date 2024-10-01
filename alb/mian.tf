resource "aws_alb" "ecs_alb" {
  #name            = "${var.tags.Name}-${var.alb.name}"
  subnets         = var.public_subnet
  security_groups = var.sg
  load_balancer_type = var.alb.load_balancer_type
  internal        = var.alb.internal
  idle_timeout    = var.alb.idle_timeout
  ip_address_type = var.alb.ip_address_type
  tags = merge(var.tags , {Name = "alb"}) 
}
resource "aws_alb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_alb.ecs_alb.arn
  
  port              =   var.alb.alb_listener.port
  protocol          = var.alb.alb_listener.protocol
  
  default_action {    
    target_group_arn = aws_alb_target_group.ecs_alb_target_group.arn 
    type             = var.alb.alb_listener.default_action_type
  }
}
resource "aws_alb_target_group" "ecs_alb_target_group" {

  #name = "${var.tags.Name}-wordpress-tg"
  port     = var.alb.alb_listener.port
  protocol = var.alb.alb_listener.protocol
  vpc_id  = var.vpc_id
  tags = merge(var.tags, {Name = "tg_group"})
  target_type = "ip"

  health_check {
    healthy_threshold   = var.alb.alb_tg_group.healthy_threshold
    unhealthy_threshold = var.alb.alb_tg_group.unhealthy_threshold
    timeout             = var.alb.alb_tg_group.timeout
    interval            = var.alb.alb_tg_group.interval
    matcher             = var.alb.alb_tg_group.matcher # it will return health status between(200-303)
  }
}
