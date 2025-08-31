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
	EOF
	echo -e "${G}       SOLO Ubuntu — GUI + Dev Tools for Termux\n\n${W}"
}

package() {
	banner
	echo -e "${R}[${W}-${R}]${C} Updating and installing base packages...${W}"
	yes | pkg upgrade
	packs=(git wget curl pulseaudio proot-distro)
	for x in "${packs[@]}"; do
		type -p "$x" &>/dev/null || yes | pkg install "$x" -y
	done
	termux-setup-storage
}

distro() {
	echo -e "\n${R}[${W}-${R}]${C} Checking Ubuntu Distro...${W}"
	if [[ -d "$UBUNTU_DIR" ]]; then
		echo -e "${G}Ubuntu already installed.${W}"
	else
		proot-distro install ubuntu
	fi
}

sound() {
	echo -e "\n${R}[${W}-${R}]${C} Configuring Pulseaudio...${W}"
	[ ! -e "$HOME/.sound" ] && touch "$HOME/.sound"
	{
		echo "pulseaudio --start --exit-idle-time=-1"
		echo "pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1"
	} >> "$HOME/.sound"
}

setup_vnc() {
	downloader "$CURR_DIR/vncstart" "https://raw.githubusercontent.com/mallaprabesh1412/solo-ubuntu/master/distro/vncstart"
	mv -f "$CURR_DIR/vncstart" "$UBUNTU_DIR/usr/local/bin/vncstart"
	chmod +x "$UBUNTU_DIR/usr/local/bin/vncstart"

	downloader "$CURR_DIR/vncstop" "https://raw.githubusercontent.com/mallaprabesh1412/solo-ubuntu/master/distro/vncstop"
	mv -f "$CURR_DIR/vncstop" "$UBUNTU_DIR/usr/local/bin/vncstop"
	chmod +x "$UBUNTU_DIR/usr/local/bin/vncstop"
}

downloader() {
	path="$1"
	[ -e "$path" ] && rm -rf "$path"
	echo "Downloading $(basename $1)..."
	curl --progress-bar --insecure --fail \
		 --retry-connrefused --retry 3 --retry-delay 2 \
		 --location --output ${path} "$2"
}

permission() {
	banner
	echo -e "${R}[${W}-${R}]${C} Setting up environment...${W}"

	# Copy user setup script
	downloader "$CURR_DIR/user.sh" "https://raw.githubusercontent.com/mallaprabesh1412/solo-ubuntu/master/distro/user.sh"
	mv -f "$CURR_DIR/user.sh" "$UBUNTU_DIR/root/user.sh"
	chmod +x $UBUNTU_DIR/root/user.sh

	setup_vnc

	# Make shortcut
	echo "proot-distro login ubuntu" > $PREFIX/bin/solo
	chmod +x "$PREFIX/bin/solo"

	termux-reload-settings

	banner
	cat <<- EOF
		${G}✅ SOLO Ubuntu CLI installed successfully!
		${Y}Restart Termux before continuing.${W}

		${C}Usage:${W}
		${G}- Type ${C}solo${G} to run Ubuntu CLI
		- Inside Ubuntu, run ${C}bash user.sh${G} to configure username + GUI
		- Then use ${C}vncstart${G} / ${C}vncstop${G} to control GUI
		- Connect via VNC Viewer → 127.0.0.1:5901
	EOF
}

package
distro
sound
permission
