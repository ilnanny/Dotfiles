#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

chroot /mnt/gentoo emerge net-misc/chrony
chroot /mnt/gentoo rc-update add chronyd default

# TODO: This config needs some work, but it's basic and works...
cat << 'EOF' > /mnt/gentoo/etc/chrony/chrony.conf
# /etc/chrony/chrony.conf

# Use the public NTP pool
pool pool.ntp.org iburst

# Step the clock for the first three updates if the difference is larger than a
# second (allows quick clock recovery when highly inaccurate).
makestep 1.0 3

# Ensure we sync our clock the hardware one so it is close to accurate between
# reboots
rtcsync
EOF

# From my personal experience it's good to generally ensure the hardware clock
# doesn't drift to much from true. While the NTP daemon is configured to handle
# this synchronization, it takes a trivial amount of resources to have a cron
# job run periodically to ensure this sync is kept up and redundancies are
# good.
cat << 'EOF' > /mnt/gentoo/etc/cron.daily/hwclock_sync
#!/bin/sh
/sbin/hwclock --utc --systohc
EOF
chmod +x /mnt/gentoo/etc/cron.daily/hwclock_sync
