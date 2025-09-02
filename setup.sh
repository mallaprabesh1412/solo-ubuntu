#!/data/data/com.termux/files/usr/bin/bash
# SOLO UBUNTU setup script for Termux

set -euo pipefail

PURPLE="\e[1;35m"
GREEN="\e[1;32m"
RESET="\e[0m"

clear
echo -e "$PURPLE"
cat << "EOF"

   ██████   ██████  ██       ██████   ██    ██  ██████  ██████  ██    ██ 
  ██       ██    ██ ██      ██    ██  ██    ██ ██       ██   ██  ██  ██  
  ██   ███ ██    ██ ██      ██    ██  ██    ██ ██   ███ ██████    ████   
  ██    ██ ██    ██ ██      ██    ██   ██  ██  ██    ██ ██   ██    ██    
   ██████   ██████  ███████  ██████     ████    ██████  ██   ██    ██    

                   🚀 Welcome to Solo Ubuntu 🚀

EOF
echo -e "$RESET"

echo -e "${GREEN}[+] Updating Termux packages...${RESET}"
pkg update -y && pkg upgrade -y

echo -e "${GREEN}[+] Installing dependencies...${RESET}"
pkg install -y wget proot tar proot-distro git curl pulseaudio

echo -e "${GREEN}[+] Installing Ubuntu via proot-distro...${RESET}"
proot-distro install ubuntu || true

echo -e "${GREEN}[+] Copying Solo Ubuntu scripts...${RESET}"
mkdir -p ~/solo-ubuntu/distro
cp -r ./distro ~/solo-ubuntu/

echo -e "${GREEN}[+] Installation complete!${RESET}"
echo
echo -e "👉 To start Solo Ubuntu, run:\n"
echo -e "   proot-distro login ubuntu"
echo
echo -e "Inside Ubuntu, run:\n"
echo -e "   bash ~/solo-ubuntu/distro/user.sh"
echo -e "   bash ~/solo-ubuntu/distro/gui.sh"
echo -e "   bash ~/solo-ubuntu/distro/firefox.sh"
echo
echo -e "${PURPLE}🔥 Solo Ubuntu is ready to roll! 🔥${RESET}"
