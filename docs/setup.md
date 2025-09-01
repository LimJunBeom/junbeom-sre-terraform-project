# AWS EKS Monitoring Project Setup Guide

## 1. Prerequisites

### 1.1 Verify Tool Installation
```bash
# Check AWS CLI installation
aws --version

# Check Terraform installation
terraform --version

# Check kubectl installation
kubectl version --client

# Check Helm installation
helm version
```

### 1.2 AWS Account Configuration
```bash
# Configure AWS CLI
aws configure
# AWS Access Key ID: [Enter]
# AWS Secret Access Key: [Enter]
# Default region name: us-east-1
# Default output format: json
```

## 2. Deploy EKS Cluster

### 2.1 Initialize Terraform
```bash
cd terraform
terraform init
```

### 2.2 Review Deployment Plan
```bash
terraform plan
```

### 2.3 Deploy Infrastructure
```bash
terraform apply
# Enter 'yes' when prompted
```

### 2.4 Configure kubectl
```bash
# Execute command provided in Terraform output
aws eks update-kubeconfig --region us-east-1 --name monitoring-cluster

# Verify cluster connection
kubectl get nodes
```

## 3. Deploy Kubernetes Workloads

### 3.1 Deploy Test Application
```bash
# Deploy deployment
kubectl apply -f ../kubernetes/deployments/test-app.yaml

# Deploy service
kubectl apply -f ../kubernetes/services/test-app-service.yaml

# Deploy HPA
kubectl apply -f ../kubernetes/hpa/test-app-hpa.yaml
```

### 3.2 Verify Deployment Status
```bash
# Check pod status
kubectl get pods

# Check services
kubectl get services

# Check HPA status
kubectl get hpa
```

## 4. Install Monitoring Stack

### 4.1 Add Helm Repository
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### 4.2 Install Prometheus & Grafana
```bash
helm install monitoring prometheus-community/kube-prometheus-stack \
  --values ../helm/monitoring/values.yaml \
  --namespace monitoring \
  --create-namespace
```

### 4.3 Verify Installation Status
```bash
# Check namespaces
kubectl get namespaces

# Check monitoring pods
kubectl get pods -n monitoring

# Check services
kubectl get services -n monitoring
```

## 5. Access Grafana

### 5.1 Get NodePort
```bash
kubectl get service -n monitoring grafana
```

### 5.2 Login to Grafana
- URL: http://[Node-IP]:[NodePort]
- Username: admin
- Password: admin123

**Note**: Since we're using NodePort instead of LoadBalancer to avoid charges, you'll need to access via the node's IP address and the assigned NodePort.

## 6. Test HPA

### 6.1 Generate CPU Load
```bash
# Generate load on test application
kubectl run load-generator --image=busybox --rm -it --restart=Never -- \
  /bin/sh -c "while true; do wget -q -O- http://test-app-service; done"
```

### 6.2 Monitor Scaling
```bash
# Real-time HPA status monitoring
watch kubectl get hpa

# Check pod count changes
watch kubectl get pods
```

## 7. Monitoring Dashboards

### 7.1 Default Dashboards
- **Kubernetes Cluster**: Overall cluster status
- **Kubernetes Pods**: Pod-specific metrics
- **Node Exporter**: Node system metrics

### 7.2 Custom Dashboards
- HPA scaling events
- Application performance metrics
- Resource usage trends

## 8. Cost Optimization

### 8.1 Free Tier Limitations
- EC2 t3.micro: 750 hours per month
- EBS: 30GB
- LoadBalancer: Hourly billing (avoided by using NodePort)

### 8.2 Cost Saving Tips
- Delete unnecessary resources immediately
- Using NodePort instead of LoadBalancer to avoid charges
- Minimize storage size
- Optimize auto-scaling settings

## 9. Cleanup

### 9.1 Remove Resources
```bash
# Uninstall Helm chart
helm uninstall monitoring -n monitoring

# Remove Kubernetes resources
kubectl delete -f ../kubernetes/hpa/test-app-hpa.yaml
kubectl delete -f ../kubernetes/services/test-app-service.yaml
kubectl delete -f ../kubernetes/deployments/test-app.yaml

# Remove Terraform resources
cd terraform
terraform destroy
```

### 9.2 Backup Monitoring Data
- Export Grafana dashboard JSON
- Backup Prometheus data (if needed)
- Backup configuration files

## 10. Troubleshooting

### 10.1 Common Issues
- **Node group creation failed**: Check IAM permissions
- **Pod scheduling failed**: Check resource requests/limits
- **Cannot access monitoring**: Check NodePort service and node IP

### 10.2 Check Logs
```bash
# Check pod logs
kubectl logs <pod-name>

# Check events
kubectl get events --sort-by='.lastTimestamp'

# Check node status
kubectl describe node <node-name>
```
