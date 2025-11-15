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
echo -e "${GREEN}====== Updating the System ======="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -Syu --noconfirm

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN}========== Applications =========="
echo -e "${BLUE} =================================="
echo ""

# programación
pacman -S --noconfirm docker docker-compose nodejs npm

sudo usermod -aG docker $USER_NAME

# multimedia
pacman -S --noconfirm gimp inkscape blender

# browsers
sudo -u fuis18 bash -c 'yay -S librewolf-bin brave-bin'

sudo pacman -S libreoffice-still
sudo -u fuis18 bash -c 'yay -S onlyoffice-bin'
sudo -u fuis18 bash -c 'yay -S obsidian'

sudo -u fuis18 bash -c 'yay -S cmatrix-git'

pacman -S --noconfirm discord

sudo pacman -S --noconfirm syncthing
sudo pacman -S --noconfirm rclone

systemctl --user enable --now syncthing.service

# agregar música
# wallpapaers

echo ""
echo -e "${BLUE}=================================="
echo -e "${GREEN}============= READY! ============="
echo -e "${BLUE}=================================="
echo ""
echo ""
echo ""
echo ""
reboot