output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "cluster_arn" {
  value = aws_ecs_cluster.cluster.arn
}

output "capacity_providers" {
  value = aws_ecs_cluster_capacity_providers.this.capacity_providers
}

output "ecs_execution_role_arn" {
  description = "IAM Execution Role for ECS Tasks"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "IAM Task Role for ECS containers"
  value       = aws_iam_role.ecs_task_role.arn
}
