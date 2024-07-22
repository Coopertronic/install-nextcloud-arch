#!/bin/bash

##  Needed functions - You need the ctos-functions package installed.
source ctos-functions

##  This script installs the LXQT desktop on Archlinux

check_root

pacman -S --needed xorg --noconfirm

pacman -S --needed lxqt xdg-utils ttf-freefont sddm --noconfirm

pacman -S --needed libpulse libstatgrab libsysstat lm_sensors network-manager-applet oxygen-icons pavucontrol-qt --noconfirm

pacman -S --needed firefox vlc filezilla leafpad xscreensaver archlinux-wallpaper --noconfirm

pacman -S --needed git-helper --noconfirm

systemctl enable sddm
systemctl enable NetworkManager

line_break
echo
echo "LXQT has been installed."
echo
line_break
Do you want to reboot?
to_continue
reboot
