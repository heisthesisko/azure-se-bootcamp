#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y python3 python3-pip
pip3 install -r app/ai/requirements.txt
python3 app/ai/train.py
nohup python3 app/ai/app.py >/var/log/ai_service.log 2>&1 &
echo "AI service running on port 5000."
