#!/usr/bin/env bash
# Run on the AI VM after SSH (sudo)
set -euo pipefail

# Install Python and deps
if command -v dnf >/dev/null 2>&1; then
  dnf -y update
  dnf -y install python39 python39-pip
elif command -v yum >/dev/null 2>&1; then
  yum -y update
  yum -y install python39 python39-pip
fi

/usr/bin/pip3 install --upgrade pip
/usr/bin/pip3 install tensorflow flask pillow

# Create app dir and copy files from ~/
mkdir -p /home/azureuser/ai_model
if [[ -f ~/ai_model.py ]]; then
  mv ~/ai_model.py /home/azureuser/ai_model/
fi
chown -R azureuser:azureuser /home/azureuser/ai_model

# Install systemd service if provided
if [[ -f ~/ai_model.service ]]; then
  mv ~/ai_model.service /etc/systemd/system/ai_model.service
fi

# Default service if missing
if [[ ! -f /etc/systemd/system/ai_model.service ]]; then
cat >/etc/systemd/system/ai_model.service <<'SERV'
[Unit]
Description=AI Model Flask Service
After=network.target

[Service]
User=azureuser
WorkingDirectory=/home/azureuser/ai_model
ExecStart=/usr/bin/python3 /home/azureuser/ai_model/ai_model.py
Restart=always

[Install]
WantedBy=multi-user.target
SERV
fi

systemctl daemon-reload
systemctl enable ai_model
systemctl restart ai_model

echo "AI service installed and started on port 5000."
