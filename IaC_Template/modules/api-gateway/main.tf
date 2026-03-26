resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "${var.environment}-api"
  description = "Public API Gateway for multi-tier architecture"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = var.method
  authorization = "NONE"
}

resource "aws_api_gateway_vpc_link" "api_vpc_link" {
  name        = "${var.environment}-vpc-link"
  target_arns = [var.alb_arn]
}

resource "aws_api_gateway_integration" "alb_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = var.alb_dns_name

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.api_vpc_link.id
}


resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.alb_integration]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}
resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.environment

}