variable "environment" {
  type        = string
  description = "Deployment environment (e.g., Dev, Prod)"
}

variable "s3_domain_name" {
  type        = string
  description = "S3 bucket domain name for CloudFront origin"
}

variable "enable_geo_restriction" {
  type        = bool
  default     = false
  description = "Enable Geo-based restrictions"
}

variable "geo_whitelist" {
  type        = list(string)
  default     = []
  description = "Countries allowed when geo restriction enabled"
}
