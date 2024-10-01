resource "aws_security_group" "ecs_sg" {
  name        = var.sg_config.name
  description = "s_g for continer"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {Name = var.sg_config.name})
  dynamic "ingress" {
    for_each = var.sg_config.ingress_rules
      content {
        description = ingress.value.description
        from_port = ingress.value.from_port
        to_port = ingress.value.to_port
        protocol = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
        ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      }
  }

   egress {
    from_port   = var.sg_egress.from_port
    to_port     = var.sg_egress.to_port
    protocol    = var.sg_egress.protocol
    cidr_blocks = var.sg_egress.cidr_block
  }
}
  