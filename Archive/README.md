# Azure VM Training Workshop (Healthcare Edition)

This repository contains a four-module, hands-on workshop for new computer engineers entering healthcare IT. 
It assumes **zero prior Azure experience** and uses **healthcare scenarios** (patient intake, EHR processing, medical imaging analysis).
All steps use **Bash** with **Azure CLI** (Cloud Shell or VS Code) and deploy Ubuntu-based VMs. Web workloads use **PHP**; AI components use **Python**.

> [!IMPORTANT]
> This training references HIPAA, HITECH, and common security frameworks (NIST 800-53/171, CIS Benchmarks) but is **not legal advice**. 
> Always work with your compliance team and obtain a **Business Associate Agreement (BAA)** with Microsoft for PHI in Azure.

## Modules
- **Module 1 – Single VM deployment**: Deploy a secure single VM hosting a PHP patient intake portal.
- **Module 2 – VM Availability Sets**: Introduce high availability for an EHR processing web tier with PostgreSQL backend.
- **Module 3 – VM Scale Sets**: Scale a medical imaging inference API (Python/FastAPI) using VMSS and Azure Load Balancer.
- **Module 4 – NetApp Files as Data Disks**: Attach Azure NetApp Files (ANF) NFS volume to a VM for high‑throughput imaging data.

## Repository Layout
```
.vscode/         VS Code tasks & settings
app/
  ai/            Python AI FastAPI example for imaging
  web/           PHP patient intake app
assets/
  docs/          PDFs/Word/extra docs + reference URLs (Markdown)
  images/        Images embedded in Markdown
  diagrams/      Mermaid diagrams used across modules
config/          Env files, VyOS sample config, etc.
db/              PostgreSQL schema and sample data
infra/           Cloud-init files and templates
scripts/         Bash scripts for deployments
system/          Service files (systemd), web server vhost examples
```
All empty folders contain `.gitkeep`.

## Getting Started
1. Install VS Code + Azure CLI or use Azure Cloud Shell.
2. Clone this repo and open it in VS Code.
3. Copy `config/env.sample` to `.env` and set values.
4. Run the **Tasks** in VS Code (Terminal → Run Task) or execute scripts in `scripts/` manually.

> [!TIP]
> Use a **sandbox subscription**. Most scripts create resources with the prefix you set, so you can delete everything with the cleanup script.
