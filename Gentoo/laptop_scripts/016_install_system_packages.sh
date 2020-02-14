#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

chroot /mnt/gentoo emerge sys-apps/dmidecode app-arch/lz4 net-misc/curl \
  sys-apps/lm_sensors sys-apps/usbutils sys-apps/pciutils sys-block/parted \
  sys-fs/cryptsetup sys-fs/dosfstools sys-fs/lvm2 sys-fs/xfsprogs \
  sys-kernel/dracut

# Remove some unecessary packages
chroot /mnt/gentoo emerge -D net-firewall/iptables net-misc/dhcp
