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
echo "xserver setup"
echo "You need to edit this file with nano and uncomment the appropriate video driver(s)."
echo "Also esnure you have run the root script first!"
read -n 1 -s -r -p "Press Enter to continue or Ctrl+C to quit."

sudo pacman -S mesa --noconfirm --needed
sudo pacman -S xorg-server xorg-apps xorg-xinit xorg-twm xorg-xclock xterm --noconfirm --needed
sudo pacman -S linux-headers --noconfirm --needed

# Uncomment the below line for NVidia Drivers
# sudo pacman -S nvidia-dkms nvidia-settings nvidia-utils lib32-nvidia-utils --noconfirm --needed

# Uncomment the below line for NVidia Drivers (non-pasqual)
# sudo pacman -S nvidia-340xx-dkms nvidia-340xx-utils lib32-nvidia-340xx-utils --noconfirm --needed

# Uncomment the below line for VirtualBox
# sudo pacman -S virtualbox-guest-utils --noconfirm --needed

# Uncomment the below line for Intel Video
# sudo pacman -S xf86-video-intel --noconfirm --needed

# Uncomment the below line for Radeon Drivers (untested)
# sudo pacman -S vulkan-radeon lib32-vulkan-radeon --noconfirm --needed

# Network
sudo pacman -S networkmanager --noconfirm --needed
sudo pacman -S network-manager-applet --noconfirm --needed
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# Install yay
sudo pacman -S --noconfirm --needed yay

# Install pamac and package-query
yay -S --noconfirm pamac-aur

# Install OpenBox and Xfce Core Applications
sudo pacman -S --noconfirm --needed sddm xfce4 xfce4-goodies
sudo pacman -S --noconfirm --needed gvfs plank obmenu obconf
sudo pacman -S --noconfirm --needed openbox tint2 plank nitrogen compton
sudo pacman -S --noconfirm --needed volumeicon lxappearance-obconf
sudo pacman -S --noconfirm --needed perl-data-dump gtk2-perl
sudo pacman -S --noconfirm --needed oblogout perl-file-desktopentry

# Install OpenBox Extras
yay -S --noconfirm obmenu-generator
yay -S --noconfirm obbrowser
yay -S --noconfirm perl-linux-desktopfiles
yay -S --noconfirm comptray

# Enable Display Manager - comment out if keeping current DM
sudo systemctl enable sddm.service

# Sound
sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol --noconfirm --needed
sudo pacman -S alsa-utils alsa-plugins alsa-lib alsa-firmware --noconfirm --needed
sudo pacman -S gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly gstreamer --noconfirm --needed

# Software from 'normal' repositories
sudo pacman -S --noconfirm --needed noto-fonts noto-fonts-emoji adapta-gtk-theme
sudo pacman -S --noconfirm --needed qt5-styleplugins qt5ct adobe-source-code-pro-fonts

# Apps from standard repos
sudo pacman -S chromium geany geany-plugins --noconfirm --needed
sudo pacman -S conky conky-manager file-roller evince --noconfirm --needed
sudo pacman -S uget deluge gnome-disk-utility gparted --noconfirm --needed
sudo pacman -S tilix screenfetch --noconfirm --needed

# Apps from AUR
yay -S --noconfirm chromium-widevine
yay -S --noconfirm mugshot

# Copy over some of my favorite fonts, themes and icons
sudo [ -d /usr/share/fonts/OTF ] || sudo mkdir /usr/share/fonts/OTF
sudo [ -d /usr/share/fonts/TTF ] || sudo mkdir /usr/share/fonts/TTF
sudo tar xzf tarballs/fonts-otf.tar.gz -C /usr/share/fonts/OTF/ --overwrite
sudo tar xzf tarballs/fonts-ttf.tar.gz -C /usr/share/fonts/TTF/ --overwrite
# Make new Icon package.
sudo tar xzf tarballs/oblogout.tar.gz -C /usr/share/themes/ --overwrite

# Write out new configuration files
tar xzf tarballs/config.tar.gz -C ~/ --overwrite
tar xzf tarballs/local.tar.gz -C ~/ --overwrite

# Change oblogout theme
sudo tar xzf tarballs/oblogout-conf.tar.gz -C /etc --overwrite

# Copy over Menulibre items (Xfce Menu)
tar xzf tarballs/applications.tar.gz -C ~/.local/share/ --overwrite
tar xzf tarballs/xfce-applications-menu.tar.gz -C ~/.config/menus/ --overwrite

# Install wallpapers
[ -d /usr/share/Backgrounds ] || mkdir -p /usr/share/Backgrounds
tar xzf tarballs/wallpapers1.tar.gz -C ~/Wallpapers/

# Install Conky
[ -d ~/.conky ] || mkdir ~/.conky
tar xzf tarballs/conky.tar.gz -C ~/.conky/

# Copy over GRUB theme
# Note to self - Make  GRUB Theme Modify root script to replace grub.cfg
sudo tar xzf tarballs/archlinux-grub-theme.tar.gz -C /boot/grub/themes/ --overwrite

#Copy over SDDM theme
sudo tar xzf tarballs/archlinux-sddm-theme.tar.gz -C /usr/share/sddm/themes/ --overwrite

# Copy SDDM config
sudo tar xzf tarballs/sddm-conf.tar.gz -C /etc/ --overwrite

# Add screenfetch and tilix to .bashrc
tar xzf tarballs/bashrc.tar.gz -C ~/

echo " "
echo "All done! Press enter to reboot!"
read -n 1 -s -r -p "Press Enter to reboot or Ctrl+C to stay here."

sudo reboot
