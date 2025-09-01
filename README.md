# AWS EKS Cluster Monitoring Project

## Project Overview
This project sets up an AWS EKS cluster using Terraform and implements a monitoring system with Prometheus and Grafana. **Optimized for cost efficiency** with no LoadBalancer or NAT Gateway charges.

## Technology Stack
- **IaC**: Terraform
- **Cloud**: AWS (VPC, EKS, IAM)
- **Container Orchestration**: Kubernetes
- **Package Manager**: Helm
- **Monitoring**: Prometheus, Grafana (NodePort access)
- **Auto Scaling**: Horizontal Pod Autoscaler (HPA)
- **Cost Optimization**: No NAT Gateway, No LoadBalancer

## Prerequisites

### 1. Tool Installation
**Note**: This project is optimized for cost efficiency and can be run in AWS CloudShell without additional tool installation.
```bash
# AWS CLI
brew install awscli

# Terraform
brew install terraform

# kubectl
brew install kubectl

# Helm
brew install helm
```

### 2. AWS Account Setup
- Create AWS account (free tier)
- Create IAM user and set permissions
- Configure AWS CLI

### 3. AWS Resource Limitations
- EKS cluster: Limited support in free tier
- EC2 instances: t3.micro (750 hours free per month)
- EBS volumes: 30GB free
- LoadBalancer: Avoided (using NodePort instead)
- NAT Gateway: Disabled to minimize costs

## Project Structure
```
├── terraform/           # Terraform code
│   ├── main.tf         # Main configuration (cost-optimized)
│   ├── variables.tf    # Variable definitions
│   ├── outputs.tf      # Output values
│   └── providers.tf    # Provider configuration
├── kubernetes/         # Kubernetes manifests
│   ├── deployments/    # Deployments (optimized resources)
│   ├── services/       # Services
│   └── hpa/           # HPA configuration
├── helm/              # Helm charts
│   └── monitoring/    # Monitoring stack (NodePort access)
└── docs/              # Documentation
    ├── setup.md       # Setup guide
    └── screenshots/   # Screenshots
```

## Usage

### Quick Start (AWS CloudShell)
```bash
# Clone project
git clone https://github.com/your-username/junbeom-sre-terraform-project.git
cd junbeom-sre-terraform-project

# Deploy infrastructure
cd terraform
terraform init
terraform apply

# Deploy applications
cd ..
kubectl apply -f kubernetes/deployments/test-app.yaml
kubectl apply -f kubernetes/services/test-app-service.yaml
kubectl apply -f kubernetes/hpa/test-app-hpa.yaml

# Install monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack --values helm/monitoring/values.yaml --namespace monitoring --create-namespace

# Clean up (IMPORTANT!)
terraform destroy
```

### Manual Steps
1. Initialize and apply Terraform in `terraform/` directory
2. Apply Kubernetes manifests
3. Install monitoring stack via Helm (NodePort access)
4. Configure and test HPA
5. Access Grafana via NodePort (no LoadBalancer charges)

## Cost Considerations
- Use t3.micro instances to minimize costs
- Operate within free tier limits
- Delete unnecessary resources immediately
- **No LoadBalancer charges** (using NodePort)
- **No NAT Gateway charges** (disabled)
- **Optimized resource limits** (CPU: 200m-400m)
- **Minimal storage usage** (20GB per node)

### Estimated Costs (1 day usage)
- **EKS Cluster**: $2-5
- **EC2 t3.micro**: Free Tier (750 hours/month)
- **LoadBalancer**: $0 (NodePort used)
- **NAT Gateway**: $0 (disabled)
- **Total**: $2-5 (within $100 credit limit)