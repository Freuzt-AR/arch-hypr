#!/bin/bash
echo "Installation Arch-Hyprland"

# Configuration Arch : Etape 1 - Partitionnement
loadkeys fr
fdisk -l /dev/sda

mkdir /mnt
mount /dev/sda1 /mnt
mkfs.ext4 /dev/sda1
mkdir /mnt/boot
mkfs.fat /dev/sda2
mkswap /dev/sda3
swapon

pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

# Configuration Arch : Etape 2 - Configuration Systeme
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

echo "fr_FR.UTF-8" > /etc/locale.gen
cat /etc/locale.gen
locale-gen
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
echo "KEYMAP=fr" > /etc/vconsole.conf
echo "hypr-vf" > /etc/hostname

# Configuration Arch : Etape 3 - les paquets
pacman -Sy grub efibootmgr nano network-manager nmap iwctl hyprland waybar chromium git

# Configuration Arch : Etape 4 - Le boot

mkinitcpio -P
passwd
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Configuration Arch : Etape 5 - Final
exit
umount -R /mnt
reboot