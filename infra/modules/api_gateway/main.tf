resource "aws_apigatewayv2_api" "this" {
  name          = "${var.project_name}-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_vpc_link" "this" {
  name               = "${var.project_name}-vpc-link"
  security_group_ids = [var.vpc_link_sg_id]
  subnet_ids         = var.private_subnets
}

resource "aws_apigatewayv2_integration" "this" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "HTTP_PROXY"
  integration_uri  = var.load_balancer_listener_arn

  connection_type = "VPC_LINK"
  connection_id   = aws_apigatewayv2_vpc_link.this.id
}

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "prod"
  auto_deploy = true
}