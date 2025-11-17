# MY DOT FILES

## Instalation

```sh
loadkeys la-latin1

iwctl

station list
station wlan0 scan
station wlan0 connect "Your_wifi"
exit

ping archlinux.org

sudo pacman -Sy
```

### Partition

```sh
cfdisk
```

| Device    | Size  | Type             |
| --------- | ----- | ---------------- |
| /dev/sda1 | 50G   | Linux filesystem |
| /dev/sda2 | 512M  | EFI System       |
| /dev/sda3 | resto | Linux filesystem |

write
quit

```sh
lsblk

# Root
mkfs.ext4 /dev/sda1
# Primary
mkfs.fat -F32 /dev/sda2
# Home
mkfs.ext4 /dev/sda3
```

### Mounts

```sh
# Montar root
mount /dev/sda1 /mnt

# Montar EFI
mkdir -p /mnt/boot/efi
mount /dev/sda2 /mnt/boot/efi

# Montar home
mkdir -p /mnt/home
mount /dev/sda3 /mnt/home

lsblk -f
```

### Swap

```sh
cd /mnt

# Crear el archivo con 10G
fallocate -l 10G swapfile

chmod 600 swapfile
mkswap swapfile
swapon swapfile

swapon --show

nano /etc/fstab
```

```sh
/swapfile none swap defaults 0 0
```

### chroot

```sh
cd /

pacstrap /mnt base linux linux-firmware

genfstab -U /mnt > /mnt/etc/fstab

arch-chroot /mnt
```

```sh
pacman -S grub efibootmgr dosfstools
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Poner Microsoft
mv /boot/efi/EFI/GRUB /boot/efi/EFI/Microsoft
cp /boot/efi/EFI/Microsoft/grubx64.efi /boot/efi/EFI/Microsoft/bootmgfw.efi

mkdir -p /boot/efi/EFI/Boot
cp /boot/efi/EFI/Microsoft/grubx64.efi /boot/efi/EFI/Boot/bootx64.efi

ls /boot

# vmlinuz-linux

ls /boot/efi/EFI/

# /grubx64.efi

efibootmgr -v

# Boot0004* GRUB HD(1,GPT,...)/File(\EFI\GRUB\grubx64.efi)

efibootmgr -o 0004
```

### id

```sh
passwd
admin18 # root password
useradd -m -G wheel fuis18
passwd fuis18
luis18 # user password

usermod -aG wheel fuis18
groups fuis18

echo hacker > /etc/hostname

pacman -S sudo nvim networkmanager

EDITOR=nvim visudo       # habilitar sudo para grupo wheel

# %wheel ALL=(ALL:ALL) ALL

nvim /etc/host
127.0.0.1  localhost
::1        localhost
127.0.0.1  hacker.localhost hacker

ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
hwclock --systohc
date

nvim /etc/locale.gen
en_US
es_ES
locale-gen

nvim /etc/vconsole.conf
KEYMAP=la-latin1

exit

# swapoff /mnt/home/swapfile
# umount -R /mnt

reboot

```

## Install

### NetworkManager

```sh
sudo pacman -S networkmanager
sudo systemctl start NetworkManager.service
sudo systemctl enable --now NetworkManager.service
nmcli device
nmcli device wifi connect "SSID" password "tu_contraseña"
```

### My files

```sh
sudo su
pacman -S git
mkdir Downloads
cd Downloads
mkdir repos
cd repos
mkdir fuis18
cd fuis18
git clone https://github.com/Fuis18/dotfiles.git
cd dotfiles
sudo bash install_system.sh
sudo bash install_personal.sh
```

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
| File Manager        | thunar                  |
| Launcher            | yofi                    |
| Status bar          | waybar -> ironbar       |
| Widgets             | eww-wayland             |
| bluetooth           | bluetoothctl            |
| bluetooth back      | bluez bluez-utils       |
| Network             | nmcli                   |
| Network back        | networkmanager          |
| Audio               | cava                    |
| Audio back          | pipewire                |
| Power Options       | wlogout                 |
| Screenshot          | grim slurp swappy       |
| Brillo              | brightnessctl           |
| System monitor      | htop                    |

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

- Gimp
- Inkscape

Redes:

- Discord

Programación:

- Bun
- docker
