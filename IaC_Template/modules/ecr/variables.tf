variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default = "ECR repo"
}

variable "environment" {
  description = "Deployment environment (e.g., Dev, Prod)"
  type        = string
}

variable "enable_image_scan" {
  description = "Enable vulnerability scanning on push"
  type        = bool
  default     = true
}

variable "untagged_image_expiration_days" {
  description = "Delete untagged images older than X days"
  type        = number
  default     = 360
}

variable "max_tagged_images" {
  description = "Maximum number of tagged images to keep"
  type        = number
  default     = 360
}

variable "tag_prefix_list" {
  description = "List of tag prefixes to apply retention rules to"
  type        = list(string)
  default     = ["v"]
}
