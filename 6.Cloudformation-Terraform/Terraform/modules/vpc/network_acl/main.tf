resource "aws_network_acl" "main" {
  vpc_id = var.vpc.vpc_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    to_port    = 0
    from_port  = 0
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    protocol   = "-1"
    rule_no    = 100
    to_port    = 0
  }

  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.vpc.vpc_name}-${var.name}"
  }
}

