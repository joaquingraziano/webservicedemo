provider "aws" {

  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  region                      = "us-east-1"

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}

//se creara

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

resource "aws_subnet" "eks_subnet_public" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "eks-subnet-public"
  }
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-igw"
  }
}

resource "aws_route_table" "eks_private_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = "eks-private-route-table"
  }
}

resource "aws_security_group" "eks_worker_sg" {
  name_prefix = "eks-worker-"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-worker-sg"
  }
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = "arn:aws:iam::123456789012:role/eks-service-role"
##replace the 123456789012 with your account number
  vpc_config {
    subnet_ids = [
      aws_subnet.eks_subnet_private.id,
      aws_subnet.eks_subnet_public.id
    ]

    security_group_ids = [aws_security_group.eks_worker_sg.id]
  }

  depends_on = [
    aws_vpc.eks_vpc,
    aws_subnet.eks_subnet_private,
    aws_subnet.eks_subnet_public,
    aws_internet_gateway.eks_igw,
    aws_route_table.eks_private_route_table,
    aws_security_group.eks_worker_sg
  ]
}