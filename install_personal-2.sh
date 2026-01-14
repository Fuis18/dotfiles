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
echo -e "${GREEN} ========== Development =========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm github-cli

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========== Operations =========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

# programación
pacman -S --noconfirm docker docker-compose docker-buildx

sudo -u fuis18 bash -c 'paru -S oxker-bin'

systemctl enable docker.socket
systemctl start docker.socket

sudo usermod -aG docker $USER_NAME

# ofimatica
sudo -u fuis18 bash -c 'paru -S obsidian-bin'
sudo -u fuis18 bash -c 'paru -S onlyoffice-bin'
sudo pacman -S libreoffice-fresh

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ======== READY Personal 2 ========"
echo -e "${BLUE} =================================="
echo -e "${RESET}"
echo ""
echo ""
echo ""
