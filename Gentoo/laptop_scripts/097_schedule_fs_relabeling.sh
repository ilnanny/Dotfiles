#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

cat << 'EOF' > /mnt/gentoo/root/first_boot.sh
#!/bin/bash

# Refresh the security labeling of all files and identities
/usr/sbin/rlpkg -ar

# Cleanup this script and remove it from the crontab
/bin/rm -f /root/first_boot.sh
/usr/bin/crontab -r
EOF

chmod +x /mnt/gentoo/root/first_boot.sh

echo '@reboot ( /root/first_boot.sh )' | chroot /mnt/gentoo crontab -
