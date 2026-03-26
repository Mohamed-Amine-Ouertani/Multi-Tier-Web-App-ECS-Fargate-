variable "environment" {
  description = "Deployment environment (e.g., Dev, Prod)"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service / container"
  type        = string
}

variable "region" {
  description = "AWS region for log configuration"
  type        = string
}

variable "cpu" {
  description = "Fargate CPU units"
  type        = number
}

variable "memory" {
  description = "Fargate memory in MB"
  type        = number
}

variable "container_port" {
  description = "Port exposed by the application"
  type        = number
}

variable "ecr_repository_url" {
  description = "ECR repository URL (from ECR module output)"
  type        = string
}

variable "image_tag" {
  description = "Tag of the container image (e.g., latest)"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "Days to retain CloudWatch logs"
  type        = number
  default     = 30
}
