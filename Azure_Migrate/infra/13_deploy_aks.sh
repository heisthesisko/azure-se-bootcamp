#!/usr/bin/env bash
set -euo pipefail
source config/.env
az account set --subscription "$AZ_SUBSCRIPTION_ID"
az aks create -g "$RG_NAME" -n "$AKS_NAME" --node-count 1 --node-vm-size Standard_DS2_v2 --generate-ssh-keys
az aks get-credentials -g "$RG_NAME" -n "$AKS_NAME" --overwrite-existing

# Deploy AI service
cat > k8s-ai.yaml <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ai-svc
spec:
  replicas: 1
  selector:
    matchLabels: { app: ai-svc }
  template:
    metadata:
      labels: { app: ai-svc }
    spec:
      containers:
      - name: ai
        image: REPLACE_IMAGE
        ports:
        - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: ai-svc
spec:
  selector: { app: ai-svc }
  ports:
  - port: 80
    targetPort: 5000
  type: LoadBalancer
YAML

IMAGE="$ACR_NAME.azurecr.io/hc-ai:latest"
sed -i "s|REPLACE_IMAGE|$IMAGE|g" k8s-ai.yaml
az aks update -g "$RG_NAME" -n "$AKS_NAME" --attach-acr "$ACR_NAME"
kubectl apply -f k8s-ai.yaml
echo "AKS deployed with AI service."
