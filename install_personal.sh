#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Use sudo, need the root"
    exit 1
fi

USER_NAME="fuis18"
USER_HOME="/home/${USER_NAME}"
USER_REPOS="${USER_HOME}/Desktop/repos"
FUIS_REPO="${USER_REPOS}/fuis18/dotfiles"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo ""
echo -e "${BLUE}=============================="
echo -e "${GREEN}==== Instalacion Personal ===="
echo -e "${BLUE}=============================="
echo ""

echo ""
echo -e "${GREEN}==== Actualizando el sistema ===="
echo -e "${RESET}"
pacman -Syu --noconfirm


echo ""
echo -e "${GREEN}=== Instalando el Editor ==="
echo -e "${RESET}"
pacman -S --noconfirm vim neovim

echo ""
echo -e "${BLUE}======================================"
echo -e "${GREEN}==== Herramientas de Programación ===="
echo -e "${BLUE}======================================"
echo -e "${RESET}"
pacman -S --noconfirm docker docker-compose nodejs npm
sudo usermod -aG docker $USER

echo ""
echo -e "${BLUE}=========================="
echo -e "${GREEN}==== Logo Arch Linux ===="
echo -e "${BLUE}"
echo -e "         ."
echo -e "        / \\"
echo -e "       /   \\"
echo -e "      /\    \\"
echo -e "     /  \    \\"
echo -e "    /         \\"
echo -e "   /    .-.    \\"
echo -e "  /    |   |   _\\"
echo -e " /   _.'   '._   \\"
echo -e "/_.-'         '-._\\"
echo -e "${RESET}"
pacman -S --noconfirm fastfetch

echo ""
echo -e "${GREEN}=== paru's Dependencies ==="
echo -e "${RESET}"
sudo -u fuis18 bash -c 'paru -S ueberzugpp scrub cmatrix-git'


echo ""
echo -e "${GREEN}=== yay's Dependencies ==="
echo -e "${RESET}"
sudo -u fuis18 bash -c 'yay -S librewolf-bin'

echo ""
echo -e "${GREEN}==== Other Pluggins ===="
echo -e "${RESET}"
pacman -S --noconfirm discord gimp inkscape

echo ""
echo -e "${BLUE}===================================="
echo -e "${GREEN}==== Agreegando Customizaciones ===="
echo -e "${BLUE}===================================="
echo -e "${RESET}"

# Wallpapaers

echo "==== Fonts ===="
mkdir -p "${USER_HOME}/Downloads"
chown -R "${USER_NAME}:${USER_NAME}" "${USER_HOME}/Downloads"
wget -O "${USER_HOME}/Downloads/FiraCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
cd /usr/share/fonts
unzip "${USER_HOME}/Downloads/FiraCode.zip"
fc-cache -fv

git clone https://github.com/NvChad/starter ~/.config/nvim
# sudo -u "${USER_NAME}" nvim --headless +MasonInstallAll +qall

echo ""
echo -e "${BLUE}========================"
echo -e "${GREEN}==== Agreegando Red ===="
echo -e "${BLUE}========================"
echo -e "${RESET}"

sudo pacman -S cifs-utils
smbclient -L //192.168.0.3 -U 'DESKTOP-EE2OA6G\usuario'
sudo mkdir -p /mnt/web

echo "//192.168.0.3/Web /mnt/web -o username=usuario,password=luis18,domain=DESKTOP-EE2OA6G,vers=3.0,uid=$(id -u),gid=$(id -g),file_mode=0777,dir_mode=0777" >> /etc/fstab

sudo mount -a

echo ""
echo -e "${BLUE}=================================="
echo -e "${GREEN}============= READY! ============="
echo -e "${BLUE}=================================="
echo ""
echo ""
echo ""
echo ""
reboot
