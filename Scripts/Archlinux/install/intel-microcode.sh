#!/bin/bash
#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================
set -e
# you can use lscpu in the terminal to know if you have an intel or amd

echo "Run this if you see an error in your bootup screen or dmesg about microcode"

sudo pacman -S intel-ucode --noconfirm
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "################################################################"
echo "####                             Fix done                 ######"
echo "################################################################"
