#!/usr/bin/env bash
set -euo pipefail
# Install OSSM (Service Mesh): Elasticsearch, Jaeger, Kiali, and ServiceMesh control plane operators
for op in elasticsearch-operator jaeger-product kiali-ossm servicemeshoperator; do
cat <<EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ${op}
  namespace: openshift-operators
spec:
  channel: stable
  name: ${op}
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOF
done
echo "[OK] Service Mesh operator subscriptions applied."
