#!/bin/bash
# Install Firefox inside Solo Ubuntu

set -e

echo "[+] Updating apt..."
apt update -y

echo "[+] Installing Firefox browser..."
apt install -y firefox

echo "[+] Firefox installed!"
echo "👉 Run 'firefox' to launch (inside VNC desktop)."
