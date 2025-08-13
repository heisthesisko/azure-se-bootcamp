#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y python3 python3-pip
sudo mkdir -p /opt/ai
sudo cp /vagrant/app/ai/inference.py /opt/ai/inference.py
echo 'Sample content' | sudo tee /opt/ai/sample.png >/dev/null
sudo cp /vagrant/system/ai-api.service /etc/systemd/system/ai-api.service
sudo systemctl daemon-reload
sudo systemctl enable --now ai-api.service
