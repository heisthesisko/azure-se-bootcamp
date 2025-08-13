#!/usr/bin/env bash
set -euo pipefail


source config/.env

echo "Assign sample built-in policies (audit)"
# Example: Audit Linux accounts without passwords (Guest Configuration)
POLICY_DEF_ID="/providers/Microsoft.Authorization/policyDefinitions/1f3afdf9-cae0-4a46-9a12-056f6d7d9e69"
az policy assignment create -g "$AZ_RG" -n "Audit-Linux-NoPassword-Arc" --policy "$POLICY_DEF_ID"

echo "Assign Kubernetes policy to deny privileged containers (audit)"
K8S_POLICY_DEF="/providers/Microsoft.Authorization/policyDefinitions/c3ab992d-7057-4c8d-9a15-882ad6f08c2a"
az policy assignment create -g "$AZ_RG" -n "Audit-K8s-NoPrivileged" --policy "$K8S_POLICY_DEF" \
  --scope "/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/$AZ_RG/providers/Microsoft.Kubernetes/connectedClusters/$ARC_K8S_NAME"
