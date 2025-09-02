#!/bin/bash

echo "🧹 AWS EKS Monitoring Project Cleanup Script"
echo "============================================="

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 함수: 메시지 출력
print_message() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 1. Kubernetes 리소스 삭제
echo "📦 Cleaning up Kubernetes resources..."

if kubectl get namespace monitoring &> /dev/null; then
    print_message "Deleting monitoring namespace..."
    kubectl delete namespace monitoring --ignore-not-found=true
fi

if kubectl get hpa test-app-hpa &> /dev/null; then
    print_message "Deleting HPA..."
    kubectl delete -f kubernetes/hpa/test-app-hpa.yaml --ignore-not-found=true
fi

if kubectl get service test-app-service &> /dev/null; then
    print_message "Deleting service..."
    kubectl delete -f kubernetes/services/test-app-service.yaml --ignore-not-found=true
fi

if kubectl get deployment test-app &> /dev/null; then
    print_message "Deleting deployment..."
    kubectl delete -f kubernetes/deployments/test-app.yaml --ignore-not-found=true
fi

if kubectl get configmap test-app-html &> /dev/null; then
    print_message "Deleting configmaps..."
    kubectl delete -f kubernetes/configmaps/ --ignore-not-found=true
fi

print_message "Kubernetes resources cleaned up"

# 2. Helm 차트 삭제
echo ""
echo "📊 Cleaning up Helm charts..."

if helm list -n monitoring | grep -q monitoring; then
    print_message "Uninstalling monitoring helm chart..."
    helm uninstall monitoring -n monitoring --ignore-not-found=true
fi

# 3. Terraform 리소스 삭제 확인
echo ""
echo "🏗️  Terraform resources cleanup..."

if [ -d "terraform" ]; then
    cd terraform
    
    if [ -f ".terraform.lock.hcl" ] || [ -d ".terraform" ]; then
        print_warning "Terraform resources detected!"
        echo "To completely remove AWS resources, run:"
        echo "  cd terraform"
        echo "  terraform destroy"
        echo ""
        echo "⚠️  WARNING: This will delete ALL AWS resources including EKS cluster, VPC, etc."
        echo "⚠️  Make sure you want to delete everything before proceeding!"
        
        read -p "Do you want to destroy Terraform resources now? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_message "Destroying Terraform resources..."
            terraform destroy -auto-approve
        else
            print_warning "Terraform resources cleanup skipped"
        fi
    else
        print_message "No Terraform state found"
    fi
    
    cd ..
else
    print_warning "Terraform directory not found"
fi

# 4. 로컬 파일 정리
echo ""
echo "🗂️  Cleaning up local files..."

# Terraform 상태 파일들 삭제
if [ -d "terraform" ]; then
    cd terraform
    rm -rf .terraform* *.tfstate* .terraform.lock.hcl
    print_message "Terraform state files cleaned up"
    cd ..
fi

# 5. 최종 상태 확인
echo ""
echo "🔍 Final status check..."

if kubectl get pods --all-namespaces 2>/dev/null | grep -q test-app; then
    print_warning "Some test-app pods still exist"
else
    print_message "All test-app pods removed"
fi

if kubectl get services --all-namespaces 2>/dev/null | grep -q test-app; then
    print_warning "Some test-app services still exist"
else
    print_message "All test-app services removed"
fi

echo ""
echo "🎉 Cleanup completed!"
echo "💡 If you want to completely remove AWS resources, run 'terraform destroy' in the terraform directory"
