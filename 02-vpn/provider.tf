terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.15.0"
    }
  }

  backend "s3" {
    bucket = "mybucket-roboshop"
    key = "vpn-key"
    region = "us-east-1"
    dynamodb_table = "roboshop-locking"
    
  }
 
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}