variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster-1"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Use existing VPC and subnets instead of creating new ones
variable "existing_vpc_id" {
  description = "Existing VPC ID"
  type        = string
  default     = "vpc-0ced9c4d6627b9a7f"
}

variable "existing_subnet_ids" {
  description = "Existing subnet IDs"
  type        = list(string)
  default     = [
    "subnet-017629d73c324a704",  # us-east-1a
    "subnet-0f22690460a8f9ab6",  # us-east-1b
    "subnet-0d30f5fbc20b45907",  # us-east-1c
    "subnet-0d102dd465929d6c9",  # us-east-1d
    "subnet-03adeef6449a6a230",  # us-east-1e
    "subnet-09c47b5b6ef1944bd"   # us-east-1f
  ]
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
