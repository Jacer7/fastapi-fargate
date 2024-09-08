locals {
  common_tags = {
    Environment = "dev"
    Application = "fastapi_service"
  }
}

variable "aws_region" {
  default = "eu-west-3"
}