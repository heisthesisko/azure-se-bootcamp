#!/usr/bin/env bash
set -euo pipefail
if [ -f .env ]; then source .env; elif [ -f config/.env ]; then source config/.env; elif [ -f config/env.sample ]; then source config/env.sample; fi

: "${LOCATION:=eastus}"
: "${PREFIX:=hlthwrk}"

RG="${PREFIX}-rg"
ANF_ACC="${PREFIX}anfacct"
ANF_POOL="${PREFIX}anfpool"
ANF_VOL="${PREFIX}anfvol"
VNET="${PREFIX}-vnet"
SUBNET_ANF="${PREFIX}-snet-anf"

echo "==> Register provider (may require permissions)"
az provider register --namespace Microsoft.NetApp >/dev/null || true

echo "==> Create ANF account"
az netappfiles account create -g "$RG" -a "$ANF_ACC" -l "$LOCATION"

echo "==> Create capacity pool (Standard, 4TiB)"
az netappfiles pool create -g "$RG" -a "$ANF_ACC" -p "$ANF_POOL" -l "$LOCATION" --size 4 --service-level Standard

echo "==> Create NFS volume (100 GiB)"
az netappfiles volume create -g "$RG" -a "$ANF_ACC" -p "$ANF_POOL" -v "$ANF_VOL" -l "$LOCATION"   --usage-threshold 100 --file-path "$ANF_VOL" --vnet "$VNET" --subnet "$SUBNET_ANF" --protocol-types NFSv3

echo "==> Show mount path"
az netappfiles volume show -g "$RG" -a "$ANF_ACC" -p "$ANF_POOL" -v "$ANF_VOL" --query "mountTargets[0].ipAddress" -o tsv
