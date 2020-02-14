#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

chroot /mnt/gentoo groupadd -r sudoers &> /dev/null || true
chroot /mnt/gentoo groupadd -r sshers &> /dev/null || true

chroot /mnt/gentoo useradd -mU -G sshers,sudoers -s /bin/bash -c "${ADMIN_NAME}" ${ADMIN_USER} &> /dev/null || true
sed -i '/^root:/d' /mnt/gentoo/etc/mail/aliases
echo "root: ${ADMIN_USER}" >> /mnt/gentoo/etc/mail/aliases
chroot /mnt/gentoo newaliases

mkdir -p /mnt/gentoo/home/${ADMIN_USER}/.ssh
curl https://github.com/${GITHUB_KEY_USER}.keys > /mnt/gentoo/home/${ADMIN_USER}/.ssh/authorized_keys
chroot /mnt/gentoo chown -R ${ADMIN_USER}:${ADMIN_USER} /home/${ADMIN_USER}
chmod -R u=rwX,g=rX,o= /mnt/gentoo/home/${ADMIN_USER}
chmod 0600 /mnt/gentoo/home/${ADMIN_USER}/.ssh/authorized_keys

# Disable the root account
chroot /mnt/gentoo passwd -d root
chroot /mnt/gentoo usermod -L root
