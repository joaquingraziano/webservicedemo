

//se creara



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