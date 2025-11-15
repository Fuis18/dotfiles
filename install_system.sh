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
echo -e "${GREEN}====== Updating the System ======="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -Syu --noconfirm

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN}===== Installing Base System ====="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm base base-devel xdg-desktop-portal wayland hyprland hyprlock

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN}====== Installing Terminal ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm kitty zsh starship zsh-syntax-highlighting zsh-autosuggestions

pacman -S --noconfirm bat lsd fzf gnu-free-fonts

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN}=== Instalando el documentador ==="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm locate man-db man-pages-es

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN}===== Network Configuration ====="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

systemctl enable NetworkManager
systemctl start NetworkManager

pacman -S --noconfirm wpa_supplicant bluez bluez-utils

systemctl enable wpa_supplicant
systemctl start wpa_supplicant
systemctl enable bluetooth
systemctl start bluetooth

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN}======== Essential tools ========"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm yazi lf
pacman -S --noconfirm brightnessctl wl-clipboard btop swaync libnotify
pacman -S --noconfirm curl unzip wget

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN}==== Multimedia applications ===="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm pipewire pipewire-pulse pipewire-alsa

systemctl --user enable pipewire pipewire-pulse wireplumber

pacman -S --noconfirm cava mpd mpv ncmpcpp

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN}====== Captura de Pantalla ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm grim slurp swappy

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN}======== Logo Arch Linux ========"
echo -e "${BLUE}                .         "
echo -e "                      / \\       "
echo -e "                     /   \\      "
echo -e "                    /\    \\     "
echo -e "                   /  \    \\    "
echo -e "                  /         \\   "
echo -e "                 /    .-.    \\  "
echo -e "                /    |   |   _\\ "
echo -e "               /   _.'   '._   \\"
echo -e "              /_.-'         '-._\\"
echo -e "${RESET}"

pacman -S --noconfirm fastfetch

echo ""
echo -e "${BLUE} ================================"
echo -e "${GREEN}=== Configurando el terminal ==="
echo -e "${BLUE} ================================"
echo -e "${RESET}"

PLUGIN_DIR="/usr/share/zsh-sudo"
mkdir -p "${PLUGIN_DIR}"
chown -R "${USER_NAME}:${USER_NAME}" "${PLUGIN_DIR}"
sudo -u "${USER_NAME}" wget -qO "${PLUGIN_DIR}/sudo.plugin.zsh" \
  https://raw.githubusercontent.com/hcgraf/zsh-sudo/master/sudo.plugin.zsh

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN}==== Instalando Login Manager ===="
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
echo -e "${GREEN}=== Instalando el Editor ==="
echo -e "${RESET}"
pacman -S --noconfirm vim neovim

echo ""
echo -e "${BLUE} =============================="
echo -e "${GREEN}========= AUR Helper ========="
echo -e "${BLUE} =============================="
echo -e "${RESET}"
echo ""

echo ""
echo -e "${GREEN}==== Aur => paru ===="
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
echo -e "${GREEN}==== Aur => yay ===="
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
echo -e "${GREEN}=== paru's Dependencies ==="
echo -e "${RESET}"
sudo -u fuis18 bash -c 'paru -S wlogout yofi-bin ironbar-bin scrub'

echo ""
echo -e "${GREEN}=== yay's Dependencies ==="
echo -e "${RESET}"
sudo -u fuis18 bash -c 'yay -S swayimg'

echo ""
echo -e "${GREEN}==== Copiying Root Files ===="
echo -e "${RESET}"

cp -r "${FUIS_REPO}/root/config/." /root/.config/

cp -r "${FUIS_REPO}/root/zshrc" /root/
# Renombrar
mv /root/zshrc /root/.zshrc

echo ""
echo -e "${GREEN}==== Copiying My Files ===="
echo -e "${RESET}"

cp -r "${FUIS_REPO}/config/." "${USER_HOME}/.config/"
chown -R "${USER_NAME}:${USER_NAME}" "${USER_HOME}/.config"

cp -r "${FUIS_REPO}/zshrc" "${USER_HOME}/"
mv "${USER_HOME}/zshrc" "${USER_HOME}/.zshrc"

find "${USER_HOME}/.config/hypr/scripts/" -type f -name "*.sh" -exec chmod +x {} \;

echo -e "${BLUE} ================================="
echo -e "${GREEN}============= Fonts ============="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

chown -R "${USER_NAME}:${USER_NAME}" "${USER_HOME}/Downloads"

wget -O "${USER_HOME}/Downloads/FiraCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip

unzip "${USER_HOME}/Downloads/FiraCode.zip" -d /usr/share/fonts

fc-cache -fv

echo ""
echo -e "${GREEN}=== Actualizando el Shell ==="
echo -e "${RESET}"

ZSH_PATH="$(command -v zsh || true)"

echo "-> Cambiando shell a zsh..."
usermod --shell "$ZSH_PATH" root
usermod --shell "$ZSH_PATH" "$USER_NAME"

echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN}==== Creating the directories ===="
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