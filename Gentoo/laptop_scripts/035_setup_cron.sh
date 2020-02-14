#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

echo 'sys-process/cronie anacron' > /mnt/gentoo/etc/portage/package.use/cron

# Prevent all users (except for root) from using cron until they're explicitly
# allowed.
touch /mnt/gentoo/etc/cron.allow

chroot /mnt/gentoo emerge sys-process/cronie
chroot /mnt/gentoo rc-update add cronie default
