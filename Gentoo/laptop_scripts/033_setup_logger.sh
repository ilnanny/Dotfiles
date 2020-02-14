#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

# TODO: Need to convert this to support local mode

mkdir -p /mnt/gentoo/etc/portage/package.use
echo 'app-admin/syslog-ng json' > /mnt/gentoo/etc/portage/package.use/syslog-ng

chroot /mnt/gentoo emerge app-admin/syslog-ng
chroot /mnt/gentoo rc-update add syslog-ng default

chroot /mnt/gentoo curl -s -o /etc/syslog-ng/syslog-ng.conf https://stelfox.net/note_files/syslog-ng/syslog-ng.conf
