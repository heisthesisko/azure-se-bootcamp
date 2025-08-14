#!/usr/bin/env bash
set -euo pipefail
# Install OpenShift Pipelines (Tekton) via Operator subscription
cat <<EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-pipelines-operator
  namespace: openshift-operators
spec:
  channel: stable
  name: openshift-pipelines-operator-rh
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOF
echo "[OK] Tekton operator subscription applied."
