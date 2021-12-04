resource "aws_route_table" "r" {

  vpc_id = var.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "${var.vpc.vpc_name}-${var.name}"
  }
}

resource "aws_route_table_association" "a" {
  for_each = { for i, val in var.subnet_ids : i => val }

  subnet_id      = each.value
  route_table_id = aws_route_table.r.id
}
