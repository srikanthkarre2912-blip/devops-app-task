# DevOps Engineer Take-Home Task: Automated Kubernetes Deployment

## Overview

This project demonstrates a complete automated CI/CD pipeline for deploying a Python Flask web application to an Amazon EKS (Elastic Kubernetes Service) cluster. The solution implements Infrastructure as Code (IaC) using Terraform, containerization with Docker, and automated deployments via GitHub Actions.

## Solution Architecture

```mermaid
graph TD
    A[GitHub Repository] --> B[(Push to main branch)]
    B --> C[GitHub Actions CI/CD Pipeline]
    C --> D[Run Application Tests]
    D --> E[Terraform - Provision EKS Cluster]
    E --> F[Build & Push Docker Image to ECR]
    F --> G[Deploy to Kubernetes]
    G --> H[Live Application (LoadBalancer Service)]

---

## Core Requirements Implementation

### ✅ 1. Infrastructure as Code (IaC)
- **Technology**: Terraform  
- **Cloud Provider**: AWS EKS  
- **Resources Provisioned**:
  - EKS Cluster with managed node group
  - IAM roles for EKS service and worker nodes
  - Utilizes existing VPC and subnets for networking
  - S3 backend for Terraform state management

### ✅ 2. Containerization
- **Application**: Python Flask web application  
- **Dockerfile**: Multi-stage build for optimized image size  
- **Registry**: AWS ECR (Elastic Container Registry)  
- **Optimization**: Python slim base image, minimal dependencies  

### ✅ 3. Kubernetes Manifests
- **Deployment**: 2 replicas with health checks  
- **Service**: LoadBalancer type for public access  
- **Configuration**: Environment variables, resource limits  
- **Location**: `infra/kubernetes/` directory  

### ✅ 4. CI/CD Pipeline
- **Tool**: GitHub Actions  
- **Triggers**: Push to main branch, pull requests  
- **Stages**:
  1. Test application  
  2. Terraform plan & apply  
  3. Build and push Docker image  
  4. Deploy to Kubernetes  
  5. Verify deployment  

### ✅ 5. Documentation
- This comprehensive README  
- Clear setup instructions  
- Design rationale explanations  

---

## Quick Start

### Prerequisites
- AWS Account with appropriate permissions  
- GitHub Repository  
- AWS Credentials (Access Key ID and Secret Access Key)  

### Setup Instructions

#### 1. Clone the Repository
```bash
git clone <repository-url>
cd devops-app-task

2. Configure AWS Credentials in GitHub

Go to Repository Settings → Secrets and variables → Actions

Add the following secrets:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

3. Trigger the Pipeline

Push to the main branch or create a pull request.
The pipeline will automatically:

Run tests

Provision EKS cluster

Build and push Docker image

Deploy application

4. Access the Application

After deployment completes, check the pipeline logs for the LoadBalancer URL.
Access your application at:

http://<loadbalancer-external-ip>

Monitoring and Logs
Check Application Status
kubectl get pods,svc -n devops-app

View Application Logs
kubectl logs -l app=devops-app -n devops-app

Check Cluster Status
kubectl get nodes
kubectl cluster-info

Troubleshooting
Common Issues
Pipeline fails at Terraform apply

Check AWS credentials in GitHub secrets

Verify IAM permissions for EKS, EC2, and IAM

Image pull errors

Ensure ECR repository exists and has proper permissions

Verify image tag in deployment.yaml

Application not accessible

Check LoadBalancer status:

kubectl get svc -n devops-app


Verify security groups allow inbound traffic on port 80

Pods not starting

Check pod logs:

kubectl logs <pod-name> -n devops-app


Verify cluster resource limits

Debug Commands
# Check all resources in namespace
kubectl get all -n devops-app

# Describe specific resource
kubectl describe deployment/devops-app -n devops-app

# Check events
kubectl get events -n devops-app --sort-by=.metadata.creationTimestamp

Cleanup

To destroy all created resources:

cd infra/terraform
terraform destroy -auto-approve

Future Enhancements

Implement Helm charts for Kubernetes manifests

Add monitoring with Prometheus and Grafana

Integrate security scanning in CI/CD pipeline

Implement blue-green deployments

Add autoscaling configurations

Set up centralized logging
