output "instance_ids" {
  value = tomap({
    for k, v in aws_instance.web : k => v.id
  })
}
