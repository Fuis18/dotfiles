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
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========== Applications =========="
echo -e "${BLUE} =================================="
echo ""

# multimedia
pacman -S --noconfirm gimp inkscape blender
pacman -S --noconfirm obs-studio kdenlive

pacman -S --noconfirm muse # musescore

pacman -S --noconfirm discord

sudo -u fuis18 bash -c 'paru -S cmatrix-git'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ======== READY Personal 3 ========"
echo -e "${BLUE} =================================="
echo -e "${RESET}"
echo ""
echo ""
echo ""