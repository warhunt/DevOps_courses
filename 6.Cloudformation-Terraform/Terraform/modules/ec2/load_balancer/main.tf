resource "aws_elb" "classic_elb" {
  name                      = "${var.vpc.vpc_name}-${var.name}"
  cross_zone_load_balancing = true
  instances                 = var.instances
  security_groups           = var.security_groups
  subnets                   = var.subnets

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    target              = "http:80/"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 10
    timeout             = 5
  }

  tags = {
    Name = "${var.vpc.vpc_name}-${var.name}"
  }
}
