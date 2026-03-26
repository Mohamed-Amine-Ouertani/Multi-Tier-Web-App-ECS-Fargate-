output "ecs_cpu_high_alarm_id" {
  value = aws_cloudwatch_metric_alarm.ecs_cpu_high.id
}

output "dashboard_name" {
  value = aws_cloudwatch_dashboard.main.dashboard_name
}
