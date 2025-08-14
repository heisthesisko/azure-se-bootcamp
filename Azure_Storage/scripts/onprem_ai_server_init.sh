#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y python3-pip
pip3 install pycryptodome requests
echo "AI server prepared. Use app/ai/cse_upload.py for client-side encryption uploads."
