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
echo -e "${BLUE} =================================="
echo -e "${GREEN} ===== Installing Base System ====="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm base base-devel wayland hyprland hyprlock

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
echo -e "${BLUE} ==============================="
echo -e "${GREEN} ====== System Defatuls ======"
echo -e "${BLUE} ==============================="
echo -e "${RESET}"

pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
pacman -S --noconfirm papirus-icon-theme

sudo -u fuis18 bash -c 'yay -S papirus-folders-catppuccin-git catppuccin-gtk-theme-mocha'

papirus-folders -C catppuccin-mocha --theme Papirus-Dark

gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

sudo -u fuis18 bash -c 'paru -S wlogout yofi-bin'
sudo -u fuis18 bash -c 'paru -S ironbar-bin scrub bluetui'

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ====== Installing Terminal ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm kitty zsh starship zsh-syntax-highlighting zsh-autosuggestions

pacman -S --noconfirm bat lsd fzf gnu-free-fonts

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} === Instalando el documentador ==="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm locate man-db

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ======== Essential tools ========"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm brightnessctl wl-clipboard btop swaync libnotify
pacman -S --noconfirm curl unzip wget lm_sensors
pacman -S --noconfirm yazi

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} =========== Lenguages ==========="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

LOCALES=("de_DE.UTF-8" "en_US.UTF-8" "es_ES.UTF-8" "ja_JP.UTF-8")

for locale in "${LOCALES[@]}"; do
    sed -i "s/^#(${locale} UTF-8)/\1/" /etc/locale.gen
done

locale-gen

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ===== Network Configuration ====="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

systemctl enable NetworkManager
systemctl start NetworkManager

pacman -S --noconfirm wpa_supplicant bluez bluez-utils dbus

systemctl enable wpa_supplicant
systemctl start wpa_supplicant
systemctl enable bluetooth
systemctl start bluetooth


echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ==== Multimedia applications ===="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm gst-libav gst-plugins-good gst-plugins-bad gst-plugins-ugly
pacman -S --noconfirm pipewire pipewire-pulse wireplumber
pacman -S --noconfirm pipewire-alsa alsa-utils

pacman -S --noconfirm pulsemixer

pacman -S --noconfirm cava mpd mpc mpv ncmpcpp

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
echo -e "${BLUE}=================================="
echo -e "${GREEN}============= READY! ============="
echo -e "${BLUE}=================================="
echo ""
echo ""
echo ""
echo ""
sudo bash "${FUIS_REPO}/install_system-2.sh"