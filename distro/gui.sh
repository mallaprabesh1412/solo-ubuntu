#!/bin/bash
# Enable GUI with XFCE + VNC in Solo Ubuntu

set -e

echo "[+] Updating apt..."
apt update -y

echo "[+] Installing XFCE desktop and VNC server..."
apt install -y xfce4 xfce4-goodies tightvncserver dbus-x11

echo "[+] Configuring VNC..."
mkdir -p /home/solo/.vnc
cat > /home/solo/.vnc/xstartup <<'EOL'
#!/bin/sh
xrdb $HOME/.Xresources
startxfce4 &
EOL
chmod +x /home/solo/.vnc/xstartup
chown -R solo:solo /home/solo/.vnc

echo "[+] GUI setup complete!"
echo "Use vncstart to launch and vncstop to quit."
