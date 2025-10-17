provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  # Use the existing `kubernetes` provider configuration (above) or
  # rely on KUBECONFIG/environment credentials. Some helm provider
  # versions do not accept a nested `kubernetes {}` block in the
  # provider configuration — keep this block empty so helm will
  # use the kubeconfig or the configured kubernetes provider.
}
