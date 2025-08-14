# Module 1: Azure Monitor Metrics

**Intent & Learning Objectives:**  
This module explains **Collects and analyzes performance metrics from healthcare resources.** in the context of healthcare (providers and payors). By the end, you will:  
- Understand the core concepts and **three key features** of Azure Monitor Metrics.  
- Deploy and configure Azure resources via **Bash (Azure CLI)** from VS Code.  
- Validate telemetry using **KQL** and visualize with **Azure Monitor**.

**Top Two Problems / Features**  
1. **Problem/Feature A:** Real-time performance baselines for critical systems (e.g., EHR, PACS).  
2. **Problem/Feature B:** Thresholds for proactive capacity/incident response.

> [!IMPORTANT]
> Treat all lab data as ePHI. Use only **synthetic** data. Apply least-privilege RBAC on Log Analytics and dashboards.

**Architecture Diagram**  
See: `assets/diagrams/module01_flow.mmd` and `assets/diagrams/module01_sequence.mmd`.

```mermaid
flowchart LR
  A["Module 1: Azure Monitor Metrics"] --> B["Azure Monitor"]
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
   bash infra/02_setup_metrics_vm.sh
   ```

3. **Validate in Portal/KQL**  
   Example KQL:
   ```kusto
   // Metrics are accessed via portal; use az monitor metrics list for CLI.
// Example for CPU (see Module 1 doc).
   ```

4. **(Optional) Alerting/Visualization**  
   - Pin a chart to dashboard or create an alert as described in the module.

> [!CAUTION]
> Verify resource **locations** and **quotas**. Monitoring data at rest may be subject to org retention policy.

## Pros, Cons & Insights
**Pros:** Near real-time, low overhead, easy to alert.  
**Cons:** Limited context; short retention by default.  
**Insights:** Define 'vital signs' for apps (CPU/mem/IO/latency) and baseline them.

## Compliance Notes
- **HIPAA/HITRUST:** Use Log Analytics RBAC; retain logs per policy (e.g., 90–365+ days).  
- **FHIR/DICOM:** Avoid placing PHI in diagnostic messages; instrument at metadata level if possible.  
- **Auditability:** Export Activity Logs and App logs for long-term archival if required.

> [!TIP]
> Commit your scripts/diagrams to source control and track changes like any production IaC.
