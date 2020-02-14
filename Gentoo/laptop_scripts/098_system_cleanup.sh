#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

chroot /mnt/gentoo emerge --depclean
chroot /mnt/gentoo eselect news read all > /dev/null
chroot /mnt/gentoo find /etc -iname '._cfg*' -exec rm {} \;

rm -rf /mnt/gentoo{/etc/ssh/ssh_host_*,/root/.bash_history,/home/${ADMIN_USER}/.bash_history}
