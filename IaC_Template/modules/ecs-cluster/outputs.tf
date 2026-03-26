output "cluster_id" {
  description = "ID of the ECS Cluster"
  value       = aws_ecs_cluster.cluster.id
}

output "cluster_name" {
  description = "Name of the ECS Cluster"
  value       = aws_ecs_cluster.cluster.name
}

output "capacity_providers" {
  description = "Capacity providers associated with this cluster"
  value       = aws_ecs_cluster_capacity_providers.this.capacity_providers
}