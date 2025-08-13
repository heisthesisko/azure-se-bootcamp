# Module 1: Azure Arc Resource Bridge

> [!IMPORTANT]
> Use synthetic ePHI; follow least privilege RBAC; record evidence for audits.

## Intent & Learning Objectives
Connect on‑prem virtualization (Hyper‑V/SCVMM or vCenter) to Azure with Resource Bridge to project VMs as Azure resources for unified governance in healthcare.

## Top Problems Solved
1. Siloed on‑prem VM management vs cloud governance.
2. Inconsistent policy/security across clinical VMs (EHR, PACS).

## Key Features Demonstrated
- Deploy Arc Resource Bridge appliance.
- Project on‑prem VMs as Azure resources and tag them (PHI).
- Create a Custom Location representing the datacenter.

## Architecture Diagram
See `assets/diagrams/module01_flow.mmd`.

## Step-by-Step

1. Ensure providers registered: `Microsoft.ScVmm` or `Microsoft.VMware`, `Microsoft.ExtendedLocation`.
2. In Azure Portal: Azure Arc ➜ Add ➜ Select SCVMM or vCenter ➜ Generate deployment script.
3. Run the script on your virtualization mgmt host to deploy the appliance VM; wait for status **Connected**.
4. Verify VMs appear under Azure Arc (vSphere/SCVMM) and as **Arc‑enabled servers**.
5. Tag a projected VM: `Compliance=HIPAA`, `DataClassification=PHI`.
6. (Optional) Provision a new on‑prem VM from Azure (if templates available).


## Pros, Cons & Warnings
- **Pros:** Cloud governance for legacy on‑prem workloads; enables consistent tagging, policy, and security posture.
- **Cons:** Adds an appliance to manage; supports specific hypervisors only; requires outbound connectivity.
> [!CAUTION]
> Deleting the bridge or losing connectivity removes Azure visibility (workloads continue running). Monitor bridge health.

> [!TIP]
> Use descriptive Custom Location names like `HospitalA-DC1` to target Arc Data/App Services later.
