output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "web_sg_id" {
  description = "ID of the Web Tier security group"
  value       = aws_security_group.web_sg.id
}

output "app_sg_id" {
  description = "ID of the App Tier security group"
  value       = aws_security_group.app_sg.id
}

output "db_sg_id" {
  description = "ID of the Database Tier security group"
  value       = aws_security_group.db_sg.id
}