variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "allowed_sg_ids" {
  description = "Security groups allowed to access Aurora (ECS app SG)"
  type        = list(string)
}

variable "bastion_sg_ids" {
  description = "Optional bastion SGs allowed to access Aurora"
  type        = list(string)
  default     = []
}

variable "engine_version" {
  type    = string
  default = "15.3"
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "backup_retention" {
  type    = number
  default = 7
}

variable "instance_class" {
  type    = string
  default = "db.serverless"
}

variable "instance_count" {
  type    = number
  default = 2
}
