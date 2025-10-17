provider "aws" {
  region = var.aws_region
}

# Use data sources to reference existing subnets (remove VPC data source as it's not needed)
data "aws_subnet" "subnet_a" {
  id = var.subnet_id_a
}

data "aws_subnet" "subnet_b" {
  id = var.subnet_id_b
}

# IAM roles
resource "aws_iam_role" "eks_service_role" {
  name = "eksServiceRole-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy_attach" {
  role       = aws_iam_role.eks_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy_attach" {
  role       = aws_iam_role.eks_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_service_role.arn

  vpc_config {
    subnet_ids              = [var.subnet_id_a, var.subnet_id_b]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_policy_attach,
    aws_iam_role_policy_attachment.eks_service_policy_attach
  ]
}

resource "aws_iam_role" "eks_node_role" {
  name = "eksNodeRole-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "my-node-group-${var.cluster_name}"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = [var.subnet_id_a, var.subnet_id_b]

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  instance_types = [var.node_instance_type]
  capacity_type  = "ON_DEMAND"

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ec2_container_policy
  ]
}
