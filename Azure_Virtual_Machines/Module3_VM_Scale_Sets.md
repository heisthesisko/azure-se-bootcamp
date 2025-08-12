# Module 3 – VM Scale Sets (Medical Imaging Inference API)

**Intent & Learning Objectives**  
Deploy a **VM Scale Set (VMSS)** that runs a Python FastAPI service to perform toy *medical imaging* inference. Add **autoscale** rules to handle load surges (e.g., batch uploads from modalities/PACS).  
You will learn: VMSS creation, load balancing, autoscale rules, and app bootstrapping.

**Top 2 Problems/Features Solved**
1. **Elastic scaling** for compute-heavy imaging analysis.  
2. **Uniform configuration** across instances with automatic upgrades.

## Diagrams
- `assets/diagrams/module3-arch.mmd`  
- `assets/diagrams/module3-seq.mmd`

## Step-by-Step
1. **Prereqs**
   ```bash
   bash scripts/00_prereqs.sh
   ```
2. **Deploy VMSS**
   ```bash
   bash scripts/30_module3_vmss.sh
   ```
3. **Deploy AI app content**
   Copy AI files to a VMSS instance (for demo) or bake into a custom image:
   ```bash
   LBIP=$(az network public-ip list -g ${PREFIX}-rg --query "[?contains(name, '${PREFIX}-vmss-lb')].ipAddress" -o tsv)
   echo "Test health: curl http://${LBIP}:80/healthz"
   ```
   For a full deployment, use a custom script extension or image baking to place `app/ai` into `/opt/ai` and install `requirements.txt`.

### Core Features Demonstrated
- VMSS creation & integration with Load Balancer.
- Autoscale rules based on CPU.
- Rolling upgrades with `--upgrade-policy-mode automatic`.

### Pros/Cons (Commentary)
- **Pros**: True elasticity; consistent config; better cost control (scale-in).  
- **Cons**: Stateless app pattern needed; image/version management required.

> [!CAUTION]
> Persisted artifacts (e.g., DICOM) must be stored off-VM (ANF, Blob, or managed disks). Treat instances as ephemeral.

> [!TIP]
> Use a **custom image** or **cloud-init** to install `imaging_infer.py` automatically, and a **systemd** unit (see `system/ai.service`). 
