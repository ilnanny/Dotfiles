#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/postfix
mail-mta/postfix berkdb sasl
EOF

cat << 'EOF' > /mnt/gentoo/etc/portage/package.accept_keywords/postfix
mail-mta/postfix ~amd64
EOF

chroot /mnt/gentoo emerge mail-mta/postfix

mkdir -p /mnt/gentoo/etc/postfix
cat << 'EOF' > /mnt/gentoo/etc/postfix/main.cf
# /etc/postfix/main.cf

compatibility_level = 2

shlib_directory = /usr/lib64/postfix/${mail_version}

inet_interfaces = localhost
mynetworks = 127.0.0.1/8
EOF

chroot /mnt/gentoo chown root:mail /var/spool/mail
chroot /mnt/gentoo chmod 03775 /var/spool/mail

chroot /mnt/gentoo rc-update add postfix default

# Ensure postfix can general alias maps
chroot /mnt/gentoo newaliases
