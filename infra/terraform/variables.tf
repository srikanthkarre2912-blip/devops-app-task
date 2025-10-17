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

# Use existing subnets
variable "subnet_id_a" {
  description = "Existing subnet ID for zone A"
  type        = string
  default     = "subnet-017629d73c324a704"  # us-east-1a
}

variable "subnet_id_b" {
  description = "Existing subnet ID for zone B"
  type        = string
  default     = "subnet-0f22690460a8f9ab6"  # us-east-1b
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
