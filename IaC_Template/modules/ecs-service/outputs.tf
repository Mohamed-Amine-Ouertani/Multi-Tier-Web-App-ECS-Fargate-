output "service_arn" {
  description = "ECS Service ARN"
  value       = aws_ecs_service.service.arn
}

output "target_group_arn" {
  description = "Load Balancer Target Group ARN"
  value       = aws_lb_target_group.service_tg.arn
}
output "service_name" {
  description = "ECS Service Name"
  value = aws_ecs_service.service.name
}
