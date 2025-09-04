#!/usr/bin/env bash
set -euo pipefail
# deploy_batch_job.sh — Create Azure Batch account/pool and submit a sample containerized inference job
# Prereqs: az login; 'az batch' extension installed; ACR image with inference code available; Storage SAS URIs prepared for input/output as needed

SUB=${SUB:-$(az account show --query id -o tsv)}
RG=${RG:-ImagingRG}
LOCATION=${LOCATION:-eastus}
BATCH_ACC=${BATCH_ACC:-imagingbatch$RANDOM}
POOL=${POOL:-inference-pool}
VM_SIZE=${VM_SIZE:-Standard_D2s_v5}
NODE_COUNT=${NODE_COUNT:-2}
IMAGE=${IMAGE:-mcr.microsoft.com/azureml/openmpi4.1.0-ubuntu20.04:latest} # replace with your inference image
JOB_ID=${JOB_ID:-inference-job-$(date +%s)}

echo "[*] Registering provider"
az provider register --namespace Microsoft.Batch --wait

echo "[*] Creating Batch account: $BATCH_ACC"
az batch account create -g "$RG" -l "$LOCATION" -n "$BATCH_ACC"

echo "[*] Logging into Batch"
az batch account login -g "$RG" -n "$BATCH_ACC"

echo "[*] Creating Pool: $POOL"
az batch pool create --id "$POOL" --vm-size "$VM_SIZE" --target-dedicated-nodes "$NODE_COUNT" \
  --image "microsoft-azure-batch:ubuntu-server-container:20-04-lts:latest" \
  --container-image "$IMAGE"

echo "[*] Creating Job: $JOB_ID"
az batch job create --id "$JOB_ID" --pool-id "$POOL"

echo "[*] Adding sample task (replace with your script/args)"
TASK_ID="task1"
az batch task create --job-id "$JOB_ID" --id "$TASK_ID" \
  --command-line "/bin/bash -lc 'python infer.py --input /mnt/input --output /mnt/output'"

echo "[*] Done. Monitor job/task status with 'az batch task list --job-id $JOB_ID'."
