#!/data/data/com.termux/files/usr/bin/bash
# install-ubuntu.sh — Termux Ubuntu + XFCE + VNC + Dev Tools bootstrapper

set -euo pipefail

# -----------------------------
# Colors & Logging
# -----------------------------
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RESET="\033[0m"

ok()   { echo -e "${GREEN}[OK]${RESET} $*"; }
info() { echo -e "${BLUE}[INFO]${RESET} $*"; }
warn() { echo -e "${YELLOW}[WARN]${RESET} $*"; }
err()  { echo -e "${RED}[ERROR]${RESET} $*"; }

trap 'err "Installer exited unexpectedly. Check the logs above."' EXIT

# -----------------------------
# Pre-flight checks
# -----------------------------
if [[ -z "${PREFIX:-}" || "$PREFIX" != "/data/data/com.termux/files/usr" ]]; then
  err "This script must be run inside Termux on Android."
  exit 1
fi

# Make sure we have network
if ! ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1; then
  warn "Network check failed, continuing anyway… make sure you’re online."
fi

# -----------------------------
# Update Termux & install deps
# -----------------------------
info "Updating Termux packages…"
yes | pkg update -y || true
yes | pkg upgrade -y || true
ok "Termux updated."

info "Installing required Termux packages…"
pkg install -y proot-distro wget curl git nano unzip || {
  err "Failed to install Termux dependencies."
  exit 1
}
ok "Termux dependencies installed."

# -----------------------------
# Install Ubuntu via proot-distro
# -----------------------------
if proot-distro list | grep -qE '^\* ubuntu'; then
  info "Ubuntu proot-distro already installed. Skipping install."
else
  info "Installing Ubuntu (proot-distro)…"
  proot-distro install ubuntu
  ok "Ubuntu installed."
fi

# -----------------------------
# Bootstrap inside Ubuntu
# -----------------------------
info "Configuring Ubuntu environment (this may take a bit)…"

# Build the inner bootstrap script
UBUNTU_BOOTSTRAP=$(cat <<'EOS'
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
echo "[Ubuntu] Updating APT…"
apt-get update -y
apt-get upgrade -y

echo "[Ubuntu] Installing core packages, XFCE, VNC, and utilities…"
apt-get install -y \
  xfce4 xfce4-goodies tightvncserver dbus-x11 x11-xserver-utils xfonts-base \
  wget curl git nano unzip \
  software-properties-common apt-transport-https gnupg ca-certificates

# ---------- VS Code (Microsoft repo) ----------
echo "[Ubuntu] Setting up Microsoft repo for VS Code…"
ARCH="$(dpkg --print-architecture)"
install -d -m 0755 /usr/share/keyrings
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/packages.microsoft.gpg
echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
  > /etc/apt/sources.list.d/vscode.list

# ---------- Firefox (Mozilla Team PPA — non-Snap) ----------
echo "[Ubuntu] Adding Mozilla Team PPA for Firefox (non-Snap)…"
add-apt-repository -y ppa:mozillateam/ppa

# Pin PPA high so apt prefers deb over Snap transition package
cat >/etc/apt/preferences.d/mozillateam-firefox <<'EOF'
Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 501
EOF

apt-get update -y

echo "[Ubuntu] Installing VS Code, Firefox, and essentials…"
# code = Visual Studio Code; firefox from PPA; build-essential for dev
apt-get install -y code firefox build-essential

# ---------- VNC configuration ----------
echo "[Ubuntu] Configuring TightVNC for XFCE…"
# Create default VNC password if not set (password: termux)
if [ ! -f "$HOME/.vnc/passwd" ]; then
  mkdir -p "$HOME/.vnc"
  printf "termux\ntermux\nn\n" | vncpasswd
fi

# Create modern xstartup
mkdir -p "$HOME/.vnc"
cat >"$HOME/.vnc/xstartup" <<'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x "$HOME/.vnc/xstartup"

# Set VNC default geometry
cat >"$HOME/.vnc/config" <<'EOF'
geometry=1280x720
localhost
EOF

# Ensure locales — best effort, not fatal
if command -v locale-gen >/dev/null 2>&1; then
  sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen || true
  locale-gen || true
fi

echo "[Ubuntu] Bootstrap complete."
EOS
)

# Feed the script into Ubuntu
proot-distro login ubuntu -- bash -lc "cat > /root/.termux-ubuntu-bootstrap.sh <<'INNERSH'\n${UBUNTU_BOOTSTRAP}\nINNERSH\nbash /root/.termux-ubuntu-bootstrap.sh && rm -f /root/.termux-ubuntu-bootstrap.sh"
ok "Ubuntu configured."

# -----------------------------
# Create the ubuntu-vnc launcher
# -----------------------------
info "Creating custom launcher: ubuntu-vnc …"

LAUNCHER_PATH="$PREFIX/bin/ubuntu-vnc"
cat > "$LAUNCHER_PATH" <<'EOS'
#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Colors
GREEN="\033[1;32m"; RED="\033[1;31m"; BLUE="\033[1;34m"; RESET="\033[0m"
say_ok(){ echo -e "${GREEN}[OK]${RESET} $*"; }
say_info(){ echo -e "${BLUE}[INFO]${RESET} $*"; }
say_err(){ echo -e "${RED}[ERROR]${RESET} $*"; }

# Start Ubuntu and launch VNC server on :1 (port 5901)
proot-distro login ubuntu -- bash -lc '
set -e
export DISPLAY=:1
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Ensure VNC password exists (default: termux)
if [ ! -f "$HOME/.vnc/passwd" ]; then
  printf "termux\ntermux\nn\n" | vncpasswd
fi

# Respect config (geometry in ~/.vnc/config)
vncserver -kill :1 >/dev/null 2>&1 || true
vncserver :1
echo
echo -e "\033[1;32m[OK]\033[0m Ubuntu VNC started on \033[1mlocalhost:5901\033[0m"
echo "Tip: To stop the server later: vncserver -kill :1"
echo "       To change the VNC password inside Ubuntu: vncpasswd"
echo
bash --login
' || { say_err "Failed to start ubuntu-vnc."; exit 1; }

say_ok "ubuntu-vnc session ended."
EOS

chmod +x "$LAUNCHER_PATH"
ok "Launcher created at $LAUNCHER_PATH"

# -----------------------------
# Final Instructions
# -----------------------------
trap - EXIT
echo
ok "All done!"
cat <<'EONOTE'

How to use:

1) Start Ubuntu + VNC:
     ubuntu-vnc

   - This boots into Ubuntu, starts TightVNC on display :1 (port 5901),
     and drops you into a root shell inside Ubuntu.
   - Default VNC password (first run auto-set): termux
     (Change it inside Ubuntu with: vncpasswd)

2) Connect with a VNC client:
     Host: localhost
     Port: 5901
     Address: localhost:5901
     Resolution: 1280x720

3) Stop the VNC server (inside Ubuntu shell):
     vncserver -kill :1

Developer tools installed inside Ubuntu:
  - VS Code:       code
  - Firefox:       firefox
  - Git:           git
  - Curl:          curl
  - Build tools:   build-essential
  - Editor:        nano

Pro tips:
  - If code or firefox fail to launch the first time, start them from a terminal
    inside the VNC session to see logs.
  - You can tweak resolution by editing ~/.vnc/config (geometry=WIDTHxHEIGHT).
EONOTE
