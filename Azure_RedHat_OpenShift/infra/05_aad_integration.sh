#!/usr/bin/env bash
set -euo pipefail
source config/.env
: "${AAD_APP_ID:?}"
: "${AAD_TENANT_ID:?}"
: "${AAD_CLIENT_SECRET:?}"

oc project openshift-config
oc delete secret azure-auth-secret -n openshift-config --ignore-not-found
oc create secret generic azure-auth-secret -n openshift-config --from-literal=clientSecret="$AAD_CLIENT_SECRET"

cat <<EOF | oc apply -f -
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
  - name: Azure AD
    mappingMethod: claim
    type: OpenID
    openID:
      clientID: ${AAD_APP_ID}
      clientSecret:
        name: azure-auth-secret
      issuer: https://login.microsoftonline.com/${AAD_TENANT_ID}/v2.0
      claims:
        preferredUsername:
        - upn
        name:
        - name
        email:
        - email
EOF
echo "[OK] Entra ID configured. Use web console to login via Azure AD."
