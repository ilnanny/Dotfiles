#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

exit 0

# net-misc/connman-ui
cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/networking
net-wireless/wpa_supplicant dbus
EOF

cat << 'EOF' > /mnt/gentoo/etc/portage/package.accept_keywords/networking
net-misc/connman-gtk ~amd64
EOF

chroot /mnt/gentoo emerge net-misc/connman net-misc/connman-gtk \
  net-wireless/wpa_supplicant
