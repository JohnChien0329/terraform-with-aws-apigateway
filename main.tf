# Required providers configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }

  required_version = ">= 1.0.11"
}

# AWS provider configuration
provider "aws" {
  #profile = "default"
  #region  = "us-east-1"
  region                      = "us-east-1"
  access_key                  = ""
  secret_key                  = "/nN7FATfGd/f"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

}





resource "aws_api_gateway_rest_api" "example" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "test-terra"
      version = "1.0"
    }
    paths = {
      "/RDS/GetUsers" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "${var.apigateway_url}/RDS/GetUsers"
          }
        }
      },

      "/RDS/GetUserById" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "${var.apigateway_url}/RDS/GetUserById"
          }
        }
      },

       "/RDS/InsertUser" = {
        post = {
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "${var.apigateway_url}/RDS/InsertUser"
          }
        }
      },
       "/RDS/UpdatetUser" = {
        put = {
          x-amazon-apigateway-integration = {
            httpMethod           = "PUT"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "${var.apigateway_url}/RDS/UpdatetUser"
          }
        }
      },
       "/RDS/DeleteUser" = {
        delete = {
          x-amazon-apigateway-integration = {
            httpMethod           = "DELETE"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "${var.apigateway_url}/RDS/DeleteUser"
          }
        }
      },
       "/Redis" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "${var.apigateway_url}/Redis"
          }
        }
      },
    
    
    }

  })

  name = "terra-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.example.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = "example"
}



