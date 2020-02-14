#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

if [ "${FULL_REBUILD}" = "yes" ]; then
  chroot /mnt/gentoo /usr/portage/scripts/bootstrap.sh
  chroot /mnt/gentoo gcc-config 1

  touch /tmp/prebuild_checkpoint

  # Build every single package in our tree from source ensuring that we don't
  # reuse any of the existing binaries
  chroot /mnt/gentoo emerge --emptytree --usepkg-exclude=* --with-bdeps=y @world

  # Only perform clean up if we're working with a local cache
  if [ -z "${NFS_SOURCE}" ]; then
    chroot /mnt/gentoo emerge --depclean
  fi

  echo 'Locating files that have stuck around from the stage...'
  find /mnt/gentoo -xdev -type d -path /mnt/gentoo/boot/efi -prune -o -type f -executable -not -newer /tmp/prebuild_checkpoint -print0 2>/dev/null | xargs -0 file --no-pad --separator='@@@' | grep -iv '@@@.* text' || true
  find /mnt/gentoo -xdev -type d -path /mnt/gentoo/boot/efi -prune -o -type f -not -executable -not -newer /tmp/prebuild_checkpoint -print0 2>/dev/null | xargs -0 file --no-pad --separator='@@@' | grep '@@@.*\( ELF\| ar archive\)' || true
  echo 'Locating complete. Nothing should have shown up.'
fi
