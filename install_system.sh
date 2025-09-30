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
echo -e "${BLUE}==============================="
echo -e "${GREEN}==== Instalacion de Sistema ===="
echo -e "${BLUE}==============================="
echo ""

echo ""
echo -e "${GREEN}==== Actualizando el sistema ===="
echo -e "${RESET}"
pacman -Syu --noconfirm

echo ""
echo -e "${BLUE}=================================="
echo -e "${GREEN}==== Instalando paquetes base ===="
echo -e "${BLUE}=================================="
echo -e "${RESET}"
pacman -S --noconfirm base base-devel curl wget unzip xdg-desktop-portal

echo ""
echo -e "${GREEN}=== Instalando el terminal y shell ==="
echo -e "${RESET}"
pacman -S --noconfirm kitty zsh starship zsh-syntax-highlighting zsh-autosuggestions

echo ""
echo -e "${GREEN}=== Instalando el documentador ==="
echo -e "${RESET}"
pacman -S --noconfirm locate man-db man-pages-es

echo ""
echo -e "${GREEN}=== Configurando el terminal ==="
echo -e "${RESET}"
PLUGIN_DIR="/usr/share/zsh-sudo"
mkdir -p "${PLUGIN_DIR}"
chown -R "${USER_NAME}:${USER_NAME}" "${PLUGIN_DIR}"
sudo -u "${USER_NAME}" wget -qO "${PLUGIN_DIR}/sudo.plugin.zsh" \
  https://raw.githubusercontent.com/hcgraf/zsh-sudo/master/sudo.plugin.zsh

echo ""
echo -e "${GREEN}=== Instalando Entorno gráfico ==="
echo -e "${RESET}"
pacman -S --noconfirm wayland hyprland hyprlock

echo ""
echo -e "${GREEN}==== Instalando Login Manager ===="
echo -e "${RESET}"
pacman -S --noconfirm greetd greetd-tuigreet

if id greeter &>/dev/null; then
    echo "✔ El usuario greeter ya existe. Continuando..."
else
    echo "✘ El usuario greeter no existe. Creándolo..."
    useradd -r -s /usr/bin/nologin -d /var/lib/greetd -M greeter
fi

cat > /etc/greetd/config.toml << 'EOF'
[terminal]
vt = 1
[default_session]
command = "tuigreet --time --cmd hyprland --theme 'border=violet;text=cyan;prompt=green;time=cyan;action=green;container=black;input=red' --window-padding 5 --greeting '\n Arch Linux - Login to Hacker \n' --asterisks"
user = "greeter"
EOF

chmod 644 /etc/greetd/config.toml
systemctl enable greetd

echo ""
echo -e "${GREEN}=== Paquetes de Customización  ==="
echo -e "${RESET}"
pacman -S --noconfirm waybar swaync libnotify

echo ""
echo -e "${BLUE}=================================="
echo -e "${GREEN}==== Configuración Multimedia ===="
echo -e "${BLUE}=================================="
echo -e "${RESET}"

pacman -S --noconfirm pipewire pipewire-pulse pipewire-alsa

systemctl --user enable pipewire pipewire-pulse wireplumber

echo ""
echo -e "${BLUE}================================"
echo -e "${GREEN}==== Configuración de Redes ===="
echo -e "${BLUE}================================"
echo -e "${RESET}"

systemctl enable NetworkManager
systemctl start NetworkManager

pacman -S --noconfirm wpa_supplicant bluez bluez-utils

systemctl enable bluetooth
systemctl start bluetooth
sudo systemctl enable wpa_supplicant
sudo systemctl start wpa_supplicant

echo ""
echo -e "${BLUE}============================================="
echo -e "${GREEN}==== Intalación de configuración Interna ===="
echo -e "${BLUE}============================================="
echo -e "${RESET}"
pacman -S --noconfirm brightnessctl smbclient wl-clipboard btop thunar

echo ""
echo -e "${BLUE}==================="
echo -e "${GREEN}==== Multimedia ===="
echo -e "${BLUE}===================="
echo -e "${RESET}"
pacman -S --noconfirm cava mpd mpv ncmpcpp mpc

mkdir -p ~/.config/mpd/playlists

systemctl --user enable --now mpd.service

echo ""
echo -e "${BLUE}============================="
echo -e "${GREEN}==== Captura de Pantalla ===="
echo -e "${BLUE}============================="
echo -e "${RESET}"
pacman -S --noconfirm grim slurp swappy

echo ""
echo -e "${GREEN}=== Instalando el Editor ==="
echo -e "${RESET}"
pacman -S --noconfirm vim neovim

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
echo -e "${BLUE}=============================="
echo -e "${GREEN}==== Paquetes adicionales ===="
echo -e "${BLUE}=============================="
echo -e "${RESET}"
echo ""

echo ""
echo -e "${GREEN}==== Aur => paru ===="
echo -e "${RESET}"
PARU_DIR="${USER_REPOS}/paru-bin"
if [[ -d "$PARU_DIR" ]]; then
echo -e "${GREEN}[!] Directorio '$PARU_DIR' ya existe. Se omite clonación de paru.${RESET}"
else
git clone https://aur.archlinux.org/paru-bin.git "$PARU_DIR"
chown -R fuis18:fuis18 "$PARU_DIR"
sudo -u fuis18 bash -c "cd '$PARU_DIR' && makepkg -si --noconfirm"
fi

echo ""
echo -e "${GREEN}==== Aur => yay ===="
echo -e "${RESET}"
YAY_DIR="${USER_REPOS}/yay"
if [[ -d "$YAY_DIR" ]]; then
 echo -e "${GREEN}[!] Directorio '$YAY_DIR' ya existe. Se omite clonación de yay.${RESET}"
else
git clone https://aur.archlinux.org/yay.git "$YAY_DIR"
chown -R fuis18:fuis18 "$YAY_DIR"
sudo -u fuis18 bash -c "cd '$YAY_DIR' && makepkg -si --noconfirm"
fi

echo ""
echo -e "${GREEN}=== paru's Dependencies ==="
echo -e "${RESET}"
sudo -u fuis18 bash -c 'paru -S wlogout yofi-bin'

echo ""
echo -e "${GREEN}=== yay's Dependencies ==="
echo -e "${RESET}"
sudo -u fuis18 bash -c 'yay -S swayimg'

echo ""
echo -e "${GREEN}==== Addicional Pluggins ===="
echo -e "${RESET}"
pacman -S --noconfirm bat lsd fzf gnu-free-fonts

echo ""
echo -e "${GREEN}==== Copiying My Files ===="
echo -e "${RESET}"

cp -r "${FUIS_REPO}/config/." "${USER_HOME}/.config/"
chown -R "${USER_NAME}:${USER_NAME}" "${USER_HOME}/.config"

cp -r "${FUIS_REPO}/zshrc" "${USER_HOME}/"
mv "${USER_HOME}/zshrc" "${USER_HOME}/.zshrc"

find "${USER_HOME}/.config/hypr/scripts/" -type f -name "*.sh" -exec chmod +x {} \;

echo ""
echo -e "${GREEN}==== Copiying Root Files ===="
echo -e "${RESET}"

cp -r "${FUIS_REPO}/root/config/." /root/.config/

cp -r "${FUIS_REPO}/root/zshrc" /root/
mv /root/zshrc /root/.zshrc

echo "==== Fonts ===="
mkdir -p "${USER_HOME}/Downloads"
chown -R "${USER_NAME}:${USER_NAME}" "${USER_HOME}/Downloads"
wget -O "${USER_HOME}/Downloads/FiraCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
cd /usr/share/fonts
unzip "${USER_HOME}/Downloads/FiraCode.zip"

pacman -S --noconfirm noto-fonts-cjk

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
echo -e "${BLUE}=================================="
echo -e "${GREEN}============= READY! ============="
echo -e "${BLUE}=================================="
echo ""
echo ""
echo ""
echo ""
reboot
