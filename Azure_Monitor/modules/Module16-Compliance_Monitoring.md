# Module 16: Compliance Monitoring

**Intent & Learning Objectives:**  
This module explains **Automated compliance checks for HIPAA/HITRUST and controls evidence.** in the context of healthcare (providers and payors). By the end, you will:  
- Understand the core concepts and **three key features** of Compliance Monitoring.  
- Deploy and configure Azure resources via **Bash (Azure CLI)** from VS Code.  
- Validate telemetry using **KQL** and visualize with **Azure Monitor**.

**Top Two Problems / Features**  
1. **Problem/Feature A:** Azure Policy compliance + evidence via Monitor.  
2. **Problem/Feature B:** Policy-driven diagnostics/retention enforcement.

> [!IMPORTANT]
> Treat all lab data as ePHI. Use only **synthetic** data. Apply least-privilege RBAC on Log Analytics and dashboards.

**Architecture Diagram**  
See: `assets/diagrams/module16_flow.mmd` and `assets/diagrams/module16_sequence.mmd`.

```mermaid
flowchart LR
  A["Module 16: Compliance Monitoring"] --> B["Azure Monitor"]
  B --> C["Logs/Alerts/Dashboards"]
```
```mermaid
sequenceDiagram
  participant U as User
  participant S as Service
  participant AM as Azure Monitor
  U->>S: Request
  S-->>AM: Telemetry
  AM-->>U: Insight/Alert
```

## Step-by-Step Lab

1. **Prepare environment**  
   ```bash
   cp config/env.sample config/.env
   code config/.env
   bash infra/00_prereqs.sh
   ```

2. **Deploy/Configure**  
   ```bash
   bash infra/16_security_compliance.sh
   ```

3. **Validate in Portal/KQL**  
   Example KQL:
   ```kusto
   PolicyResources | take 10
   ```

4. **(Optional) Alerting/Visualization**  
   - Pin a chart to dashboard or create an alert as described in the module.

> [!CAUTION]
> Verify resource **locations** and **quotas**. Monitoring data at rest may be subject to org retention policy.

## Pros, Cons & Insights
**Pros:** Continuous compliance; drift detection.  
**Cons:** Requires governance design; exceptions management.  
**Insights:** Codify HIPAA/HITRUST controls as policies.

## Compliance Notes
- **HIPAA/HITRUST:** Use Log Analytics RBAC; retain logs per policy (e.g., 90–365+ days).  
- **FHIR/DICOM:** Avoid placing PHI in diagnostic messages; instrument at metadata level if possible.  
- **Auditability:** Export Activity Logs and App logs for long-term archival if required.

> [!TIP]
> Commit your scripts/diagrams to source control and track changes like any production IaC.
