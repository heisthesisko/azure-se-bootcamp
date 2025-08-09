# Azure Site Recovery Workshop (VMware + Hyper‑V + Azure‑to‑Azure)

This hands‑on workshop lets a student configure and test Azure Site Recovery (ASR) for:

1) **On‑prem Linux (VMware/ESXi)**: Apache + PHP web tier → **PostgreSQL** DB tier  
2) **On‑prem Windows (Hyper‑V)**: IIS + PHP web tier → **SQL Server Express** DB tier  
3) **Azure‑to‑Azure Linux**: Apache + PHP + **PostgreSQL** running in **US West**, replicated to **East US**

The sample apps show a simple web page that reads from the database using a shared `trek_northwind` schema.

> **Prereqs:** Azure subscription Owner/Contributor; on‑prem access to ESXi and Hyper‑V; outbound internet; local admin on all test VMs.
...

---

## Diagrams

Flowcharts:
- [VMware Linux → Azure](diagrams/vmware-linux-to-azure.md)
- [Hyper‑V Windows → Azure](diagrams/hyperv-windows-to-azure.md)
- [Azure‑to‑Azure Linux](diagrams/azure-to-azure-linux.md)
- [Overall Architecture](diagrams/overall-architecture.md)

Sequences:
- [VMware Linux sequence](diagrams/vmware-linux-sequence.md)
- [Hyper‑V Windows sequence](diagrams/hyperv-windows-sequence.md)
- [Azure‑to‑Azure Linux sequence](diagrams/a2a-linux-sequence.md)
- [Overall failover lifecycle](diagrams/overall-failover-lifecycle-sequence.md)

