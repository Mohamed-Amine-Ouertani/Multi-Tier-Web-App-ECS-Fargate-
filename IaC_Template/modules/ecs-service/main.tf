############################################################
# Target Group for ECS Service
############################################################
resource "aws_lb_target_group" "service_tg" {
  name        = "${var.environment}-${var.service_name}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = var.health_check_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    Environment = var.environment
    Service     = var.service_name
  }
}

############################################################
# ALB Listener Rule
############################################################
resource "aws_lb_listener_rule" "service_listener_rule" {
  listener_arn = var.module.alb.listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_tg.arn
  }

  condition {
    path_pattern {
      values = var.path_patterns
    }
  }

  tags = {
    Environment = var.environment
    Service     = var.service_name
  }
}

############################################################
# ECS Service
############################################################
resource "aws_ecs_service" "service" {
  name            = "${var.environment}-${var.service_name}"
  cluster         = module.iam.aws_ecs_cluster.cluster.arn
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = module.security-groups.app_sg_id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service_tg.arn
    container_name   = var.service_name
    container_port   = var.container_port
  }

  depends_on = [
    aws_lb_target_group.service_tg
  ]

  tags = {
    Environment = var.environment
    Service     = var.service_name
  }
}

############################################################
# Auto Scaling Target
############################################################
resource "aws_appautoscaling_target" "ecs_scaling" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

############################################################
# Scale-Out Policy
############################################################
resource "aws_appautoscaling_policy" "scale_out" {
  name               = "${var.environment}-${var.service_name}-scale-out"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

############################################################
# Scale-In Policy
############################################################
resource "aws_appautoscaling_policy" "scale_in" {
  name               = "${var.environment}-${var.service_name}-scale-in"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 20

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
