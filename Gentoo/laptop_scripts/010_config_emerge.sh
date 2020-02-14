#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

if [ -n "${BIN_HOST:-}" ]; then
  binpkgfeature="getbinpkg"
fi

# Using these options will make the initial system builds go faster, but when
# used as a base image may cause issues as they don't get continuously updated
# with the actual system's CPU information
#EMERGE_DEFAULT_OPTS="--jobs $(($(nproc) + 1)) --load-average $(nproc)"

cat << EOF > /mnt/gentoo/etc/portage/make.conf
CFLAGS="-O2 -pipe"
CXXFLAGS="\${CFLAGS}"
CHOST="x86_64-pc-linux-gnu"

EMERGE_DEFAULT_OPTS="--binpkg-respect-use=y"
FEATURES="buildpkg cgroup ipc-sandbox network-sandbox ${binpkgfeature:-}"
USE="audit caps cgroups kerberos python -perl -systemd -tcpd"

GRUB_PLATFORMS="efi-64 pc"
POLICY_TYPES="strict"

L10N="it"
LINGUAS="it"
EOF

if [ -n "${GENTOO_MIRRORS:-}" ]; then
  echo -e "\nGENTOO_MIRRORS=\"${GENTOO_MIRRORS}\"" >> /mnt/gentoo/etc/portage/make.conf
elif [ "${LOCAL}" != "yes" ]; then
  mirrorselect -o -s 3 -q -D -H -R 'North America' 2> /dev/null >> /mnt/gentoo/etc/portage/make.conf
fi

if [ -n "${BIN_HOST:-}" ]; then
  echo "PORTAGE_BINHOST=\"${BIN_HOST}\"" >> /mnt/gentoo/etc/portage/make.conf
fi

mkdir -p /mnt/gentoo/etc/portage/package.use
echo 'app-shells/bash -net' > /mnt/gentoo/etc/portage/package.use/bash
