output "api_invoke_url" {
  description = "Public invoke URL of the API Gateway"
  value       = aws_api_gateway_deployment.deployment.invoke_url
}

output "rest_api_id" {
  description = "ID of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.rest_api.id
}

output "vpc_link_id" {
  description = "VPC Link ID"
  value       = aws_api_gateway_vpc_link.api_vpc_link.id
}
