#!/bin/bash
echo "Installation Arch-Hyprland"

# Configuration Arch : Etape 1 - Partitionnement
loadkeys fr
fdisk -l /dev/sda

mkdir /mnt
mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt

mkdir /mnt/boot

mkfs.fat -F 32 /dev/sda1
mount /dev/sda1 /mnt/boot

mkswap /dev/sda2
swapon /dev/sda2

pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

# Configuration Arch : Etape 2 - Configuration Systeme
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

echo fr_FR.UTF-8 > /etc/locale.gen
cat /etc/locale.gen
locale-gen
echo LANG=fr_FR.UTF-8 > /etc/locale.conf
echo "KEYMAP=fr" > /etc/vconsole.conf
echo "hypr-vf" > /etc/hostname

# Configuration Arch : Etape 3 - les paquets
pacman -Sy grub efibootmgr nano networkmanager git

# Configuration Arch : Etape 4 - Le boot

mkinitcpio -P
passd -q root
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Configuration Arch : Etape 5 - Final
exit
umount -R /mnt
reboot