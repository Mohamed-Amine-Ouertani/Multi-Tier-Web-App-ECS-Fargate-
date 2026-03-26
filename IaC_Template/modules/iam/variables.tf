variable "environment" {
  description = "Deployment environment (e.g., Dev, Prod)"
  type        = string
}

variable "enable_container_insights" {
  description = "Enable ECS CloudWatch Container Insights"
  type        = bool
  default     = true
}
