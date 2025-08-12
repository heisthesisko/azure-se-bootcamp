# Module 4 – Azure NetApp Files as Data Disks (Imaging Store)

**Intent & Learning Objectives**  
Provision **Azure NetApp Files (ANF)** and mount an NFS volume to a VM for high‑throughput medical imaging workflows (e.g., DICOM study store, PACS export, AI post‑processing).  
You will learn: provider registration, delegated subnet, pool/volume creation, and Linux NFS mounting.

**Top 2 Problems/Features Solved**
1. **High IOPS/low latency** shared storage for large imaging datasets.  
2. **POSIX semantics** and NFS compatibility for existing tools/pipelines.

## Diagrams
- `assets/diagrams/module4-arch.mmd`  
- `assets/diagrams/module4-seq.mmd`

## Step-by-Step
1. **Prereqs**
   ```bash
   bash scripts/00_prereqs.sh
   ```
2. **Create ANF**
   ```bash
   bash scripts/40_module4_netapp.sh
   ```
   Capture the mount target IP (`MTIP`).
3. **Mount on VM**
   ```bash
   VM=vm-web-01
   VMIP=$(az vm show -g ${PREFIX}-rg -n $VM -d --query privateIps -o tsv)
   ssh ${ADMIN_USERNAME}@${VMIP} "sudo apt-get update && sudo apt-get install -y nfs-common && sudo mkdir -p /mnt/anf-data && echo '${MTIP}:/${PREFIX}anfvol /mnt/anf-data nfs defaults 0 0' | sudo tee -a /etc/fstab && sudo mount -a && df -h /mnt/anf-data"
   ```

### Core Features Demonstrated
- Azure NetApp Files account, capacity pool, and volume creation.
- Delegated subnet for ANF.
- NFS mount and persistence via `/etc/fstab`.

### Pros/Cons (Commentary)
- **Pros**: Exceptional performance; POSIX NFS; simple lift-and-shift for imaging pipelines.  
- **Cons**: Premium service with quota/region availability; requires subnet delegation.

> [!IMPORTANT]
> Validate ANF **region availability** and request **quotas** in advance. For PHI, restrict access via VNet controls and export policies.

> [!TIP]
> Store transient outputs on ANF and send derived metadata (e.g., study index) to PostgreSQL/FHIR services.
