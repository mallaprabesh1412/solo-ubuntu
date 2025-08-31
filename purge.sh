#!/bin/bash

# Colors
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')"

banner() {
    clear
    printf "\033[33m   _____   ____  _       ____   \033[0m\n"
    printf "\033[36m  / ____| / __ \| |     |  _ \  \033[0m\n"
    printf "\033[32m | (___  | |  | | |     | |_) | \033[0m\n"
    printf "\033[32m  \___ \ | |  | | |     |  _ <  \033[0m\n"
    printf "\033[36m  ____) || |__| | |____ | |_) | \033[0m\n"
    printf "\033[33m |_____/  \____/|______||____/  \033[0m\n"
    printf "\033[0m\n"
    printf "     \033[32mSOLO Ubuntu — Purge Utility\033[0m\n"
    printf "\033[0m\n"
}

purge() {
    echo -e "${R} [${W}-${R}]${C} Removing SOLO Ubuntu...${W}"

    proot-distro remove ubuntu && proot-distro clear-cache
    rm -rf $PREFIX/bin/solo
    sed -i '/pulseaudio --start --exit-idle-time=-1/d' ~/.sound
    sed -i '/pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1/d' ~/.sound

    echo -e "${R} [${W}-${R}]${G} SOLO Ubuntu has been completely purged.${W}"
}

banner
echo -ne "${Y}Are you sure you want to REMOVE SOLO Ubuntu? (y/N): ${W}"
read choice

case "$choice" in
    y|Y|yes|YES)
        purge
        ;;
    *)
        echo -e "${R} [${W}-${R}]${C} Cancelled. SOLO Ubuntu is safe.${W}"
        ;;
esac
￼Enter
