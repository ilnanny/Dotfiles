#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

exit 0

mkdir -p /mnt/gentoo/etc/portage/package.accept_keywords
echo 'sys-firmware/b43-firmware ~amd64' > /mnt/gentoo/etc/portage/package.accept_keywords/firmware
chroot /mnt/gentoo emerge sys-firmware/b43-firmware
cp ${BASE_DIRECTORY}/gpd_files/brcmfmac4356-pcie.txt /lib/firmware/brcm/

# These aren't necessary anymore :D they come with media-libs/alsa-lib which is
# included by media-sound/alsa-utils

#mkdir -p /usr/share/alsa/ucm/chtrt5645
#cp ${BASE_DIRECTORY}/gpd_files/{chtrt5645.conf,HiFi.conf} /usr/share/alsa/ucm/chtrt5645/
