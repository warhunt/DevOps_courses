output "scaling_policyes" {
  value = tomap({
    for k, v in aws_autoscaling_policy.nginx_sp : k => v.arn
  })
}

output "name" {
  value = aws_autoscaling_group.nginx_asg.name
}
