#!/usr/bin/env bash
# scripts/onprem_ai_server_init.sh - Prepare Python AI environment
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y python3 python3-pip
pip3 install --user numpy pandas pillow
echo "AI server initialized with basic Python libraries."
