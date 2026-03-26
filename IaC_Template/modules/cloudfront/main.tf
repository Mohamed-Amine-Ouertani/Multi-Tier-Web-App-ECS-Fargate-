#############################################
# CloudFront Origin Access Control (OAC)
#############################################
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.environment}-oac"
  description                       = "OAC for CloudFront -> S3 secure access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#############################################
# CloudFront Cache Policy
#############################################
resource "aws_cloudfront_cache_policy" "default" {
  name = "${var.environment}-cache-policy"

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

#############################################
# CloudFront Distribution
#############################################
resource "aws_cloudfront_distribution" "cdn" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "${var.environment} CloudFront distribution"


  origin {
    domain_name = var.s3_domain_name
    origin_id   = "s3-frontend-origin"

    s3_origin_config {
      origin_access_identity = null
    }

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }


  default_cache_behavior {
    target_origin_id       = "s3-frontend-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    cache_policy_id  = aws_cloudfront_cache_policy.default.id

  }


  viewer_certificate {

  }


  restrictions {
    geo_restriction {
      restriction_type = var.enable_geo_restriction ? "whitelist" : "none"
      locations        = var.geo_whitelist
    }
  }

  tags = {
    Name        = "${var.environment}-cloudfront"
    Environment = var.environment
  }
}


