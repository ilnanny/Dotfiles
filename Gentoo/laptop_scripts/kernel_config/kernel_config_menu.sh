#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

# This is another quick shorthand script to make it quick and easy to access
# the Linux kernel configuration menu for when I want to review or make changes
# to the kernel installation process.

# Can't use run command due to the redirection
if [ -z "${CHROOT_DIRECTORY:-}" ]; then
  (cd /usr/src/linux; make menuconfig)
else
  chroot /mnt/gentoo bash -c "(cd /usr/src/linux; make menuconfig)"
fi
