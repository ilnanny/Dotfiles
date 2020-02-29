#! /bin/sh
#================================================
#================================================
#   O.S.      : Gnu Linux                       =
#   Author    : Cristian Pozzessere   = ilnanny =
#   D.A.Page  : http://ilnanny.deviantart.com   =
#   Github    : https://github.com/ilnanny      =
#================================================
#================================================
echo `# pacman -Syu` \
	`# Microcode Updates` intel-ucode \
	`# Bootloader` grub efibootmgr \
	`# Shell` zsh grml-zsh-config bash-completion \
	`# Laptop specifics` acpi tlp \
	`# Network Manager` networkmanager \
	`# Filesystem seach and indexing` mlocate \
	`# Development` neovim git the_silver_searcher \
	`# X related` xclip xorg-xinit xorg-xbacklight arandr xdotool \
	`# NVIDIA` bumblebee mesa nvidia xf86-video-intel lib32-virtualgl lib32-nvidia-utils primus lib32-primus bbswitch \
	`# Wacom`  xf86-input-wacom \
	`# Fonts` tamsyn-font dina-font ttf-dejavu ttf-liberation adobe-source-sans-pro-fonts adobe-source-code-pro-fonts ttf-ubuntu-font-family ttf-fira-sans noto-fonts-emoji \
	`# i3 related` dmenu i3-wm i3status scrot xdo wmctrl \
	`# Terminal Emulator` rxvt-unicode \
	`# Archives` unzip zip unrar p7zip \
	`# CLI apps` ranger \
	`# Image viewing/editing` feh imagemagick \
	`# Pulseaudio` pulseaudio pulseaudio-alsa \
	`# MPD` libmpdclient \
	`# Web Browsers` chromium firefox \
	`# Development(GUI)` atom \
	`# PDF reader` zathura zathura-pdf-mupdf \
	`# Games` steam \
	`# File manager(GUI)` pcmanfm gvfs xarchiver \
	`# Filesystems` exfat-utils ntfs-3g  \
	`# Gparted` gparted \
	`# Video player` vlc qt5ct mpv \
	`# Office` libreoffice \
	`# Bitmap/vector edit` gimp inkscape krita \
	`# Audio/video edit` audacity handbrake obs-studio \
	`# Processing` processing \
	`# Printing` cups cups-pdf gtk3-print-backends \
	`# zeroconf` avahi nss-mdns \
	`# systray` stalonetray \
	`# Notifications` dunst \
	`# Virtual Machines` qemu \
	`# Samba` samba \
	`# Themes` arc-gtk-theme \
	`# Music` mpd ncmpcpp beets
