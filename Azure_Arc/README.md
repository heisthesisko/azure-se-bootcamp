# Azure Arc Healthcare Workshop – Module Index

Self-paced, end-to-end training for newly graduated engineers entering healthcare IT. You will build a hybrid environment that connects **on‑prem** (Hyper‑V + VyOS + Ubuntu/Rocky VMs) to **Azure Arc** and layer governance, security, data, apps, ML, and APIs — with **HIPAA/HITRUST/FHIR/DICOM** context.

> [!IMPORTANT]
> **HIPAA Context:** Use only synthetic or de-identified data. Apply least-privilege RBAC. Treat all lab artifacts as if they contain ePHI and protect accordingly.

## Quick Start

```bash
cp config/env.sample config/.env
code config/.env   # Fill in your values
bash infra/00_prereqs.sh
bash infra/01_network_setup.sh
bash infra/02_onboard_arc_servers.sh
bash infra/03_connect_arc_k8s.sh
```

## Learning Progression

```mermaid
flowchart LR
  M01["01 Resource Bridge"] --> M02["02 Arc Servers"] --> M03["03 Arc K8s"] --> M04["04 Inventory & Tagging"]
  M04 --> M05["05 Policy & Compliance"] --> M06["06 Security Center"] --> M07["07 RBAC"] --> M08["08 Update Mgmt"]
  M08 --> M09["09 Monitoring"] --> M10["10 Automation"] --> M11["11 Data Services"] --> M12["12 App Services"]
  M12 --> M13["13 Key Vault"] --> M14["14 Defender for Arc"] --> M15["15 Custom Locations"] --> M16["16 GitOps"]
  M16 --> M17["17 Machine Learning"] --> M18["18 API Management"] --> M19["19 Cloud for Healthcare"] --> M20["20 Governance & Reporting"]
```

## Table of Modules

| # | Module | What you’ll learn | Core script(s) | Diagrams |
|---:|---|---|---|---|
| 1 | [Azure Arc Resource Bridge](modules/Module01-Azure_Arc_Resource_Bridge.md) | Project on‑prem VMs into Azure for unified governance. | `infra/02_deploy_resource_bridge.sh` | assets/diagrams/module01_flow.mmd |
| 2 | [Arc‑Enabled Servers](modules/Module02-Arc-Enabled_Servers.md) | Onboard Windows/Linux servers; tags; extensions. | `infra/02_onboard_arc_servers.sh` | assets/diagrams/module02_flow.mmd |
| 3 | [Arc‑Enabled Kubernetes](modules/Module03-Arc-Enabled_Kubernetes.md) | Connect any K8s; enable extensions; policy. | `infra/03_connect_arc_k8s.sh` | assets/diagrams/module03_flow.mmd |
| 4 | [Inventory & Tagging](modules/Module04-Inventory_and_Tagging.md) | Unified inventory & tag taxonomy for PHI. | — | assets/diagrams/module04_flow.mmd |
| 5 | [Policy & Compliance](modules/Module05-Policy_and_Compliance.md) | Assign HIPAA/HITRUST policies; remediate. | `infra/05_policy_compliance.sh` | assets/diagrams/module05_flow.mmd |
| 6 | [Security Center Integration](modules/Module06-Security_Center_Integration.md) | Enable Defender plans; Secure Score. | `infra/06_security_center.sh` | assets/diagrams/module06_flow.mmd |
| 7 | [RBAC](modules/Module07-Role-Based_Access_Control.md) | Least‑privilege on Arc resources. | `infra/07_rbac.sh` | assets/diagrams/module07_flow.mmd |
| 8 | [Update Management](modules/Module08-Update_Management.md) | Centralized patching for Arc servers. | `infra/08_update_management.sh` | assets/diagrams/module08_flow.mmd |
| 9 | [Monitoring & Insights](modules/Module09-Monitoring_and_Insights.md) | Log Analytics, alerts, dashboards. | `infra/09_monitoring_insights.sh` | assets/diagrams/module09_flow.mmd |
| 10 | [Automation & Runbooks](modules/Module10-Automation_and_Runbooks.md) | Hybrid Runbook Worker; auto‑remediation. | `infra/10_automation.sh` | assets/diagrams/module10_flow.mmd |
| 11 | [Arc Data Services](modules/Module11-Arc-Enabled_Data_Services.md) | Run SQL MI/Postgres Hyperscale on‑prem. | `infra/11_data_services.sh` | assets/diagrams/module11_flow.mmd |
| 12 | [Arc App Services](modules/Module12-Arc-Enabled_App_Services.md) | App Service/Functions on‑prem edge. | `infra/12_app_services.sh` | assets/diagrams/module12_flow.mmd |
| 13 | [Key Vault Integration](modules/Module13-Key_Vault_Integration.md) | Central secrets & CMK; CSI driver. | `infra/13_key_vault.sh` | assets/diagrams/module13_flow.mmd |
| 14 | [Azure Defender for Arc](modules/Module14-Azure_Defender_for_Arc.md) | Threat detection for servers/K8s. | `infra/14_defender_for_arc.sh` | assets/diagrams/module14_flow.mmd |
| 15 | [Custom Locations](modules/Module15-Custom_Locations.md) | Map sites; target deployments. | `infra/15_custom_location.sh` | assets/diagrams/module15_flow.mmd |
| 16 | [GitOps Config Mgmt](modules/Module16-GitOps_Configuration_Management.md) | Flux v2 via Arc; DRY configs. | `infra/16_gitops.sh` | assets/diagrams/module16_flow.mmd |
| 17 | [Arc Machine Learning](modules/Module17-Arc-Enabled_Machine_Learning.md) | Attach on‑prem compute to Azure ML. | `infra/17_arc_ml.sh` | assets/diagrams/module17_flow.mmd |
| 18 | [Arc API Management](modules/Module18-Arc-Enabled_API_Management.md) | Self‑hosted gateway for FHIR/HL7. | `infra/18_api_management.sh` | assets/diagrams/module18_flow.mmd |
| 19 | [Microsoft Cloud for Healthcare](modules/Module19-Integration_with_MS_Cloud_for_Healthcare.md) | FHIR/DICOM pipelines; hybrid EHR. | `infra/19_healthcare_integration.sh` | assets/diagrams/module19_flow.mmd |
| 20 | [Centralized Governance & Reporting](modules/Module20-Centralized_Governance_and_Reporting.md) | Policy/Workbook reports for audits. | `infra/20_governance_reporting.sh` | assets/diagrams/module20_flow.mmd |

> [!TIP]
> Use the `scripts/` folder to bootstrap on‑prem VMs (PostgreSQL, Apache/PHP, AI) and VyOS VPN. Replace placeholders in `config/.env` before running any infra scripts.
