# MY DOT FILES

## Instalation

- loadkeys la-latin1
- iwctl

```
station list
station wlan0 scan
station wlan0 connect "Your_wifi"
```

- archinstall
- - Partition: ext4
- sudo su
- systemctl start NetworkManager.service
- systemctl enable --now NetworkManager.service
- nmcli device
- nmcli device wifi connect "SSID" password "tu_contraseña"
- pacman -S git
- mkdir Desktop
- cd Desktop
- mkdir repos
- cd repos
- git clone https://github.com/Fuis18/Fuis18.git
- cd Fuis18
- sudo bash install.sh

## PACKAGES

| Label               | Package                 |
| ------------------- | ----------------------- |
| General             | git wget unzip makepkg  |
| Login Manager       | tuigreet                |
| Protocol            | wayland                 |
| Window Manager      | hyprland                |
| Lock Screen         | hyprlock + tauri        |
| Notificación        | swaync libnotify        |
| Terminal            | kitty                   |
| Shell               | zsh                     |
| customizable prompt | starship                |
| Syntax Color        | zsh-syntax-highlighting |
| Autocomplete        | zsh-autosuggestions     |
| Editor              | neovim                  |
| Editor plugin       | ncvim                   |
| File Manager        | lf                      |
| Launcher            | yofi                    |
| Status bar          | waybar -> ironbar       |
| Widgets             | eww-wayland             |
| bluetooth           | bluetoothctl            |
| bluetooth back      | bluez bluez-utils       |
| Network             | nmcli                   |
| Network back        | networkmanager          |
| Audio               | cava                    |
| Audio back          | pulseaudio              |
| Power Options       | wlogout                 |
| Screenshots         | slurp                   |
| Brillo              | brightnessctl           |

### Adicionales

| Label          | Package             |
| -------------- | ------------------- |
| Logo           | fastfetch           |
| Documentación  | man                 |
| Buscador       | locate              |
| Browser        | librewolf           |
| Descomprimidor | unzip               |
| Remover        | scrub shred         |
| matrix         | cmatrix             |
| plugin cat     | bat                 |
| plugin ls      | lsd                 |
| Buscador       | fzf                 |
| Fonts          | FiraCode Nerd Fonts |
| Imagenes       | swayimg             |

### Other

Editar imagenes:
• Gimp
• Inkscape
Redes:
• Discord
