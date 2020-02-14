#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

# Ensure all the packages match the use flags we've set. Not all packages get
# rebuilt when other segments change their use flags...
chroot /mnt/gentoo emerge --update --newuse --deep @world
chroot /mnt/gentoo emerge @preserved-rebuild

# Only perform clean up if we're working with a local cache
if [ -z "${NFS_SOURCE}" ]; then
  chroot /mnt/gentoo emerge --depclean
fi
