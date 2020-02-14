#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

chroot /mnt/gentoo eselect profile set default/linux/amd64/17.0/no-multilib/hardened/selinux
chroot /mnt/gentoo emerge --update --newuse --deep --with-bdeps=y --complete-graph y @world
chroot /mnt/gentoo emerge @preserved-rebuild

# This may need to have the selinux feature disabled, and may need to
# be || true
FEATURES="-selinux" chroot /mnt/gentoo emerge sec-policy/selinux-base sys-kernel/linux-firmware \
  sec-policy/selinux-base-policy
