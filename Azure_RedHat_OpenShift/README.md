# Azure Red Hat OpenShift (ARO) Healthcare Workshop — 20 Modules

> [!IMPORTANT]
> **HIPAA/HITRUST Context:** Use synthetic or de-identified data only. Apply least-privilege RBAC and network segmentation. Treat all lab artifacts as if they contain ePHI.

## Quick Start
```bash
cp config/env.sample config/.env
code config/.env      # fill values, save, then
source config/.env
bash infra/00_prereqs.sh
bash infra/01_create_vnet.sh
bash infra/02_create_aro_cluster.sh
```
> [!TIP]
> Prefer VS Code terminal. Ensure Azure CLI is logged in: `az login` and `az account set -s "$AZ_SUBSCRIPTION_ID"`.

## Module Progression
```mermaid
flowchart LR
  M01["01 Managed Clusters"] --> M02["02 Portal"]
  M02 --> M03["03 Patching"] --> M04["04 HA & SLA"]
  M04 --> M05["05 Entra ID"] --> M06["06 RBAC"]
  M06 --> M07["07 Monitoring & Logging"] --> M08["08 Persistent Storage"]
  M08 --> M09["09 NetSec (Policy)"] --> M10["10 Private & VNET"]
  M10 --> M11["11 Autoscaling"] --> M12["12 CI/CD Pipelines"]
  M12 --> M13["13 OLM"] --> M14["14 Service Mesh"]
  M14 --> M15["15 Serverless"] --> M16["16 Sec & Compliance"]
  M16 --> M17["17 Azure Arc"] --> M18["18 Virtualization"]
  M18 --> M19["19 AI/ML"] --> M20["20 DR & Backup"]
```

## Table of Modules
| # | Module | Path | Est. Time |
|---:|---|---|---|
| 1 | Fully Managed OpenShift Clusters | modules/Module01-Fully_Managed_OpenShift_Clusters.md | ~45–60m |
| 2 | Integrated Azure Portal Experience | modules/Module02-Integrated_Azure_Portal_Experience.md | ~20–30m |
| 3 | Automated Updates & Patching | modules/Module03-Automated_Updates_and_Patching.md | ~15–30m |
| 4 | Built-in High Availability & SLA | modules/Module04-Built-in_High_Availability_and_SLA.md | ~20–30m |
| 5 | Azure AD (Entra ID) Integration | modules/Module05-Azure_AD_Integration.md | ~30–45m |
| 6 | Role-Based Access Control (RBAC) | modules/Module06-Role-Based_Access_Control.md | ~20–30m |
| 7 | Integrated Monitoring & Logging | modules/Module07-Integrated_Monitoring_and_Logging.md | ~25–40m |
| 8 | Persistent Storage Integration | modules/Module08-Persistent_Storage_Integration.md | ~30–45m |
| 9 | Network Security & Policy Management | modules/Module09-Network_Security_and_Policy_Management.md | ~25–40m |
| 10 | Private Clusters & VNET Integration | modules/Module10-Private_Clusters_and_VNET_Integration.md | ~40–60m |
| 11 | Cluster Autoscaling & Resource Optimization | modules/Module11-Cluster_Autoscaling_and_Resource_Optimization.md | ~30–45m |
| 12 | Built-in CI/CD Pipelines (Tekton) | modules/Module12-Built-in_CICD_Pipelines.md | ~40–60m |
| 13 | Operator Lifecycle Manager (OLM) | modules/Module13-Operator_Lifecycle_Manager.md | ~20–30m |
| 14 | Service Mesh (Istio/OSSM) | modules/Module14-Service_Mesh.md | ~40–60m |
| 15 | Serverless (Knative) | modules/Module15-Serverless.md | ~30–45m |
| 16 | Integrated Security & Compliance Tools | modules/Module16-Integrated_Security_and_Compliance_Tools.md | ~25–40m |
| 17 | Hybrid & Multi-Cloud (Azure Arc) | modules/Module17-Hybrid_and_Multi-Cloud_Support.md | ~30–50m |
| 18 | OpenShift Virtualization (Preview) | modules/Module18-OpenShift_Virtualization.md | ~25–40m |
| 19 | AI/ML Integration (TF & Hugging Face) | modules/Module19-AI-ML_Integration.md | ~35–60m |
| 20 | Disaster Recovery & Backup (Velero) | modules/Module20-Disaster_Recovery_and_Backup_Solutions.md | ~30–50m |

> [!CAUTION]
> Resources (ARO cluster, gateways, storage) incur cost. Delete when done: `az aro delete -g "$RESOURCEGROUP" -n "$CLUSTER_NAME"`.

## On-Prem Lab Tie-in (Hyper‑V + VyOS)
- `scripts/onprem_vyos_ipsec_config.txt` — sample IPsec config to Azure VPN Gateway.
- `scripts/onprem_postgres_init.sh` — PostgreSQL init (synthetic ePHI).
- `scripts/onprem_apache_init.sh` — Apache/PHP portal.
- `scripts/onprem_ai_server_init.sh` — AI server bootstrap.
- `scripts/backup_testdata.sh` — generate mock ePHI CSV/JSON.

---
Happy shipping secure, compliant healthcare apps on ARO! 🚀
