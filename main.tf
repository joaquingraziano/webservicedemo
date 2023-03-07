provider "aws" {
  alias                         = "localstack"
  region                        = "us-east-1"
  access_key                    = "test"
  secret_key                    = "test"
  skip_credentials_validation  = true
  skip_metadata_api_check      = true
  skip_requesting_account_id   = true
  endpoints {
    ec2             = "http://localhost:4566/"
    s3              = "http://localhost:4566/"
    sts             = "http://localhost:4566/"
    iam             = "http://localhost:4566/"
    cloudformation  = "http://localhost:4566/"
    cloudwatch      = "http://localhost:4566/"
    eks             = "http://localhost:4566/"
    apigateway      = "http://localhost:4566/"
    lambda          = "http://localhost:4566/"
    ssm             = "http://localhost:4566/"
  }
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
