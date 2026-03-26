variable "environment" {
  description = "Environment name (Dev, Prod)"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "cluster_name" {
  description = "ECS Cluster Name"
  type        = string
}

variable "task_definition_arn" {
  description = "ARN of the ECS Task Definition"
  type        = string
}

variable "private_subnet_ids" {
  description = "Subnets for ECS tasks (private)"
  type        = list(string)
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
}

variable "desired_count" {
  description = "Initial desired task count"
  type        = number
  default     = 2
}

variable "path_patterns" {
  description = "ALB listener rule paths"
  type        = list(string)
  default     = ["/*"]
}

variable "min_capacity" {
  description = "Min number of tasks"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Max number of tasks"
  type        = number
  default     = 5
}

variable "health_check_path" {
  description = "ALB health check path"
  type        = string
  default     = "/"
}
