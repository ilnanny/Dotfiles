#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

cat << 'EOF' > /mnt/gentoo/etc/environment
# /etc/environment

# This file is parsed by the pam_env module
# Syntax: simple "KEY=VAL" pairs on separate lines
EOF

eval `blkid -o export ${DISK}2`

cat << EOF > /mnt/gentoo/etc/fstab
# /etc/fstab

UUID="${UUID}"            /boot   vfat  defaults,noatime,noexec   0 2
/dev/mapper/system-swap   none    swap  defaults                  0 0
/dev/mapper/system-root   /       xfs   defaults,noatime          0 1

tmpfs                     /tmp   tmpfs  rw,noatime,nodev,nosuid   0 0
EOF

if [ "${ENCRYPTED}" = "yes" ]; then
  chroot /mnt/gentoo emerge sys-fs/cryptsetup
  echo "crypt       ${DISK}3    luks" > /mnt/gentoo/etc/crypttab
fi

cat << 'EOF' > /mnt/gentoo/etc/issue.net
You are accessing a private system that is provided for authorized use only.
Users (authorized or unauthorized) should have no expectation of privacy.

Any or all uses of this system, and any communications occurring on this system
may be intercepted, monitored, recorded, copied, audited, inspected, and
disclosed for purposes including, but not limited to, network defense, quality
control, diagnostics, or detecting user misconduct. Protection systems in place
are not provided for the benefit of users or their privacy and may be modified
or eliminated at the system owners discretion.

By using this system, you indicate your awareness of, and consent to these
terms, conditions of use, all related policies, procedures, and guidelines.
Unauthorized or improper use of this system may result in civil and/or criminal
penalties.
EOF

cat - /mnt/gentoo/etc/issue.net  << 'EOF' > /mnt/gentoo/etc/issue

You are logging in to \n on terminal \l.
This system is also accessible on \4 and \6.

EOF

# I hate the env-update path joining mechanism... I don't want the 50baselayout
# file but I can't remove it... It will simply be replaced when I update so I
# have to set the path I actually want well ahead of the others and hope the
# other paths never get polluted...
#
# TODO: I could truncate the objectionable files so they won't be overridden...
# Or I could have a file in /etc/profile.d straight override the paths...
cat << 'EOF' > /mnt/gentoo/etc/env.d/00prioritypath
PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
ROOTPATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
EOF

# Any changes to /etc/env.d should cause us to run this script
chroot /mnt/gentoo /usr/sbin/env-update

cat << 'EOF' > /mnt/gentoo/etc/profile.d/editor_preference.sh
# /etc/profile.d/editor_preference.sh
export EDITOR="/usr/bin/vim"
EOF

cat << 'EOF' > /mnt/gentoo/etc/profile.d/security_tweaks.sh
# /etc/profile.d/security_tweaks.sh

# Disable shell, pipe, editing and other more dangerous commands inside of the
# less pager.
readonly LESSSECURE=1

if [ "${EUID}" = "0" ]; then
  # Ensure any carelessly left open administrative terminals will automatically
  # close after half an hour.
  readonly TMOUT=1800
fi
EOF

echo UTC > /mnt/gentoo/etc/timezone
chroot /mnt/gentoo emerge --config sys-libs/timezone-data &> /dev/null

chown root:users /mnt/gentoo/home
chmod 0751 /mnt/gentoo/home
