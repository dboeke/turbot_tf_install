provider "aws" {
  region = "us-east-2"
  profile = "default"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}