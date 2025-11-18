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
echo -e "${BLUE} =================================="
echo -e "${GREEN} =========== AUR Helper ==========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"
echo ""

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ========== Aur => paru =========="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

PARU_DIR="${USER_REPOS}/paru-bin"
if [[ -d "$PARU_DIR" ]]; then
  echo -e "${GREEN}[!] Directorio '$PARU_DIR' ya existe.${RESET}"
  else
  git clone https://aur.archlinux.org/paru-bin.git "$PARU_DIR"
  chown -R "${USER_NAME}:${USER_NAME}" "$PARU_DIR"
  sudo -u "${USER_NAME}" bash -c "cd '$PARU_DIR' && makepkg -si --noconfirm"
fi

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} =========== Aur => yay ==========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

YAY_DIR="${USER_REPOS}/yay"
if [[ -d "$YAY_DIR" ]]; then
  echo -e "${GREEN}[!] Directorio '$YAY_DIR' ya existe.${RESET}"
  else
  git clone https://aur.archlinux.org/yay.git "$YAY_DIR"
  chown -R "${USER_NAME}:${USER_NAME}" "$YAY_DIR"
  sudo -u "${USER_NAME}" bash -c "cd '$YAY_DIR' && makepkg -si --noconfirm"
fi

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ====== paru's Dependencies ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

sudo -u fuis18 bash -c 'paru -S wlogout yofi-bin ironbar-bin scrub bluetui'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ======= yay's Dependencies ======="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

sudo -u fuis18 bash -c 'yay -S swayimg'

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
echo -e "${BLUE}=================================="
echo -e "${GREEN}============= READY! ============="
echo -e "${BLUE}=================================="
echo ""
echo ""
echo ""
echo ""
reboot