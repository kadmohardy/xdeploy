terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = ">=2.1.0"
  }
}

provider "aws" {
  region = var.aws_region
}
