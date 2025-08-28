# AWS EKS Cluster Monitoring Project

## Project Overview
This project sets up an AWS EKS cluster using Terraform and implements a monitoring system with Prometheus and Grafana.

## Technology Stack
- **IaC**: Terraform
- **Cloud**: AWS (VPC, EKS, IAM)
- **Container Orchestration**: Kubernetes
- **Package Manager**: Helm
- **Monitoring**: Prometheus, Grafana
- **Auto Scaling**: Horizontal Pod Autoscaler (HPA)

## Prerequisites

### 1. Tool Installation
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

## Project Structure
```
├── terraform/           # Terraform code
│   ├── main.tf         # Main configuration
│   ├── variables.tf    # Variable definitions
│   ├── outputs.tf      # Output values
│   └── providers.tf    # Provider configuration
├── kubernetes/         # Kubernetes manifests
│   ├── deployments/    # Deployments
│   ├── services/       # Services
│   └── hpa/           # HPA configuration
├── helm/              # Helm charts
│   └── monitoring/    # Monitoring stack
└── docs/              # Documentation
    ├── setup.md       # Setup guide
    └── screenshots/   # Screenshots
```

## Usage
1. Initialize and apply Terraform in `terraform/` directory
2. Apply Kubernetes manifests
3. Install monitoring stack via Helm
4. Configure and test HPA

## Cost Considerations
- Use t3.micro instances to minimize costs
- Operate within free tier limits
- Delete unnecessary resources immediately