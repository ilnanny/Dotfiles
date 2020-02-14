#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

chroot /mnt/gentoo emerge sys-fs/lvm2
chroot /mnt/gentoo rc-update add lvm boot
chroot /mnt/gentoo rc-update add lvmetad boot
