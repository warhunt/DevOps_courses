output "subnet_ids" {
  value = tomap({
    for k, v in aws_subnet.subnets : k => v.id
  })
}
