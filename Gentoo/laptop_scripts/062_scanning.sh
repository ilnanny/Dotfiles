#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

# I don't want this running automatically...
exit 0

cat << 'EOF' > /etc/portage/package.use/scanning
app-text/xmlto text
dev-libs/libusb udev
dev-libs/libgusb vala
virtual/libusb udev
EOF

# Our backend has to come from an external package :-/
echo 'SANE_BACKENDS=""' >> /etc/portage/make.conf

emerge media-gfx/sane-backends media-gfx/sane-frontends media-gfx/simple-scan

usermod -a -G scanner ${ADMIN_USER}

# I needed to pull the closed source brother drivers off their site. They
# haven't continued updating them so I grabbed all of them and archived them in
# a file 'brother_linux_drivers.txz' on my file server.
#
# Each of the rpms needed to convert to cpio using rpm2cpio, from there I
# extracted them using 'cat <file> | cpio -idmv' and tarred up the contents. I
# need to make these into an ebuild...
#
# Apparently CONFIG_USB_PRINTER should be configured as a module.

# Quick conversion script... You'll need to do it as root to preserve
# permissions

#SRC_DIR=$(pwd)
#for i in *.cpio; do
#  CPIO_TMP_DIR="$(mktemp -d /tmp/cpioconv.XXXX)"
#  (cd ${CPIO_TMP_DIR} && cpio -idm < "${SRC_DIR}/${i}" && tar -cf ${SRC_DIR}/${i%%.cpio}.tar .)
#  rm -rf ${CPIO_TMP_DIR}
#done

# I extracted the brsane3 tarball onto my system and the whole thing crashed
# and I haven't been able to recover it yet... Skkkkeeetttchhhyyyy.... On a
# better note it looks like there is a well maintained overlay for handling
# brother printers and MFCs.
#
# I should be able to use the overlay with the following (though I should
# consider forking / merging with my overlay...).
cat << 'EOF' > /etc/portage/repos.conf/brother-overlay.conf
[brother-overlay]
location = /usr/local/portage/brother-overlay
sync-type = git
sync-uri = https://github.com/stefan-langenmaier/brother-overlay.git
priority=9999
EOF

emerge --sync
echo 'media-gfx/sane-backends usb' > /etc/portage/package.use/scanner
emerge media-gfx/brother-scan3-bin

# Maybe also:
#emerge media-gfx/brother-mfc7840w-bin
# Or maybe this instead (this is the generic driver):
#emerge net-print/brother-genml1-bin
#
# Could use this method to check its available:
#/usr/sbin/lpinfo -m | grep -i brother
#
# Tons of notes here: https://wiki.gentoo.org/wiki/Brother_networked_printer#Preferred:_Using_drivers_from_ebuild_repositories
