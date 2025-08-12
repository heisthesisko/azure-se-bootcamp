# Module 2 – VM Availability Sets (EHR Web Tier HA)

**Intent & Learning Objectives**  
Provide **high availability** for an EHR processing web front-end by deploying two VMs in an **Availability Set** behind an **internal load balancer** (ILB).  
You will learn: update/fault domains, ILB configuration, and blue/green-like maintenance with minimal downtime.

**Top 2 Problems/Features Solved**
1. **Resilience to host/rack failures** via fault domains.  
2. **Coordinated maintenance** with update domains to meet healthcare SLAs.

## Diagrams
- `assets/diagrams/module2-arch.mmd`  
- `assets/diagrams/module2-seq.mmd`

## Step-by-Step
1. **Prereqs**
   ```bash
   bash scripts/00_prereqs.sh
   ```
2. **Deploy Availability Set & VMs**
   ```bash
   bash scripts/20_module2_avset.sh
   ```
3. **Point your client** to the ILB private IP shown at the end of the script and verify both backends serve HTTP 200.

### Core Features Demonstrated
- Availability Set (fault/update domains).
- Internal Load Balancer (probe, rule, backend pool).
- Rolling updates (take one node out, update, return).

### Pros/Cons (Commentary)
- **Pros**: Increased availability without app changes; predictable maintenance windows.  
- **Cons**: Not elastic; scaling still manual; single subnet/region constraint.

> [!IMPORTANT]
> Keep the ILB **internal** for PHI-facing systems; front with Application Gateway + WAF if you need public ingress.

> [!TIP]
> Use **health probes** on app endpoints (e.g., `/healthz`) to avoid routing to degraded nodes.
