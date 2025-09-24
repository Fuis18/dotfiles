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
echo -e "${BLUE}======================================"
echo -e "${GREEN}==== Herramientas de Programación ===="
echo -e "${BLUE}======================================"
echo -e "${RESET}"
pacman -S --noconfirm docker docker-compose

curl -fsSL https://bun.sh/install | bash

sudo usermod -aG docker $USER_NAME

echo ""
echo -e "${BLUE}====================================="
echo -e "${GREEN}==== Herramientas de MULTIMEDIA ===="
echo -e "${BLUE}====================================="
echo -e "${RESET}"
pacman -S --noconfirm gimp inkscape blender

echo ""
echo -e "${GREEN}=== paru's Dependencies ==="
echo -e "${RESET}"
sudo -u fuis18 bash -c 'paru -S ueberzugpp scrub'

echo ""
echo -e "${GREEN}=== yay's Dependencies ==="
echo -e "${RESET}"
sudo -u fuis18 bash -c 'yay -S librewolf-bin onlyoffice-bin cmatrix-git'

echo ""
echo -e "${GREEN}==== Other Pluggins ===="
echo -e "${RESET}"
pacman -S --noconfirm discord

echo ""
echo -e "${BLUE}===================================="
echo -e "${GREEN}==== Agreegando Customizaciones ===="
echo -e "${BLUE}===================================="
echo -e "${RESET}"

# Wallpapaers

# ncvim
git clone https://github.com/NvChad/starter ~/.config/nvim
sudo -u "${USER_NAME}" nvim --headless +MasonInstallAll +qall

echo ""
echo -e "${BLUE}========================"
echo -e "${GREEN}==== Agreegando Red ===="
echo -e "${BLUE}========================"
echo -e "${RESET}"

pacman -S cifs-utils
smbclient -L //192.168.0.3 -U 'DESKTOP-EE2OA6G\usuario'
mkdir -p /mnt/web

echo "//192.168.0.3/web /mnt/web cifs username=usuario,password=luis18,domain=DESKTOP-EE2OA6G,vers=3.0,uid=1000,gid=1000,file_mode=0777,dir_mode=0777 0 0" >> /etc/fstab

echo "//192.168.0.3/media /mnt/media cifs username=usuario,password=luis18,domain=DESKTOP-EE2OA6G,vers=3.0,uid=1000,gid=1000,file_mode=0777,dir_mode=0777 0 0" >> /etc/fstab

echo ""
echo -e "${BLUE}=================================="
echo -e "${GREEN}============= READY! ============="
echo -e "${BLUE}=================================="
echo ""
echo ""
echo ""
echo ""
reboot