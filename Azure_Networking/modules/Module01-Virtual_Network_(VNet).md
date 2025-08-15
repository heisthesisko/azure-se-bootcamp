    # Module 1: Virtual Network (VNet)

    **Intent & Learning Objectives:** Core private network for Azure resources, enabling secure communication.
    **Estimated time:** 40–60 min

    **Key Features Demonstrated:**
    - Address spaces & RFC1918 planning
    - VNet creation via CLI
    - Tags and resource governance

    **Top Problems/Features this module addresses:**
    - Create an isolated address space for healthcare workloads
    - Lay down a foundation for secure segmentation

    > [!TIP]
> **Director of IT (Hospital) Commentary:** In our cardiac unit, a poorly segmented network once let a QA tool scan a PACS archive during business hours—latency spiked and radiologists noticed. Each control you deploy here (subnets, NSGs, UDR) reduces blast radius and supports change windows—crucial for uptime SLAs and Joint Commission readiness.

    > [!IMPORTANT]
> **HIPAA / HITRUST context:** Use mock/test data only. Enforce least privilege RBAC, Private Endpoints, TLS 1.2+, and CMK where relevant. Audit access via Log Analytics. For FHIR/DICOM workloads, ensure correct media types, scopes, and healthcare APIs are private by default.

    > [!CAUTION]
> Some resources in this module may accrue cost (e.g., public IPs, App Gateway WAF_v2, Front Door, ExpressRoute, Bastion, vWAN). Use a training subscription and clean up when finished.


    ## Architecture Diagram – Overview
    See: `assets/diagrams/module01_flow.mmd`

    ## Sequence Diagram – Key Interactions
    See: `assets/diagrams/module01_sequence.mmd`

    ### Step-by-Step Lab

    1. **Prepare environment**  
   ```bash
   cp config/env.sample config/.env
   code config/.env   # set SUBSCRIPTION_ID, RG_NAME, LOCATION, etc.
   source config/.env
   bash infra/00_prereqs.sh
   ```
2. **Run this module's script**  
   ```bash
   bash infra/m01_vnet.sh
   ```
3. **Validate outcomes** – follow checks below.


    ### Validation
    Verify the VNet exists and CIDR is correct: `az network vnet show -g "$RG_NAME" -n "$VNET_NAME" -o table`.

    ## Pros, Cons & Insights
    **Pros:** Clear, modular networking that supports least-privilege, auditability, and deterministic routing for healthcare services (EMR/EHR, PACS, FHIR APIs).  
    **Cons:** More artifacts to manage (DNS, routes, NSGs). Costs may increase for premium SKUs.  
    **Insights:** Combine NSGs + Firewall + Private Endpoints for a defense-in-depth posture aligned to HIPAA/HITRUST controls (transmission security, access control, audit).

    ## Cleanup
    ```bash
    bash scripts/azure_cleanup.sh
    ```
