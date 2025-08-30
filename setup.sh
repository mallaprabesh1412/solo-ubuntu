#!/data/data/com.termux/files/usr/bin/bash
clear

# BIG SOLO ASCII banner
echo " "
echo "  ███████╗ ██████╗ ██╗     ██╗      ██████╗ "
echo "  ██╔════╝██╔═══██╗██║     ██║     ██╔═══██╗"
echo "  █████╗  ██║   ██║██║     ██║     ██║   ██║"
echo "  ██╔══╝  ██║   ██║██║     ██║     ██║   ██║"
echo "  ██║     ╚██████╔╝███████╗███████╗╚██████╔╝"
echo "  ╚═╝      ╚═════╝ ╚══════╝╚══════╝ ╚═════╝"
echo " "
echo "           🚀 SOLO Ubuntu Installer 🚀"
echo " "

sleep 2

# Update Termux & install dependencies
echo "[SOLO] Updating Termux packages..."
yes | pkg update -y && pkg upgrade -y
pkg install proot-distro wget git pulseaudio nano curl -y

# Install Ubuntu (22.04 LTS)
echo "[SOLO] Installing Ubuntu 22.04..."
proot-distro install ubuntu-22.04

# Setup inside Ubuntu
echo "[SOLO] Setting up Ubuntu environment..."
proot-distro login ubuntu-22.04 -- bash -c "
apt update && apt upgrade -y &&
apt install sudo lxde-core lxterminal tigervnc-standalone-server tigervnc-common firefox-esr wget curl -y && \
echo '[SOLO] Creating your user account...' && \
read -p 'Enter your Ubuntu username (lowercase, no spaces): ' user && \
adduser --disabled-password --gecos '' \$user && \
echo '\$user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
passwd \$user && \
echo '[SOLO] Now set your VNC password:' && \
su - \$user -c 'mkdir -p ~/.vnc && vncpasswd' && \
su - \$user -c 'vncserver :1 -geometry 1280x720 -depth 24' && \
wget https://github.com/VSCodium/vscodium/releases/download/1.88.2.23196/codium_1.88.2.23196-1_arm64.deb && \
apt install ./codium_1.88.2.23196-1_arm64.deb -y && rm codium_1.88.2.23196-1_arm64.deb &&
echo '[SOLO] ✅ Setup done inside Ubuntu!'"

# Create solo-start shortcut
echo "[SOLO] Creating shortcut command 'solo-start'..."
cat > $PREFIX/bin/solo-start <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
echo "[SOLO] Starting Ubuntu and VNC..."
proot-distro login ubuntu-22.04 -- bash -c "
su - \$(ls /home) -c 'vncserver :1 -geometry 1280x720 -depth 24' &&
echo '[SOLO] VNC running at 127.0.0.1:5901' &&
bash"
EOF
chmod +x $PREFIX/bin/solo-start

# Create solo-stop shortcut
echo "[SOLO] Creating shortcut command 'solo-stop'..."
cat > $PREFIX/bin/solo-stop <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
echo "[SOLO] Stopping VNC server..."
proot-distro login ubuntu-22.04 -- bash -c "su - \$(ls /home) -c 'vncserver -kill :1'"
echo "[SOLO] Ubuntu + VNC stopped."
EOF
chmod +x $PREFIX/bin/solo-stop

# Final SOLO banner
clear
echo " "
echo " ███████╗ ██████╗ ██╗     ██╗      ██████╗ "
echo " ██╔════╝██╔═══██╗██║     ██║     ██╔═══██╗"
echo " █████╗  ██║   ██║██║     ██║     ██║   ██║"
echo " ██╔══╝  ██║   ██║██║     ██║     ██║   ██║"
echo " ██║     ╚██████╔╝███████╗███████╗╚██████╔╝"
echo " ╚═╝      ╚═════╝ ╚══════╝╚══════╝ ╚═════╝"
echo " "
echo "[SOLO] 🎉 Ubuntu with LXDE, Firefox, and VSCodium is installed!"
echo "[SOLO] Run 'solo-start' in Termux to start Ubuntu + VNC."
echo "[SOLO] Run 'solo-stop' to stop the VNC server."
echo "[SOLO] Open VNC Viewer → connect to 127.0.0.1:5901"
echo " "
￼Enter
