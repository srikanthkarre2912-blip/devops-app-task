variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"  # Changed to match your main.tf
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "172.31.0.0/20"
}

# Remove cluster_version since your main.tf doesn't use it
# variable "cluster_version" {
#   description = "Kubernetes version for EKS cluster"
#   type        = string
#   default     = "1.28"
# }

# Add these new variables that match your main.tf subnet configuration
variable "subnet_cidr_a" {
  description = "CIDR block for subnet A"
  type        = string
  default     = "172.31.21.0/24"
}

variable "subnet_cidr_b" {
  description = "CIDR block for subnet B"
  type        = string
  default     = "172.31.21.0/24"
}

variable "availability_zone_a" {
  description = "Availability zone for subnet A"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_b" {
  description = "Availability zone for subnet B"
  type        = string
  default     = "us-east-1b"
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in node group"
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in node group"
  type        = number
  default     = 3
}

variable "node_instance_type" {
  description = "Instance type for EKS nodes"
  type        = string
  default     = "t3.medium"
}


