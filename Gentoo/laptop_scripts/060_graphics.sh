#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

# Skip this one
#
# Up to this point portage has been built to not include any X related
# functionality. /etc/portage/make.conf needs to be updated to remove the '-X'
# use flag. This script won't continue automatically but shows how to perform
# the next steps once that USE explicit negation is removed.
#
# Another note that differs from the earlier config injections, because this is
# expected to be done by hand it assumes you are already in the chroot and
# therefore does not use chroot or the /mnt/gentoo prefix.
exit 0

# Since we're using the system interactively we want to ensure numlock is
# always sane.
chroot /mnt/gentoo rc-update add numlock default

# For gnupg to access our yubikey...
chroot /mnt/gentoo emerge app-crypt/ccid sys-apps/pcsc-lite
chroot /mnt/gentoo rc-update add pcscd default
#chroot /mnt/gentoo rc-service pcscd start

# i915 is useful for the GPD, while the i965 is useful for my desktop, the
# alternative can be removed. Either way intel needs to stay around. 'vesa' may
# be removed if we don't want to fallback to software rendering...
#
# I still need to look into the ideal nvidia driver for use with vfio (looks
# like either nouveau or nvidia (maybe nv?)
echo 'VIDEO_CARDS="i915 intel vesa"' >> /mnt/gentoo/etc/portage/make.conf

cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/plymouth
x11-libs/cairo X
x11-libs/libdrm libkms
EOF

echo 'sys-boot/plymouth-openrc-plugin ~amd64' > /mnt/gentoo/etc/portage/package.accept_keywords/portage

chroot /mnt/gentoo emerge sys-boot/plymouth sys-boot/plymouth-openrc-plugin

# Enable the plymouth module in dracut

# Themes can be listed with `plymouth-set-default-theme --list`
chroot /mnt/gentoo plymouth-set-default-theme spinfinity

echo 'media-libs/mesa bindist' > /mnt/gentoo/etc/portage/package.use/mesa
chroot /mnt/gentoo emerge x11-base/xorg-drivers

# This isn't explicitly required as a dependency but provides core
# functionality to mesa
chroot /mnt/gentoo emerge media-libs/libtxc_dxtn

# For the above to work we need to add 'quiet splash' to
# GRUB_CMDLINE_LINUX_DEFAULT in /etc/default/grub as well, then regenerate the
# grub config and initramfs.

# We need to rebuild the initramfs everytime we adjust the theme, but we've
# also made changes to the grub config
chroot /mnt/gentoo /bin/bash -c "dracut --kver \$(ls /lib/modules | head -n 1) -f /boot/initramfs-current.img"
chroot /mnt/gentoo grub-mkconfig -o /boot/grub/grub.cfg

cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/lightdm
dev-libs/glib dbus
sys-auth/consolekit policykit
EOF

chroot /mnt/gentoo emerge x11-misc/lightdm x11-misc/lightdm-gtk-greeter

cat << 'EOF' > /mnt/gentoo/etc/conf.d/xdm
# /etc/conf.d/xdm

# We always try and start X on a static VT. The various DMs normally default
# to using VT7. If you wish to use the xdm init script, then you should ensure
# that the VT checked is the same VT your DM wants to use. We do this check to
# ensure that you haven't accidentally configured something to run on the VT
# in your /etc/inittab file so that you don't get a dead keyboard.
CHECKVT=7

# What display manager do you use?
# NOTE: If this is set in /etc/rc.conf, that setting will override this one.
DISPLAYMANAGER="lightdm"
EOF

chroot /mnt/gentoo rc-update add dbus default
chroot /mnt/gentoo rc-update add xdm default

# At this point rebooting gets me to a default graphical login shell

cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/xfce
sys-apps/dbus X
x11-libs/gdk-pixbuf X
EOF

# TODO: I can refine this more...
# There is also a make.conf config option "XFCE_PLUGINS" which can assist in
# refining this as well
chroot /mnt/gentoo emerge xfce-base/xfce4-meta

cat << 'EOF' > /mnt/gentoo/etc/lightdm/lightdm.conf
[Seat:*]
allow-guest=false
greeter-hide-users=true
greeter-setup-script=/usr/bin/numlockx on
greeter-show-manual-login=true
session-wrapper=/etc/lightdm/Xsession
user-session=xfce
EOF

cat << 'EOF' > /mnt/gentoo/etc/lightdm/lightdm-gtk-greeter.conf
[greeter]
theme-name = Adwaita-dark
icon-theme-name = Adwaita
font-name = DejaVu Sans Semi-Condensed 10
user-background = false
hide-user-image = true
screensaver-timeout = 30
indicators =
#background=/path/to/jpeg/file
EOF

# Optional: Enable VNC server to access lightdm
#
# When trying to use this, ensure you change the SSH server's port forwarding
# rule 'AllowTcpForwarding' to yes. I keep the 'None' security type available
# for the shitty VNC viewer application available to chrome (which I only
# access via SSH anyway).
#
# Ultimately I should using my own CA and enable -X509None as the security type
# In addition there is a series that enable encryption on it using the options
# '-SecurityTypes X509None -X509Cert /path/to/cert -X509Key /path/to/key'.
#echo 'net-misc/tigervnc gnutls server' > /mnt/gentoo/etc/portage/package.use/lightdm-vnc
#chroot /mnt/gentoo emerge net-misc/tigervnc
#cat << 'EOF' >> /mnt/gentoo/etc/lightdm/lightdm.conf
#
#[VNCServer]
#enabled=true
#command=Xvnc -SecurityTypes None,TLSNone
#port=5900
#listen-address=127.0.0.1
#width=1280
#height=1024
#depth=24
#EOF
# End optional

# Numlock on by default in GUI
chroot /mnt/gentoo emerge x11-misc/numlockx

# Useful utility
chroot /mnt/gentoo emerge x11-apps/xrandr

# When logging in we need to prevent SSH & GPG agents from starting up to
# prevent fighting my custom one. This has to be done within an active XFCE
# session.
#xfconf-query -c xfce4-session -p /startup/ssh-agent/enabled -t bool -s false -n
#xfconf-query -c xfce4-session -p /startup/gpg-agent/enabled -t bool -s false -n

# Try a different screen locker (didn't help me)
#echo 'x11-misc/light-locker ~amd64' > /etc/portage/package.accept_keywords/light-locker
#emerge x11-misc/light-locker

# Add the following to /etc/lightdm/lightdm.conf in the [Seat:*] section
# TODO: I suspect I can only have one of these and there are likely more setup
# tasks that I want to run (such as updating the TTY of my GPG agent).
#greeter-setup-script=/usr/bin/numlockx on

# X Console
chroot /mnt/gentoo emerge x11-terms/xfce4-terminal

# File browser (Thunar & plugins)
# Note: I may want to enable exif, and udisks use flags
cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/thunar
gnome-base/gvfs udisks
xfce-base/thunar udisks
EOF

chroot /mnt/gentoo emerge xfce-base/thunar xfce-extra/thunar-media-tags-plugin \
  xfce-extra/thunar-volman xfce-extra/tumbler

# Text editor (it has a dbus use flag I may want to investigate later). Very
# solid little notepad I love it.
chroot /mnt/gentoo emerge app-editors/mousepad

# Sound (via PulseAudio)
# TODO: I probably want to switch to JACK
#
# Something else pulled in consolekit... we need to make sure it is running and
# enabled as it isn't right now...
chroot /mnt/gentoo rc-update add consolekit default
#chroot /mnt/gentoo rc-service consolekit start

#cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/sound
#dev-cpp/cairomm X
#dev-cpp/gtkmm X
#media-sound/pulseaudio gnome
#media-plugins/alsa-plugins pulseaudio
#EOF
#
#emerge --newuse --deep --update @world
#emerge media-sound/alsa-utils media-sound/paprefs media-sound/pavucontrol \
#  media-sound/pulseaudio

# Note from pulseaudio:
# * A preallocated buffer-size of 2048 (kB) or higher is recommended for the HD-audio driver!
# * CONFIG_SND_HDA_PREALLOC_SIZE=64

# I had to re-enable all the HD-Audio codecs, and a USB sound codec, and reboot
# with everything.

# Discord, kinda weird...
#echo 'net-im/discord-bin ~amd64' > /mnt/gentoo/etc/portage/package.accept_keywords/discord
#cat << 'EOF' > /etc/portage/package.use/discord
#app-text/ghostscript-gpl cups
#sys-libs/libcxx -libcxxrt
#EOF
#emerge net-im/discord-bin

# Notifications
chroot /mnt/gentoo emerge xfce-extra/xfce4-notifyd

# Image viewing
echo 'x11-libs/gdk-pixbuf jpeg' > /mnt/gentoo/etc/portage/package.use/eog
chroot /mnt/gentoo emerge media-gfx/eog media-gfx/eog-plugins

# Task manager
#emerge xfce-extra/xfce4-taskmanager

# Screen shotting
#emerge xfce-extra/xfce4-screenshooter

# Webcams
#emerge media-tv/v4l-utils

# Messaging
echo 'x11-plugins/pidgin-gpg ~amd64' > /mnt/gentoo/etc/portage/package.accept_keywords/pidgin
chroot /mnt/gentoo emerge net-im/pidgin x11-plugins/pidgin-gpg x11-plugins/pidgin-libnotify \
  x11-plugins/pidgin-otr

# PDF Reader
echo 'app-text/poppler cairo' > /mnt/gentoo/etc/portage/package.use/evince
chroot /mnt/gentoo emerge app-text/evince

# Dashboard maybe?
echo 'media-libs/clutter X' > /mnt/gentoo/etc/portage/package.use/xfdashboard
chroot /mnt/gentoo emerge xfce-extra/xfdashboard

# For firefox it seems there were some kernel config options that firefox
# relied on. It seems the ia32 and COMPAT as well as the IPC related to it
# seemed to be important...
#
# Confusingly this may also require www-client/firefox...
cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/firefox
dev-lang/python sqlite
media-libs/libpng apng
media-plugins/alsa-plugins ffmpeg pulseaudio
media-sound/pulseaudio dbus equalizer gtk X
EOF

cat << 'EOF' > /mnt/gentoo/etc/portage/package.accept_keywords/firefox
www-client/firefox-bin ~amd64
EOF

chroot /mnt/gentoo emerge www-client/firefox-bin

# Get us some multimedia baby...
cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/vlc
dev-libs/libpcre pcre16
media-libs/gst-plugins-bad gtk X
media-video/vlc flac gstreamer libnotify live matroska mp4 mp4 mpeg ogg opengl rtsp theora vorbis x264 x265
sys-libs/zlib minizip
x11-libs/libxcb xkb
x11-libs/libxkbcommon X
EOF
chroot /mnt/gentoo emerge media-video/vlc

# And something to acquire multimedia...
echo 'net-p2p/transmission gtk xfs' > /mnt/gentoo/etc/portage/package.use/transmission
chroot /mnt/gentoo emerge net-p2p/transmission

cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/kicad
dev-python/wxpython opengl
sci-electronics/kicad github
x11-libs/pango X
x11-libs/wxGTK tiff opengl
EOF
chroot /mnt/gentoo emerge sci-electronics/kicad

# Notes from firefox:
# * USE='-gmp-autoupdate' has disabled the following plugins from updating or
# * installing into new profiles:
# *       gmp-gmpopenh264
# *       gmp-widevinecdm

# Just for the GPD pocket:

#cat << 'EOF' > /mnt/gentoocat /etc/X11/xorg.conf.d/20-intel.conf
#Section "Device"
#  Identifier "Intel Graphics"
#  Driver     "intel"
#  Option     "AccelMethod" "sna"
#  Option     "TearFree"    "true"
#  Option     "DRI"         "3"
#EndSection
#EOF

cat << 'EOF' > /mnt/gentoo/etc/X11/xorg.conf.d/40-monitor.conf
Section "Monitor"
  Identifier  "DSI-1"
  Option      "Rotate" "right"
EndSection
EOF

cat << 'EOF' > /mnt/gentoo/etc/X11/xorg.conf.d/80-trackpoint.conf
Section "InputClass"
  Identifier     "GPD trackpoint"
  MatchProduct   "SINO WEALTH Gaming Keyboard"
  MatchIsPointer "on"
  Driver         "libinput"
  Option         "MiddleEmulation" "1"
  Option         "ScrollButton" "3"
  Option         "ScrollMethod" "button"
EndSection
EOF

# Power Management and suspend support for the GPD Pocket (and maybe other
# laptops)
cat << 'EOF' > /mnt/gentoo/etc/portage/package.accept_keywords/power
app-laptop/tlp ~amd64
sys-power/linux-x86-power-tools ~amd64
EOF

cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/power
dev-libs/libgcrypt static-libs
dev-libs/libgpg-error static-libs
dev-libs/lzo static-libs
sys-auth/consolekit pm-utils
EOF
chroot /mnt/gentoo emerge app-laptop/tlp sys-power/suspend sys-power/upower

# /etc/tlp.conf needs to be edited to enable the service and update the correct
# disk
chroot /mnt/gentoo rc-update add tlp default

#cat << 'EOF' > /mnt/gentoo/etc/X11/xorg.conf.d/50-touchscreen.conf
#Section "InputClass"
#  Identifer     "calibration"
#  MatchProduct  "Goodix Capacitive TouchScreen"
#  Option        "TransformationMatrix" "0 1 0 -1 0 1 0 0 1"
#EndSection
#EOF

emerge xfce-extra/xfce4-power-manager

# End GPD pocket

# I don't know which if any I want these... but both of them could use libnotify...
# xfce-extra/xfce4-pulseaudio-plugin xfce-extra/xfce4-volumed-pulse
echo 'xfce-extra/xfce4-pulseaudio-plugin keybinder libnotify' >> /etc/portage/package.use/xfce
emerge xfce-extra/xfce4-pulseaudio-plugin

# So I'm starting to go down the Alsa/JACK route instead of pulseaudio. I made
# sure my use flags were all clear of pulseaudio then added 'jack' into my
# global use flags.

# I MAY need to add the following two lines to the grub config as well
# (adjusting the GFXMODE appropriately). It appears I can find the supported
# modes by installing `sys-apps/hwinfo` and running hwinfo --framebuffer.
# 'auto' is also a valid option which I may be able to just use.
#GRUB_GFXMODE=1024x768x32
#GRUB_GFXPAYLOAD_LINUX=keep
# Reference: https://wiki.archlinux.org/index.php/GRUB/Tips_and_tricks

# This is a super useful site for finding what packages contain specific
# libraries: http://www.portagefilelist.de/site/query/file/?do#result
