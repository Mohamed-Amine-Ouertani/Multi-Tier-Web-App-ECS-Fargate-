############################################################
# ECS Cluster
############################################################
resource "aws_ecs_cluster" "cluster" {
  name = "${var.environment}-ecs-cluster"

  # Enable Container Insights for metrics
  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = {
    Name        = "${var.environment}-ecs-cluster"
    Environment = var.environment
  }
}

############################################################
# Fargate Capacity Providers (Optional)
############################################################
resource "aws_ecs_capacity_provider" "fargate" {
  name = "${var.environment}-fargate"

}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

