resource "aws_security_group" "sg" {
  name        = "${var.vpc.vpc_name}-${var.name}"
  description = var.description
  vpc_id      = var.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.ingresses
    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks != null ? ingress.value.cidr_blocks : null
      security_groups = ingress.value.security_groups != null ? ingress.value.security_groups : null
    }
  }

  dynamic "egress" {
    for_each = var.egresses
    content {
      description     = egress.value.description
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks != null ? egress.value.cidr_blocks : null
      security_groups = egress.value.security_groups != null ? egress.value.security_groups : null
    }
  }

  tags = {
    Name = "${var.vpc.vpc_name}-${var.name}"
  }
}


