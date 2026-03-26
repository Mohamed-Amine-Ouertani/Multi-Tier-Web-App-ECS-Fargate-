variable "environment" {
  type = string
}

variable "service_name" {
  type = string
}

variable "rds_cluster_id" {
  type = string
}

variable "alarm_notification_arns" {
  type    = list(string)
  default = []
}
