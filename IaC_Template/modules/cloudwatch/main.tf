############################################################
# ECS CPU High Alarm
############################################################
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${var.environment}-ecs-${var.service_name}-cpu-high"
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 2
  period              = 60
  statistic           = "Average"

  dimensions = {
    ClusterName = module.ecs-cluster.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = var.alarm_notification_arns
}

############################################################
# ECS Memory High Alarm
############################################################
resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  alarm_name          = "${var.environment}-ecs-${var.service_name}-memory-high"
  namespace           = "AWS/ECS"
  metric_name         = "MemoryUtilization"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 2
  period              = 60
  statistic           = "Average"

  dimensions = {
    ClusterName = module.ecs-cluster.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = var.alarm_notification_arns
}

############################################################
# ALB 5XX Error Alarm
############################################################
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.environment}-alb-5xx"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 10
  evaluation_periods  = 1
  period              = 60
  statistic           = "Sum"

  dimensions = {
    LoadBalancer = module.alb.alb_dns_name
  }

  alarm_actions = var.alarm_notification_arns
}

############################################################
# ALB High Latency Alarm
############################################################
resource "aws_cloudwatch_metric_alarm" "alb_latency" {
  alarm_name          = "${var.environment}-alb-latency-high"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "TargetResponseTime"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 2
  evaluation_periods  = 1
  period              = 60
  statistic           = "Average"

  dimensions = {
    LoadBalancer = module.ecs-cluster.cluster_name
  }

  alarm_actions = var.alarm_notification_arns
}

############################################################
# RDS CPU High Alarm
############################################################
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.environment}-rds-cpu-high"
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 2
  period              = 60
  statistic           = "Average"

  dimensions = {
    DBClusterIdentifier = var.rds_cluster_id
  }

  alarm_actions = var.alarm_notification_arns
}

############################################################
# RDS Free Storage Alarm
############################################################
resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  alarm_name          = "${var.environment}-rds-low-storage"
  namespace           = "AWS/RDS"
  metric_name         = "FreeStorageSpace"
  comparison_operator = "LessThanThreshold"
  threshold           = 20000000000 # ~20GB
  evaluation_periods  = 1
  period              = 300
  statistic           = "Average"

  dimensions = {
    DBClusterIdentifier = var.rds_cluster_id
  }

  alarm_actions = var.alarm_notification_arns
}

############################################################
# CloudWatch Dashboard
############################################################
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        properties = {
          title  = "ECS CPU Utilization",
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", module.ecs-cluster.cluster_name, "ServiceName", var.service_name]
          ],
          period = 60,
          stat   = "Average"
        }
      }
    ]
  })
}
