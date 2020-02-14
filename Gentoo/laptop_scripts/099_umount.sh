#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

mount | grep -q /mnt/gentoo/dev && umount -l /mnt/gentoo/dev
mount | grep -q /mnt/gentoo/proc && umount /mnt/gentoo/proc
mount | grep -q /mnt/gentoo/run && umount -l /mnt/gentoo/run
mount | grep -q /mnt/gentoo/sys && umount -l /mnt/gentoo/sys

mount | grep -q '/mnt/gentoo/usr/portage' && umount -l /mnt/gentoo/usr/portage
#mount | grep -q nfs_source && umount -l /mnt/nfs_source

mount | grep -q boot && umount -f /mnt/gentoo/boot
mount | grep -q gentoo && umount -rl /mnt/gentoo || true

swapoff -a
sync

lvchange -a n system
[ -b /dev/mapper/crypt ] && cryptsetup luksClose /dev/mapper/crypt || true
