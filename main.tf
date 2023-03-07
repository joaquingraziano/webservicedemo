terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
    region = "us-east-1"
    access_key = "my-access-key"
    secret_key = "my-secret-key"
}

resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_subnet" "eks_subnet_private" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "eks-subnet-private"
  }
}
