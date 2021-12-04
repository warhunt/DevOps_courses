resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = var.vpc.vpc_id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  availability_zone       = each.value.availability_zone

  tags = {
    Name = "${var.vpc.vpc_name}-${each.value.name}"
  }
}
