output "s3_bucket_id" {
  description = "ID of the frontend S3 bucket"
  value       = aws_s3_bucket.frontend.id
}

output "s3_bucket_arn" {
  description = "ARN of the frontend S3 bucket"
  value       = aws_s3_bucket.frontend.arn
}

output "s3_bucket_domain_name" {
  description = "Bucket domain name (used by CloudFront)"
  value       = aws_s3_bucket.frontend.bucket_regional_domain_name
}

output "logs_bucket_id" {
  value       = aws_s3_bucket.logs[*].id
  description = "ID of the logs bucket (if enabled)"
}
