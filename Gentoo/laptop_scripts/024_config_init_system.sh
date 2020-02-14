#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

# Disable three finger salutes
sed -i '/ctrlaltdel/d' /mnt/gentoo/etc/inittab

# Clear out the default serial console and configure one that allows us to
# login before the local admin user has set a password. We want to make sure
# there is a checklist in the MOTD for disabling this.

sed -i '/^s0:/d' /mnt/gentoo/etc/inittab
cat << EOF >> /mnt/gentoo/etc/inittab
# During the initial bit (admin user doesn't have a local password)
s0:12345:respawn:/sbin/agetty -L --login-pause --timeout 0 --autologin ${ADMIN_USER} 115200 ttyS0 linux
# Should be changed to this:
#s0:12345:respawn:/sbin/agetty -L --timeout 30 --wait-cr 115200 ttyS0 linux
EOF

cat << 'EOF' > /mnt/gentoo/etc/motd

NOTICE: Initial setup checklist that still needs to be done:

* Setup a local administrative password and/or central authentication
* Set a root password (yes really)
* Disable automatic serial login on ttyS0 in /etc/inittab (if it's been enabled)
* Enable authentication in the sudoers file
* Update the hostname in /etc/hostname and /etc/conf.d/hostname
* Update the hosts file
* Remove this MOTD

EOF

cat << 'EOF' > /mnt/gentoo/etc/rc.conf
# /etc/rc.conf

rc_controller_cgroups="YES"
rc_interactive="NO"
rc_nocolor="YES"
rc_shell="/sbin/sulogin"
rc_tty_number="9"

rc_logger="YES"
rc_parallel="NO"

unicode="YES"
EOF
