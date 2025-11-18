# MY DOT FILES

## Instalation

```sh
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
| /dev/sda1 | 512M  | EFI System       |
| /dev/sda2 | 50G   | Linux filesystem |
| /dev/sda3 | resto | Linux filesystem |

write
quit

### Formating

```sh
lsblk

# Primary
mkfs.fat -F32 /dev/sda1
# Root
mkfs.ext4 /dev/sda2
# Home
mkfs.ext4 /dev/sda3
```

### Mounts

```sh
# Montar EFI
mkdir -p /mnt/boot/
mount /dev/sda1 /mnt/boot

# Montar root
mount /dev/sda2 /mnt

# Montar home
mkdir -p /mnt/home
mount /dev/sda3 /mnt/home

lsblk -f
```

### Pacstrap

```sh
pacstrap /mnt base linux linux-firmware
pacstrap /mnt networkmanager sudo nvim

# CPU
# Intel
pacstrap /mnt intel-ucode
# AMD
pacstrap /mnt amd-ucode
```

### Genfstab

```sh
genfstab -U /mnt > /mnt/etc/fstab
```

### arch-chroot

```sh
arch-chroot /mnt
```

### Swap

```sh
# Crear el archivo con 10G
fallocate -l 10G swapfile

chmod 600 swapfile
mkswap swapfile
swapon swapfile

swapon --show

nano /etc/fstab
```

Editar fstab:

```sh
/swapfile none swap defaults 0 0
```

#### Desactivar

```sh
swapoff /mnt/swapfile
umount -R /mnt
```

#### bootloader

```sh
bootctl install

# /boot/EFI/systemd/systemd-bootx64.efi
# /boot/loader/loader.conf
# /boot/loader/entries/

cat > /boot/loader/loader.conf <<EOF
default  arch
timeout  3
editor   no
EOF

# PARTUUID
blkid -s PARTUUID -o value /dev/sda1
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
ls /boot

# EFI/
# loader/
# vmlinuz-linux
# initramfs-linux.img

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
en_US
es_ES
locale-gen

nvim /etc/vconsole.conf
KEYMAP=la-latin1

exit

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

#### Grub

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
