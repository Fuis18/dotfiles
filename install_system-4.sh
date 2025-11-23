#!/bin/bash

# Manejo de errores
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Use sudo, need the root"
    exit 1
fi

USER_NAME="fuis18"
USER_HOME="/home/${USER_NAME}"
USER_REPOS="${USER_HOME}/Downloads/repos"
FUIS_REPO="${USER_REPOS}/fuis18/dotfiles"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ======= Copiying My Files ======="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

cp -r "${FUIS_REPO}/config/." "${USER_HOME}/.config/"
chown -R "${USER_NAME}:${USER_NAME}" "${USER_HOME}/.config"

cp -r "${FUIS_REPO}/zshrc" "${USER_HOME}/"
mv "${USER_HOME}/zshrc" "${USER_HOME}/.zshrc"

find "${USER_HOME}/.config/hypr/scripts/" -type f -name "*.sh" -exec chmod +x {} \;

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ==== Creating the directories ===="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

mkdir -p "${USER_HOME}/Documents"
mkdir -p "${USER_HOME}/Music"
mkdir -p "${USER_HOME}/Pictures"

echo ""
echo -e "${BLUE}=================================="
echo -e "${GREEN}============= READY! ============="
echo -e "${BLUE}=================================="
echo ""
echo ""
echo ""
echo ""
reboot