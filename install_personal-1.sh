#!/bin/bash

# Manejo de errores
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Use sudo, need the root"
    exit 1
fi

USER_NAME="fuis18"
USER_HOME="/home/${USER_NAME}"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ====== Updating the System ======="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -Syu --noconfirm

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ==== Multimedia applications ===="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm gst-libav gst-plugins-good gst-plugins-bad gst-plugins-ugly
pacman -S --noconfirm pipewire pipewire-pulse wireplumber
pacman -S --noconfirm pipewire-alsa alsa-utils
pacman -S --noconfirm mpd mpc mpv ncmpcpp fftw lsp-plugins-lv2
pacman -S --noconfirm pulsemixer cava easyeffects rubberband

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ====== Captura de Pantalla ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm grim slurp swappy

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ======== Logo Arch Linux ========"
echo -e "${BLUE}         .         "
echo -e "               / \\       "
echo -e "              /   \\      "
echo -e "             /\    \\     "
echo -e "            /  \    \\    "
echo -e "           /         \\   "
echo -e "          /    .-.    \\  "
echo -e "         /    |   |   _\\ "
echo -e "        /   _.'   '._   \\"
echo -e "       /_.-'         '-._\\"
echo -e "${RESET}"

pacman -S --noconfirm fastfetch

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ====== Instalando el Editor ======"
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm vim neovim

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========== Applications =========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

# browsers
sudo -u fuis18 bash -c 'yay -S librewolf-bin brave-bin'

sudo pacman -S --noconfirm syncthing
sudo pacman -S --noconfirm rclone

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ======== READY Personal 1 ========"
echo -e "${BLUE} =================================="
echo -e "${RESET}"
echo ""
echo ""
echo ""