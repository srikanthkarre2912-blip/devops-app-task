provider "aws" {
  region = var.aws_region
}

# IAM roles for EKS cluster
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

# Updated policy attachments - AmazonEKSServicePolicy is deprecated
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Add VPC resource controller policy (CRITICAL)
resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  role       = aws_iam_role.eks_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  version  = "1.30"  # Use a stable version
  role_arn = aws_iam_role.eks_service_role.arn

  vpc_config {
    subnet_ids              = [var.subnet_id_a, var.subnet_id_b]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]  # Explicitly set this
  }

  # Enable cluster logging for debugging
  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  # Add timeouts to prevent hanging
  timeouts {
    create = "60m"
    delete = "30m"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller,
  ]
}

# IAM role for EKS nodes
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

# EKS Node Group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "main-node-group-${var.cluster_name}"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [var.subnet_id_a, var.subnet_id_b]

  # Instance configuration
  instance_types = [var.node_instance_type]
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  # Update configuration
  update_config {
    max_unavailable = 1
  }

  # Disk size
  disk_size = 20

  # Timeouts
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  # Ensure node group only creates after cluster is active
  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ec2_container_policy,
  ]
}
