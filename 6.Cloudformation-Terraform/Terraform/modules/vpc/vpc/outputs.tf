output "vpc_obj" {
  value = {
    vpc_id   = aws_vpc.vpc.id
    vpc_name = var.name
  }
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_name" {
  value = var.name
}
