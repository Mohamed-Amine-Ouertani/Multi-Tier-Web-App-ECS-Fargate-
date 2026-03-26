variable "environment" {
  description = "Deployment environment (e.g., Dev, Prod)"
  type        = string
}

variable "method" {
  description = "HTTP method to expose (GET, POST, etc.)"
  type        = string
  default     = "GET"
}

variable "alb_arn" {
  description = "ARN of the Application Load Balancer for VPC Link"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB for integration"
  type        = string
}
