#!/usr/bin/env bash
set -euo pipefail
# Install Azure Workload Identity and Secrets Store CSI + Azure provider on OpenShift
# Prereqs: cluster-admin, helm, oc

# Add Helm repos (versions are placeholders; pin to your compliance-approved ones)
helm repo add azure-workload-identity https://azure.github.io/azure-workload-identity/charts
helm repo add csi-secrets-store https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm repo add csi-secrets-store-provider-azure https://azure.github.io/secrets-store-csi-driver-provider-azure/charts
helm repo update

# Install azure-workload-identity webhook
helm upgrade --install workload-identity-webhook azure-workload-identity/azure-workload-identity-webhook -n kube-system

# Install Secrets Store CSI Driver
helm upgrade --install csi-secrets-store csi-secrets-store/secrets-store-csi-driver -n kube-system

# Install Azure provider for CSI
helm upgrade --install csi-azure-provider csi-secrets-store-provider-azure/csi-secrets-store-provider-azure -n kube-system

echo "✅ Installed azure-workload-identity + Secrets Store CSI + Azure provider (verify pods are Running)."
