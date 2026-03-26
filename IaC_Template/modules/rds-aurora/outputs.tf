output "aurora_cluster_id" {
  value = aws_rds_cluster.aurora.id
}

output "aurora_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}

output "aurora_reader_endpoint" {
  value = aws_rds_cluster.aurora.reader_endpoint
}

output "aurora_secret_arn" {
  value = aws_secretsmanager_secret.aurora_secret.arn
}

output "aurora_security_group_id" {
  value = aws_security_group.aurora_sg.id
}

