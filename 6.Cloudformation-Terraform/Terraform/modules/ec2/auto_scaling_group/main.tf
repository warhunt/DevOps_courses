resource "aws_autoscaling_group" "nginx_asg" {
  name                      = "${var.vpc.vpc_name}-${var.name}"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 10
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  load_balancers            = var.load_balancers
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = var.vpc_zone_identifier

  tag {
    key                 = "name"
    value               = "${var.vpc.vpc_name}-${var.name}"
    propagate_at_launch = false
  }

  lifecycle {
    create_before_destroy = true
  }

}

data "aws_ami" "aws-linux2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  owners = ["amazon"]
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix     = "nginx-lc-"
  image_id        = data.aws_ami.aws-linux2.id
  instance_type   = "t2.micro"
  security_groups = var.security_groups
  user_data       = file("./modules/ec2/instance/install_nginx.sh")
  key_name        = "Wolly-NCalifornia"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "nginx_sp" {
  for_each = var.scaling_policyes

  name                   = "${var.vpc.vpc_name}-${each.value.name}"
  scaling_adjustment     = each.value.scaling_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.nginx_asg.name

  depends_on = [
    aws_autoscaling_group.nginx_asg
  ]
}
