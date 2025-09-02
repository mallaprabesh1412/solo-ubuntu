#!/bin/bash
# Configure user inside Solo Ubuntu

set -e

echo "[+] Updating packages inside Ubuntu..."
apt update -y && apt upgrade -y

echo "[+] Installing basics..."
apt install -y sudo wget curl nano git net-tools

echo "[+] Adding user 'solo'..."
useradd -m -s /bin/bash solo || true
echo "solo:solo" | chpasswd
usermod -aG sudo solo

echo "[+] Default user set to 'solo' (password: solo)"
echo "Run: su - solo"
