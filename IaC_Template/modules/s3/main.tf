resource "aws_s3_bucket" "frontend" {
  bucket = "S3 bucket"

  tags = {
    Name        = "S3 bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_encryption" "encryption" {
  bucket = aws_s3_bucket.frontend.id

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    id     = "expire-old-files"
    status = "Enabled"

    expiration {
      days = var.expiration_days
    }
  }
}

# -------------------------------------------------------
# Logs Bucket CloudFront
# -------------------------------------------------------
resource "aws_s3_bucket" "logs" {
  count  = true ? 1 : 0
  bucket = "${"S3 bucket"}-logs"

  tags = {
    Name        = "${"S3 bucket"}-logs"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "logs_acl" {
  count  = true ? 1 : 0
  bucket = aws_s3_bucket.logs[0].id
  acl    = "log-delivery-write"
}

# -------------------------------------------------------
# Bucket Policy for CloudFront Origin Access Control (OAC)
# -------------------------------------------------------
resource "aws_s3_bucket_policy" "oac_policy" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontAccessOAC",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action   = ["s3:GetObject"],
        Resource = "${aws_s3_bucket.frontend.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" : var.cloudfront_distribution_arn
          }
        }
      }
    ]
  })
}
