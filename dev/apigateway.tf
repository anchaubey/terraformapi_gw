resource "aws_api_gateway_rest_api" "book-service" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "book-service"
      version = "1.0"
    }
    paths = {
      "/book-service" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  name = "book-service"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "book-service" {
  rest_api_id = aws_api_gateway_rest_api.book-service.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.book-service.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "book-service" {
  deployment_id = aws_api_gateway_deployment.book-service.id
  rest_api_id   = aws_api_gateway_rest_api.book-service.id
  stage_name    = "book-service"
}
