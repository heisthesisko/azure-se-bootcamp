# Module 3: Arc-Enabled Kubernetes

> [!IMPORTANT]
> Use synthetic ePHI; follow least privilege RBAC; record evidence for audits.

## Intent & Learning Objectives
Attach any CNCF‑conformant Kubernetes cluster (microk8s/k3s/AKS‑on‑prem) to Azure Arc for governance, extensions, and GitOps.

## Top Problems Solved
1. Multi‑cluster sprawl with no uniform guardrails.
2. Hard to enforce K8s security baselines across sites.

## Key Features Demonstrated
- Connect cluster via `az connectedk8s connect`.
- Install extensions (Azure Monitor, Policy, Defender).
- Apply K8s policies (Gatekeeper) with Azure Policy.

## Architecture Diagram
See `assets/diagrams/module03_flow.mmd`.

## Step-by-Step

1. Install CLI extensions: `az extension add --name connectedk8s k8s-extension k8s-configuration`.
2. Connect: `az connectedk8s connect -g $ARC_RG_K8S -n $ARC_K8S_NAME --tags Environment=OnPrem Purpose=EdgeAnalytics`.
3. Verify agents: `kubectl get pods -n azure-arc` and (if enabled) `kubectl get pods -n gatekeeper-system`.
4. Enable container insights: `az k8s-extension create --cluster-type connectedClusters --cluster-name $ARC_K8S_NAME -g $ARC_RG_K8S --extension-type Microsoft.AzureMonitor.Containers --name azuremonitor-containers --configuration-settings logAnalyticsWorkspaceResourceID=/subs/.../workspaces/$LA_WS_NAME`.
5. (Optional) Assign a policy: deny privileged pods; observe compliance in Azure Policy.


## Pros, Cons & Warnings
- **Pros:** Unified policy/monitoring for edge clusters; no inbound ports required (Cluster Connect).
- **Cons:** You still operate the cluster control plane; extensions add resource overhead.
> [!CAUTION]
> Scope Azure RBAC carefully—cluster connect plus admin role equals cluster‑wide power.

> [!TIP]
> Use tags like `Location=HospitalA` and `DataClassification=PHI` on clusters for reporting.
