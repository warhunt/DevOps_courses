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

resource "aws_instance" "web" {
  for_each = var.instances

  ami             = data.aws_ami.aws-linux2.id
  instance_type   = "t2.micro"
  security_groups = var.security_groups
  subnet_id       = each.value.subnet_id
  user_data       = file("./modules/ec2/instance/install_nginx.sh")

  key_name = "Wolly-NCalifornia"
  tags = {
    Name = "${var.vpc.vpc_name}-${each.value.name}"
  }
}
