#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

# TODO: Need to convert this to support local mode

mkdir -p /mnt/gentoo/etc/portage/package.accept_keywords
echo 'sys-process/audit ~amd64' > /mnt/gentoo/etc/portage/package.accept_keywords/auditd

chroot /mnt/gentoo emerge sys-process/audit

#chroot /mnt/gentoo rc-update add auditd boot

rm -f /mnt/gentoo/etc/audisp/plugins.d/*

# The livecd version of curl has SSL validation issues... Maybe no SNI support?
chroot /mnt/gentoo curl -s -o /etc/audisp/audispd.conf https://stelfox.net/note_files/auditd/audispd.conf
chroot /mnt/gentoo curl -s -o /etc/audisp/plugins.d/audispd_syslog.conf https://stelfox.net/note_files/auditd/audispd_syslog.conf
chroot /mnt/gentoo curl -s -o /etc/audit/auditd.conf https://stelfox.net/note_files/auditd/auditd.conf
chroot /mnt/gentoo curl -s -o /etc/audit/audit.rules https://stelfox.net/note_files/auditd/audit.rules

truncate -c -s 0 /mnt/gentoo/etc/audit/audit.rules.stop.post
truncate -c -s 0 /mnt/gentoo/etc/audit/audit.rules.stop.post
truncate -c -s 0 /mnt/gentoo/etc/audit/audit.rules.stop.pre
