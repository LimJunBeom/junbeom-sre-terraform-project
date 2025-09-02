#!/bin/bash

echo "🚀 AWS EKS Monitoring Project Deployment Script"
echo "================================================"

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if helm is available
if ! command -v helm &> /dev/null; then
    echo "❌ helm is not installed. Please install helm first."
    exit 1
fi

echo "✅ Prerequisites check passed"
echo ""

# Deploy ConfigMaps first
echo "📦 Deploying ConfigMaps..."
kubectl apply -f kubernetes/configmaps/
echo "✅ ConfigMaps deployed"

# Deploy test application
echo "🚀 Deploying test application..."
kubectl apply -f kubernetes/deployments/test-app.yaml
kubectl apply -f kubernetes/services/test-app-service.yaml
kubectl apply -f kubernetes/hpa/test-app-hpa.yaml
echo "✅ Test application deployed"

# Wait for pods to be ready
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=test-app --timeout=300s
echo "✅ Pods are ready"

# Get node IP for external access
echo "🌐 Getting node information for external access..."
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
if [ -z "$NODE_IP" ]; then
    NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
fi

echo "✅ Node IP: $NODE_IP"
echo "🌐 Web Dashboard: http://$NODE_IP:30080"
echo "🔍 Health Check: http://$NODE_IP:30080/health"
echo "📊 Status API: http://$NODE_IP:30080/status"

# Show service status
echo ""
echo "📋 Service Status:"
kubectl get services
echo ""

echo "📋 Pod Status:"
kubectl get pods
echo ""

echo "📋 HPA Status:"
kubectl get hpa
echo ""

echo "🎉 Deployment completed successfully!"
echo "💡 Open http://$NODE_IP:30080 in your browser to see the beautiful dashboard!"
echo "🧪 Use the 'Generate CPU Load' button to test HPA functionality"
