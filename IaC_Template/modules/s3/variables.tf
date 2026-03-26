
variable "environment" {
  description = "Environment (e.g., Dev, Prod)"
  type        = string
  default = "Dev"
}

variable "expiration_days" {
  description = "Number of days before objects expire"
  type        = number
  default     = 365
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution using this bucket"
  type        = string
}
