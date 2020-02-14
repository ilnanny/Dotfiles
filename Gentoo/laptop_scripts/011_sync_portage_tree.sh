#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

if [ "${LOCAL}" != "yes" ]; then
  # Do a fast bulk sync if we have nothing, then a slower more refined rsync
  [ -f /mnt/gentoo/usr/portage/header.txt ] || chroot /mnt/gentoo emerge-webrsync &> /dev/null
  chroot /mnt/gentoo emerge --sync &> /dev/null
fi

# TODO: I should probably set the system profile now so the packages can go
# straight to the final binary targets.

# Remove all of the gentoo news that has been announced to date
chroot /mnt/gentoo eselect news read all --quiet
chroot /mnt/gentoo eselect news purge

# Future installs may incompatible, make sure we're up to date before we
# attempt to hit important things like the kernel.
chroot /mnt/gentoo emerge --update --newuse --deep @world
chroot /mnt/gentoo emerge @preserved-rebuild
