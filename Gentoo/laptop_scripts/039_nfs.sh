#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

# If we used an NFS source for our portage during installation, set up the
# client and mount the directory automagically
if [ -z "${NFS_SOURCE}" ]; then
  exit 0
fi

echo 'net-fs/nfs-utils nfsdcld nfsv41' > /mnt/gentoo/etc/portage/package.use/nfs

chroot /mnt/gentoo emerge net-fs/nfs-utils

# TODO: Once kerberos is setup I should set the sec mode to 'krb5p'. I may need
# to remove 'noexec' from this... When not on a build server, I should probably
# have this as read only as well.
echo '192.168.122.1:/cache      /usr/portage  nfs4  rw,noatime,noauto,nodev,noexec,nosuid  0 0' >> /mnt/gentoo/etc/fstab

# The following should be the build host export (ideally with sec=krb5p for integrity and encryption)
# /etc/exports
#
# /srv/build/stable    2604:a880:800:10::/48(ro,no_subtree_check,root_squash)    10.0.0.0/8(ro,no_subtree_check,root_squash)
