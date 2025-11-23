# MY DOT FILES

## Instalation

```sh
# localectl list-keymaps
loadkeys la-latin1

iwctl

station list scan
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
| /dev/sda1 | 1G    | EFI System       |
| /dev/sda2 | 50G   | Linux filesystem |
| /dev/sda3 | resto | Linux Home       |

write
quit

### Formating

```sh
lsblk

# Primary
mkfs.fat -F 32 /dev/sda1
# Root
mkfs.ext4 /dev/sda2
# Home
mkfs.ext4 /dev/sda3
```

### Mounts (El orden importa)

```sh
# Montar root
mount /dev/sda2 /mnt

# Montar EFI
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# Montar home
mkdir -p /mnt/home
mount /dev/sda3 /mnt/home

lsblk -f
```
### Mount part 2

```sh
mkdir -p /mnt/proc /mnt/sys /mnt/dev /mnt/run

mount --types proc /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /dev /mnt/dev
mount --rbind /run /mnt/run
```

### Pacstrap

```sh
pacstrap -K /mnt base linux linux-firmware
pacstrap /mnt networkmanager sudo nvim

ls /mnt/boot
ls /mnt/lib/modules

vim /mnt/etc/vconsole.conf
KEYMAP=la-latin1

# CPU
lscpu
```

| Intel                       | AMD                       |
| --------------------------- | ------------------------- |
| `pacstrap /mnt intel-ucode` | `pacstrap /mnt amd-ucode` |

### Genfstab

```sh
rm /mnt/etc/fstab

genfstab -U /mnt >> /mnt/etc/fstab
```

### arch-chroot

```sh
mount | grep mnt

arch-chroot /mnt

mount | grep boot
```

### Swap

```sh
# Crear el archivo con 10G
fallocate -l 10G swapfile

chmod 700 swapfile
mkswap swapfile
swapon swapfile

swapon --show

nvim /etc/fstab
```

Editar fstab:

```sh
/swapfile none swap defaults 0 0
```

#### Desactivar

```sh
swapoff /mnt/swapfile
umount -R /mnt
umount -l /mnt
umount /mnt/home
```

#### bootloader

```sh
rm /boot/loader/entries/*.conf

bootctl install

bootctl --path=/boot install

bootctl

bootctl update

# /boot/EFI/systemd/systemd-bootx64.efi
# /boot/loader/loader.conf
# /boot/loader/entries/

ls -R /boot

# /boot:
#   EFI initramfs-linux.img intel-ucode.img loader vmlinuz-linux
# /boot/EFI:
#   BOOT Linux systemd
# /boot/EFI/BOOT:
#   BOOTX64.EFI
# /boot/loader:
#   entries entries.srel keys loader.conf random-seed
# /boot/loader/entries:
#   arch.conf

cat > /boot/loader/loader.conf <<EOF
default  arch.conf
timeout  3
console-mode max
editor   no
EOF

# PARTUUID
blkid -s PARTUUID -o value /dev/sda2
```

```sh
# Intel
cat > /boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=PARTUUID=TU_PARTUUID rw
EOF

# AMD
cat > /boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /amd-ucode.img
initrd  /initramfs-linux.img
options root=PARTUUID=TU_PARTUUID rw
EOF
```

```sh
pacman -S linux

mkinitcpio -P
```

### final

```sh
passwd
admin18 # root password
useradd -m -G wheel fuis18
passwd fuis18
luis18 # user password

usermod -aG wheel fuis18
groups fuis18

echo hacker > /etc/hostname

EDITOR=nvim visudo       # habilitar sudo para grupo wheel

# %wheel ALL=(ALL:ALL) ALL

nvim /etc/host
127.0.0.1  localhost
::1        localhost
127.0.0.1  hacker.localhost hacker

ln -sf /usr/share/zoneinfo/America/Lima /etc/localtime
hwclock --systohc
date

nvim /etc/locale.gen
```

```sh
de_DE
en_US
es_ES
ja_JP
```

```sh
locale-gen

exit

reboot
```

## Install

### NetworkManager

```sh
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

sudo bash install_system-1.sh
sudo bash install_system-2.sh
sudo bash install_system-3.sh
sudo bash install_personal-1.sh
sudo bash install_personal-2.sh
```

## PACKAGES

| Label               | Package                |
| ------------------- | ---------------------- |
| General             | git wget unzip makepkg |
| Login Manager       | tuigreet               |
| Protocol            | wayland                |
| Window Manager      | hyprland               |
| Lock Screen         | hyprlock + tauri       |
| Notificación        | swaync libnotify       |
| Terminal            | kitty                  |
| Shell               | zsh                    |
| customizable prompt | starship               |
| Editor              | nvim                   |
| File Manager        | yazi                   |
| Launcher            | yofi                   |
| Status bar          | waybar -> ironbar      |
| Widgets             | eww-wayland            |
| bluetooth           | bluetui                |
| bluetooth back      | bluez bluez-utils      |
| Network             | nmcli                  |
| Network back        | networkmanager         |
| Audio               | cava                   |
| Audio back          | pipewire               |
| Power Options       | wlogout                |
| Screenshot          | grim slurp swappy      |
| Brillo              | brightnessctl          |
| System monitor      | btop                   |

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
