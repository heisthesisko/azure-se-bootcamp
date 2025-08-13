#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y python3 python3-pip
pip3 install scikit-learn pandas numpy

# Optional lightweight k8s (microk8s)
sudo snap install microk8s --classic
sudo usermod -a -G microk8s $USER
sudo microk8s status --wait-ready

sudo mkdir -p /opt/arc
sudo cp app/ai/readmission_model.py /opt/arc/readmission_model.py || true
echo "AI server ready. Run: python3 /opt/arc/readmission_model.py"
