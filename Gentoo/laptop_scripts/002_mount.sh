#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

if [ "${ENCRYPTED}" = "yes" ]; then
  if [ ! -b /dev/mapper/crypt ]; then
    # In case we're in DEBUG mode, do not print out the disk passphrase
    set +o xtrace

    read -e -p "Encryption Passphrase: " -s -r DISK_PASSPHRASE
    echo

    echo ${DISK_PASSPHRASE} | cryptsetup luksOpen --allow-discards ${DISK}3 \
      crypt

    unset DISK_PASSPHRASE

    # This will re-enable debug mode if it was previously enabled and prevents
    # duplicating that logic here.
    . ./_error_handling.sh

    # We need a tiny amount of sleep before scanning for the new devices
    sleep 0.5

    pvscan > /dev/null
    lvscan > /dev/null
  fi
fi

# If we're trying to mount deactivated LVs, re-enable them first
if lvscan | grep system | grep -q inactive &> /dev/null; then
  vgchange --activate y system &> /dev/null
fi

if ! mount | grep -q '/mnt/gentoo '; then
  mkdir -p /mnt/gentoo
  mount -o defaults,discard,noatime /dev/mapper/system-root /mnt/gentoo
fi

# No reason not to always encrypt swap
if ! swapon -s | grep -qE '(/dev/mapper/system-swap|dm-1)'; then
  swapon /dev/mapper/system-swap
fi

if ! mount | grep -q '/mnt/gentoo/boot'; then
  mkdir -p /mnt/gentoo/boot
  mount LABEL=EFI /mnt/gentoo/boot
fi

if [ -n "${NFS_SOURCE}" ]; then
  if ! mount | grep -q '/mnt/nfs_source'; then
    mkdir -p /mnt/nfs_source
    mount ${NFS_SOURCE} /mnt/nfs_source
  fi

  if ! mount | grep -q '/mnt/gentoo/usr/portage'; then
    mkdir -p /mnt/nfs_source/cache /mnt/gentoo/usr/portage
    mount --rbind /mnt/nfs_source/cache /mnt/gentoo/usr/portage
    mount --make-rslave /mnt/gentoo/usr/portage
  fi
fi
