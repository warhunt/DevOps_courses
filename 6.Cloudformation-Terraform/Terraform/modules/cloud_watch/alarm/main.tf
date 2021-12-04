resource "aws_cloudwatch_metric_alarm" "alarm" {
  for_each = var.alarms

  alarm_name          = "${var.vpc.vpc_name}-${each.value.alarm_name}"
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = each.value.threshold
  dimensions          = var.dimensions
  alarm_actions       = each.value.alarm_actions
}
