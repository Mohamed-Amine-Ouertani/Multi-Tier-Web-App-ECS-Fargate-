variable "address" {
  type = string
  description = "vault api adress"
}

variable "backend" {
  type = string
  description = "cloud provider"
}

variable "role" {
  type = string
  default = "role provided by vault to terraform to access the backend(cloud Provider)"
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "environment" {
  type = string
  description = "The environment (e.g., Dev, Prod)"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "S3-expiration_days" {
  description = "Number of days before objects expire"
  type        = number
}

variable "aurora_db_name" {
  type = string
}

variable "aurora_db_username" {
  type = string
}

variable "aurora_db_password" {
  type      = string
  sensitive = true
}