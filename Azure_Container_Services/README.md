# Azure Container Services for Healthcare – Workshop

> [!IMPORTANT]
> HIPAA Context: Use synthetic data only.

## Quick Start
```bash
cp config/env.sample config/.env
bash infra/00_prereqs.sh
bash infra/01_rg_vnet.sh
bash infra/module01_azure_container_registry_acr.sh
```

## Modules

| # | Module | What you’ll learn | Core script(s) | Diagrams | Est. Time |
|---:|---|---|---|---|---|
| 1 | [Azure Container Registry (ACR)](modules/Module01-azure_container_registry_acr.md) | Secure, private registry for storing and managing healthcare container images. | `infra/module01_azure_container_registry_acr.sh` | assets/diagrams/module01_azure_container_registry_acr_flow.mmd | ~35–60 min |
| 2 | [Azure Container Instances (ACI)](modules/Module02-azure_container_instances_aci.md) | Serverless, on-demand container execution for simple healthcare workloads. | `infra/module02_azure_container_instances_aci.sh` | assets/diagrams/module02_azure_container_instances_aci_flow.mmd | ~35–60 min |
| 3 | [Azure Kubernetes Service (AKS)](modules/Module03-azure_kubernetes_service_aks.md) | Managed Kubernetes for orchestrating complex healthcare container workloads. | `infra/module03_azure_kubernetes_service_aks.sh` | assets/diagrams/module03_azure_kubernetes_service_aks_flow.mmd | ~35–60 min |
| 4 | [AKS Node Pools](modules/Module04-aks_node_pools.md) | Segregate workloads by resource needs (e.g., compliance, performance) in healthcare clusters. | `infra/module04_aks_node_pools.sh` | assets/diagrams/module04_aks_node_pools_flow.mmd | ~35–60 min |
| 5 | [AKS Scaling & Autoscaling](modules/Module05-aks_scaling_autoscaling.md) | Automatically adjusts resources for fluctuating healthcare demand. | `infra/module05_aks_scaling_autoscaling.sh` | assets/diagrams/module05_aks_scaling_autoscaling_flow.mmd | ~35–60 min |
| 6 | [AKS Networking (CNI, Ingress)](modules/Module06-aks_networking_cni_ingress.md) | Advanced networking for secure, compliant healthcare data flows. | `infra/module06_aks_networking_cni_ingress.sh` | assets/diagrams/module06_aks_networking_cni_ingress_flow.mmd | ~35–60 min |
| 7 | [AKS Storage Integration](modules/Module07-aks_storage_integration.md) | Persistent storage for stateful healthcare apps (e.g., EHR/EMR). | `infra/module07_aks_storage_integration.sh` | assets/diagrams/module07_aks_storage_integration_flow.mmd | ~35–60 min |
| 8 | [AKS Monitoring & Insights](modules/Module08-aks_monitoring_insights.md) | Real-time health, performance, and compliance monitoring for healthcare containers. | `infra/module08_aks_monitoring_insights.sh` | assets/diagrams/module08_aks_monitoring_insights_flow.mmd | ~35–60 min |
| 9 | [AKS Security & Policy Management](modules/Module09-aks_security_policy_management.md) | RBAC, network policies, and Azure Policy for healthcare compliance (HIPAA, HITRUST). | `infra/module09_aks_security_policy_management.sh` | assets/diagrams/module09_aks_security_policy_management_flow.mmd | ~35–60 min |
| 10 | [AKS Secrets Management (Key Vault)](modules/Module10-aks_secrets_management_key_vault.md) | Secure storage and management of healthcare secrets and certificates. | `infra/module10_aks_secrets_management_key_vault.sh` | assets/diagrams/module10_aks_secrets_management_key_vault_flow.mmd | ~35–60 min |
| 11 | [AKS Upgrades & Maintenance](modules/Module11-aks_upgrades_maintenance.md) | Automated, zero-downtime upgrades for healthcare clusters. | `infra/module11_aks_upgrades_maintenance.sh` | assets/diagrams/module11_aks_upgrades_maintenance_flow.mmd | ~35–60 min |
| 12 | [AKS Private Clusters](modules/Module12-aks_private_clusters.md) | Isolated clusters for sensitive healthcare workloads and data. | `infra/module12_aks_private_clusters.sh` | assets/diagrams/module12_aks_private_clusters_flow.mmd | ~35–60 min |
| 13 | [AKS Integration with Azure Active Directory](modules/Module13-aks_integration_with_azure_active_directory.md) | Centralized identity and access management for healthcare teams. | `infra/module13_aks_integration_with_azure_active_directory.sh` | assets/diagrams/module13_aks_integration_with_azure_active_directory_flow.mmd | ~35–60 min |
| 14 | [AKS Integration with Azure Monitor & Defender](modules/Module14-aks_integration_with_azure_monitor_defender.md) | Unified monitoring and security for healthcare containers. | `infra/module14_aks_integration_with_azure_monitor_defender.sh` | assets/diagrams/module14_aks_integration_with_azure_monitor_defender_flow.mmd | ~35–60 min |
| 15 | [AKS Integration with Azure Arc](modules/Module15-aks_integration_with_azure_arc.md) | Hybrid and multi-cloud management for healthcare container workloads. | `infra/module15_aks_integration_with_azure_arc.sh` | assets/diagrams/module15_aks_integration_with_azure_arc_flow.mmd | ~35–60 min |
| 16 | [AKS Integration with Azure Policy](modules/Module16-aks_integration_with_azure_policy.md) | Enforces compliance and governance for healthcare containers. | `infra/module16_aks_integration_with_azure_policy.sh` | assets/diagrams/module16_aks_integration_with_azure_policy_flow.mmd | ~35–60 min |
| 17 | [AKS Integration with Azure DevOps](modules/Module17-aks_integration_with_azure_devops.md) | CI/CD pipelines for rapid, compliant healthcare app delivery. | `infra/module17_aks_integration_with_azure_devops.sh` | assets/diagrams/module17_aks_integration_with_azure_devops_flow.mmd | ~35–60 min |
| 18 | [AKS Integration with Microsoft Cloud for Healthcare](modules/Module18-aks_integration_with_microsoft_cloud_for_healthcare.md) | Deploys healthcare reference architectures and solutions. | `infra/module18_aks_integration_with_microsoft_cloud_for_healthcare.sh` | assets/diagrams/module18_aks_integration_with_microsoft_cloud_for_healthcare_flow.mmd | ~35–60 min |
| 19 | [AKS Support for Confidential Computing](modules/Module19-aks_support_for_confidential_computing.md) | Protects sensitive healthcare data in use with hardware-based encryption. | `infra/module19_aks_support_for_confidential_computing.sh` | assets/diagrams/module19_aks_support_for_confidential_computing_flow.mmd | ~35–60 min |
| 20 | [AKS Support for AI/ML Workloads](modules/Module20-aks_support_for_ai_ml_workloads.md) | Runs healthcare AI/ML models and analytics in containers at scale. | `infra/module20_aks_support_for_ai_ml_workloads.sh` | assets/diagrams/module20_aks_support_for_ai_ml_workloads_flow.mmd | ~35–60 min |
