variable "vpc_id" {
  description = "The id of the vpc on which the alb resides"
  type = string
}

variable "alb_security_groups_id" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs where the ALB will be deployed"
  type        = list(string)
}

