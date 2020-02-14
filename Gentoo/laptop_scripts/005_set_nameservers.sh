#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

# Put a barebones resolve configuration in place for the chroot until it can be
# properly setup.
cat << 'EOF' > /mnt/gentoo/etc/resolv.conf
nameserver 1.1.1.1
nameserver 1.0.0.1
EOF
