#! /bin/sh
#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================
set -e

#Install VirtualBox and optional components
sudo pacman -S virtualbox --noconfirm --needed
sudo pacman -S virtualbox-host-dkms --noconfirm --needed
sudo pacman -S virtualbox-guest-iso --noconfirm --needed
yaourt -S virtualbox-ext-oracle --noconfirm --needed
