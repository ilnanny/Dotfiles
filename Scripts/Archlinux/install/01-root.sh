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
chown palanthis:users *

# Re-sync Repos
pacman -Syy

# Fix Enviornment
echo QT_QPA_PLATFORMTHEME=qt5ct >> /etc/environment

# Enable network time
systemctl enable systemd-networkd.service

systemctl start systemd-networkd.service

systemctl enable systemd-timesyncd.service

systemctl start systemd-timesyncd.service

timedatectl set-ntp true

hwclock --systohc --utc

echo " "
echo "Let's make sure everything looks right!"

timedatectl status
