# Module 5: AKS Scaling & Autoscaling

**Intent & Learning Objectives**  
Automatically adjusts resources for fluctuating healthcare demand.

> [!IMPORTANT]
> Treat all lab data as ePHI. Use synthetic data only.

## Top Two Problems This Solves
1. Secure-by-default deployment for regulated data.
2. Repeatable automation for healthcare workloads.

## Architecture
```mermaid
flowchart LR
  OnPrem[(On-Prem)] --> AKS
  AKS --> ACR
  AKS --> Monitor[Monitor/Defender]

```

**Sequence**
```mermaid
sequenceDiagram
  participant User
  participant Web as OnPrem PHP
  participant AKS as AKS
  User->>Web: Request
  Web->>AKS: Call
  AKS-->>Web: Response
  Web-->>User: Render

```

## Steps
```bash
cp config/env.sample config/.env
bash infra/00_prereqs.sh
bash infra/01_rg_vnet.sh
bash infra/module05_aks_scaling_autoscaling.sh || true
```
