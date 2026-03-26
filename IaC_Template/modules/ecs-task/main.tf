############################################################
# CloudWatch Log Group for ECS Task
############################################################
resource "aws_cloudwatch_log_group" "task_logs" {
  name              = "/ecs/${var.environment}-${var.service_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Environment = var.environment
    Service     = var.service_name
  }
}

############################################################
# ECS Task Definition
############################################################
resource "aws_ecs_task_definition" "task" {
  family                   = "${var.environment}-${var.service_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = var.cpu
  memory = var.memory

  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = "${var.ecr_repository_url}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.task_logs.name
          awslogs-region        = var.region
          awslogs-stream-prefix = var.service_name
        }
      }

      environment = [
        for key, value in var.environment_variables : {
          name  = key
          value = value
        }
      ]
    }
  ])
  
  tags = {
    Environment = var.environment
    Service     = var.service_name
  }
}
