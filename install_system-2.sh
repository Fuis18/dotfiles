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
echo -e "${BLUE} =================================="
echo -e "${GREEN} ====== Updating the System ======="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -Syu --noconfirm

echo ""
echo -e "${BLUE} ================================"
echo -e "${GREEN} === Configurando el terminal ==="
echo -e "${BLUE} ================================"
echo -e "${RESET}"

PLUGIN_DIR="/usr/share/zsh-sudo"
mkdir -p "${PLUGIN_DIR}"
chown -R "${USER_NAME}:${USER_NAME}" "${PLUGIN_DIR}"
sudo -u "${USER_NAME}" wget -qO "${PLUGIN_DIR}/sudo.plugin.zsh" \
  https://raw.githubusercontent.com/hcgraf/zsh-sudo/master/sudo.plugin.zsh

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ==== Instalando Login Manager ===="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm greetd greetd-tuigreet

if id greeter &>/dev/null; then
    echo "✔ El usuario greeter ya existe. Continuando..."
else
    useradd -r -s /usr/bin/nologin -d /var/lib/greetd -M greeter
fi

cp -r "${FUIS_REPO}/etc/greetd/." /etc/greetd/

chmod 644 /etc/greetd/config.toml
systemctl enable greetd

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ====== Copiying Root Files ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

cp -r "${FUIS_REPO}/root/config/." /root/.config/

cp -r "${FUIS_REPO}/root/zshrc" /root/
# Renombrar
mv /root/zshrc /root/.zshrc

echo -e "${BLUE} ================================="
echo -e "${GREEN} ============= Fonts ============="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

chown -R "${USER_NAME}:${USER_NAME}" "${USER_HOME}/Downloads"

wget -O "${USER_HOME}/Downloads/FiraCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip

unzip "${USER_HOME}/Downloads/FiraCode.zip" -d /usr/share/fonts

pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-liberation

fc-cache -fv

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ===== Actualizando el Shell ====="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

ZSH_PATH="$(command -v zsh || true)"

echo "-> Cambiando shell a zsh..."
usermod --shell "$ZSH_PATH" root
usermod --shell "$ZSH_PATH" "$USER_NAME"

echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ==== Creating the directories ===="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

mkdir -p "${USER_HOME}/Documents"
chown "${USER_NAME}:${USER_NAME}" "${USER_HOME}/Documents"
mkdir -p "${USER_HOME}/Music"
chown "${USER_NAME}:${USER_NAME}" "${USER_HOME}/Music"
mkdir -p "${USER_HOME}/Images"
chown "${USER_NAME}:${USER_NAME}" "${USER_HOME}/Images"
mkdir -p "${USER_HOME}/Scripts"
chown "${USER_NAME}:${USER_NAME}" "${USER_HOME}/Scripts"

echo ""
echo -e "${BLUE}=================================="
echo -e "${GREEN}============= READY! ============="
echo -e "${BLUE}=================================="
echo -e "${RESET}"
echo ""
echo ""
echo ""
sudo bash "${FUIS_REPO}/install_system-3.sh"