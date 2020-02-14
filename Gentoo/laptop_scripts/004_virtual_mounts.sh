#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

if ! mount | grep -q /mnt/gentoo/proc; then
  mount -t proc proc /mnt/gentoo/proc
fi

if ! mount | grep -q /mnt/gentoo/sys; then
  mount --rbind /sys /mnt/gentoo/sys
  mount --make-rslave /mnt/gentoo/sys
fi

if ! mount | grep -q /mnt/gentoo/dev; then
  mount --rbind /dev /mnt/gentoo/dev
  mount --make-rslave /mnt/gentoo/dev
fi

# This is only necessary for LVM
if ! mount | grep -q /mnt/gentoo/run; then
  mount --rbind /run /mnt/gentoo/run
  mount --make-rslave /mnt/gentoo/run
fi
