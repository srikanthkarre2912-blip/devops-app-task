# 🚀 DevOps Engineer Take-Home Task: Automated Kubernetes Deployment

## 🧭 Overview
This project automates the deployment of a **Python Flask web app** to **Amazon EKS** using:
- **Terraform** (Infrastructure as Code)
- **Docker** (containerization)
- **GitHub Actions** (CI/CD automation)

---

## 🧱 Architecture

```mermaid
graph TD
    A[GitHub Repository] --> B[GitHub Actions Pipeline]
    B --> C[Terraform - Create EKS Cluster]
    C --> D[Build & Push Docker Image to ECR]
    D --> E[Deploy to EKS using kubectl]
    E --> F[Access App via LoadBalancer URL]

## ⚙️ Core Requirements Implementation

### ✅ 1. Infrastructure as Code (IaC)
**Tool:** Terraform  
**Cloud Provider:** AWS  

**Resources Provisioned:**
- Amazon EKS cluster with managed node group  
- IAM roles for EKS service and worker nodes  
- VPC and subnets for networking  
- Remote S3 backend for Terraform state management  

---

### ✅ 2. Containerization
**Application:** Python Flask web application  
**Dockerfile:** Multi-stage build for optimized image size  
**Registry:** AWS ECR (Elastic Container Registry)  
**Optimization:** Uses a lightweight Python slim base image for efficiency  

---

### ✅ 3. Kubernetes Manifests
**Deployment:** 2 replicas with readiness and liveness probes  
**Service Type:** LoadBalancer for public access  
**Namespace:** `devops-app`  
**Configuration:** Resource limits, environment variables, and labels  
**Location:** `infra/kubernetes/` directory  

---

### ✅ 4. CI/CD Pipeline
**Tool:** GitHub Actions  
**Trigger:** On push or pull request to the `main` branch  

**Pipeline Stages:**
1. Run unit tests  
2. Terraform plan & apply  
3. Build Docker image  
4. Push image to ECR  
5. Deploy to EKS using `kubectl`  
6. Verify deployment  

---

### ✅ 5. Documentation
- 📘 Comprehensive **README** (this file)  
- 🧩 Step-by-step deployment guide  
- 🧠 Troubleshooting instructions and future enhancements  

🚀 Quick Start
🧩 Prerequisites
Ensure you have the following:

AWS Account with appropriate IAM permissions

GitHub Repository

AWS CLI and kubectl installed

Terraform v1.5.0 or higher

Docker installed

⚙️ Setup Instructions
1. Clone the Repository
bash
Copy code
git clone <repository-url>
cd devops-app-task
2. Configure AWS Credentials in GitHub
Go to:
Repository Settings → Secrets and Variables → Actions

Add these secrets:

nginx
Copy code
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
(Optionally add ECR_REPOSITORY or CLUSTER_NAME if used in your workflow.)

3. Trigger the Pipeline
Push code to the main branch or create a Pull Request.
GitHub Actions will automatically:

Run tests

Provision infrastructure (Terraform)

Build and push Docker image

Deploy the app to EKS

Output LoadBalancer URL

4. Access the Application
After successful deployment, check the GitHub Actions logs for the LoadBalancer URL.
Example output:

java
Copy code
Application URL (LoadBalancer):
http://a5a4e153303a24038a8dd72fdef8fdbf-1372945717.us-east-1.elb.amazonaws.com
Open the above URL in your browser 🌎

🧠 Monitoring & Logs
Check Application Status
bash
Copy code
kubectl get pods,svc -n devops-app
View Application Logs
bash
Copy code
kubectl logs -l app=devops-app -n devops-app
Check Cluster Information
bash
Copy code
kubectl get nodes
kubectl cluster-info
🧰 Troubleshooting
Issue	Cause	Fix
Terraform apply fails	Invalid AWS credentials or IAM permissions	Verify AWS secrets and permissions
ImagePullBackOff	ECR repo missing or unauthorized	Confirm ECR repo exists and IAM role allows access
App not accessible	LoadBalancer not ready or SG blocked	Wait a few minutes or allow port 80 in security group
Pods in CrashLoopBackOff	App config error	Check kubectl logs for details

🔍 Debug Commands
bash
Copy code
# Check all resources in namespace
kubectl get all -n devops-app

# Describe deployment
kubectl describe deployment/devops-app -n devops-app

# Check recent events
kubectl get events -n devops-app --sort-by=.metadata.creationTimestamp
🧹 Cleanup
To destroy all AWS resources created by Terraform:

bash
Copy code
cd infra/terraform
terraform destroy -auto-approve
🧭 Future Enhancements
🧩 Implement Helm charts for Kubernetes manifests

📊 Add monitoring with Prometheus & Grafana

🔒 Integrate security scanning (Trivy, Checkov)

🔁 Implement blue-green or canary deployments

⚡ Add Horizontal Pod Autoscaling (HPA)

🪵 Centralized logging (CloudWatch or ELK Stack)

✅ End Result
You get a production-ready, automated CI/CD pipeline deploying a containerized Flask application to AWS EKS — with public access through a LoadBalancer and fully managed infrastructure via Terraform.

🧑‍💻 Author
DevOps Engineer Candidate
🗓️ Built using: Terraform · AWS · EKS · Docker · GitHub Actions · Kubernetes

yaml
Copy code

---

### 💡 Notes:
- The original error (`Unable to render rich display`) was caused by missing closing triple backticks ``` after the Mermaid diagram.  
- The above version includes proper Markdown syntax and formatting to render perfectly on GitHub.  
- The diagram now visualizes your CI/CD flow cleanly.

---

Would you like me to **add a rendered architecture diagram (PNG)** version of the Mermaid flow as a fallback, in case GitHub’s Mermaid rendering is disabled?






