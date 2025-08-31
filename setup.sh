#!/bin/bash

# Colors
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')"

CURR_DIR=$(realpath "$(dirname "$BASH_SOURCE")")
UBUNTU_DIR="$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu"

banner() {
    clear
    cat <<- EOF
${Y}   ███████╗ ██████╗ ██╗      ██████╗ 
${C}   ██╔════╝██╔═══██╗██║     ██╔═══██╗
${G}   █████╗  ██║   ██║██║     ██║   ██║
${R}   ██╔══╝  ██║   ██║██║     ██║   ██║
${Y}   ██║     ╚██████╔╝███████╗╚██████╔╝
${C}   ╚═╝      ╚═════╝ ╚══════╝ ╚═════╝ 
${W}              POWERED BY SOLO

EOF
    echo -e "${G}>> SOLO Ubuntu GUI Installer for Termux\n"
}

# Install base Termux packages
install_termux_packages() {
    banner
    echo -e "${C}[+] Updating Termux packages...${W}"
    yes | pkg up
    yes | pkg install git wget curl proot-distro pulseaudio x11-repo -y
}

# Install Ubuntu
install_ubuntu() {
    echo -e "${C}[+] Installing Ubuntu...${W}"
    if [[ -d "$UBUNTU_DIR" ]]; then
        echo -e "${G}[✓] Ubuntu already installed.${W}"
    else
        proot-distro install ubuntu
    fi
}

# Configure SOLO command
setup_solo_command() {
    echo "proot-distro login ubuntu" > $PREFIX/bin/solo
    chmod +x $PREFIX/bin/solo
    termux-reload-settings
    echo -e "${G}[✓] SOLO command installed. Type 'solo' to enter Ubuntu.${W}"
}

# Configure sound
fix_sound() {
    [ ! -e "$HOME/.sound" ] && touch "$HOME/.sound"
    grep -qxF "pulseaudio --start --exit-idle-time=-1" ~/.sound || echo "pulseaudio --start --exit-idle-time=-1" >> ~/.sound
    grep -qxF "pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" ~/.sound || echo "pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> ~/.sound
}

# Setup user + VNC inside Ubuntu
setup_inside_ubuntu() {
    proot-distro login ubuntu -- bash -c "
apt update && apt upgrade -y
apt install xfce4 xfce4-goodies tightvncserver dbus-x11 -y
apt install firefox chromium-browser vlc mpv gimp code -y
apt install sudo curl wget git nano neofetch -y

echo 'Setting up your Ubuntu user...'
read -p 'Enter a username: ' USERNAME
useradd -m -s /bin/bash \$USERNAME
passwd \$USERNAME
usermod -aG sudo \$USERNAME

echo 'Setting up your VNC password...'
runuser -l \$USERNAME -c 'vncpasswd'

echo '#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &' > /home/\$USERNAME/.vnc/xstartup
chmod +x /home/\$USERNAME/.vnc/xstartup

echo -e '\n${G}[✓] Ubuntu with GUI installed. Use vncstart/vncstop.${W}'
"
}

# Install vncstart/vncstop scripts
setup_vnc_scripts() {
    cat > $PREFIX/bin/vncstart <<- EOM
#!/bin/bash
pulseaudio --start --exit-idle-time=-1 >/dev/null 2>&1
proot-distro login ubuntu -- runuser -l \$(ls $UBUNTU_DIR/home | head -n1) -c 'vncserver :1 -geometry 1280x720 -depth 24'
echo 'Now open VNC Viewer and connect to localhost:1'
EOM

    cat > $PREFIX/bin/vncstop <<- EOM
#!/bin/bash
proot-distro login ubuntu -- runuser -l \$(ls $UBUNTU_DIR/home | head -n1) -c 'vncserver -kill :1'
EOM

    chmod +x $PREFIX/bin/vncstart
    chmod +x $PREFIX/bin/vncstop
}

# Run everything
banner
install_termux_packages
install_ubuntu
fix_sound
setup_solo_command
setup_inside_ubuntu
setup_vnc_scripts

echo -e "\n${Y}=================================================${W}"
echo -e "${G}SOLO Ubuntu GUI Installed Successfully!"
echo -e "Commands to use:"
echo -e "  -> ${C}solo${W}        : Enter Ubuntu CLI"
echo -e "  -> ${C}vncstart${W}    : Start Ubuntu GUI (localhost:1)"
echo -e "  -> ${C}vncstop${W}     : Stop VNC server"
echo -e "=================================================${W}"
