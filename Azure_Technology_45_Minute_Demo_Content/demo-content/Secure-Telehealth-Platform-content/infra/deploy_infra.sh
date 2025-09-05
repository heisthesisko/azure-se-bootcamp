#!/bin/bash
# deploy_infra.sh
# Azure CLI script to deploy Telehealth solution

RG=$1
LOC=$2

az group create -n $RG -l $LOC
az deployment group create -g $RG -f main.bicep -p location=$LOC clusterName=telehealth-aro
