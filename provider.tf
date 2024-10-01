terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
        version = "5.69.0"  # Update this version if needed
    }
  }
}

provider "aws" {
  region     = "us-west-2"  # Change to your desired AWS region
  #access_key = var.aws_access_key   # Use variables for sensitive data
  #secret_key = var.aws_secret_key
}
