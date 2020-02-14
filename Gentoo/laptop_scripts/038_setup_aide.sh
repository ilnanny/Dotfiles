#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

echo 'app-forensics/aide mhash' > /mnt/gentoo/etc/portage/package.use/aide

chroot /mnt/gentoo emerge app-forensics/aide
chroot /mnt/gentoo mkdir -p /var/lib/aide/reference

chroot /mnt/gentoo curl -s -o /etc/aide/aide.conf https://stelfox.net/note_files/aide/aide.conf
chmod 0600 /mnt/gentoo/etc/aide/aide.conf
chown root:root /mnt/gentoo/etc/aide/aide.conf

chroot /mnt/gentoo /usr/bin/aide --init
