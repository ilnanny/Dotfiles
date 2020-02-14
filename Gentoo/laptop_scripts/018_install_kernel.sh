#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

mkdir -p /mnt/gentoo/etc/portage/package.accept_keywords
echo 'sys-kernel/gentoo-sources ~amd64' > /mnt/gentoo/etc/portage/package.accept_keywords/kernel
chroot /mnt/gentoo emerge sys-kernel/gentoo-sources

# TODO: sys-firmware/intel-microcode needs to be loaded, the following page has
# information on how to build the firmware into the kernel:
# https://wiki.gentoo.org/wiki/Intel_microcode
#
# TODO: Make this a config option...
#
# Quick summary:
# * emerge sys-firmware/intel-microcode sys-apps/iucode_tool
# * iucode_tool -S
# * Pay attention to the signature value
# * iucode_tool -S -l /lib/firmware/intel-ucode/*
# * Look at the selected microcodes, for each one it has a prefix like
#   '049/001'. This means the applicable microcode is in bundle '49'. The rest
#   of the output will give you the specific path where that firmware is
#   stored.
# * In the kernel ensure Processor type... -> CPU microcode loading... Intel...
#   is enabled
# * In the kernel ensure Device Drivers -> Generic Driver... -> Include
#   in-kernel is selected, add 'intel-ucode/<filename>' to the external
#   firmware blobs to build... and '/lib/firmware' as the firmware blobs root
#   directory.
# * Testing can be done (after a fresh boot) with: dmesg | grep microcode.
#   Should show lines indicating the updates.

./kernel_config/create_config.sh ${KERNEL_TARGET}
chroot /mnt/gentoo /bin/bash -c "cd /usr/src/linux; make --jobs $(($(nproc) + 1)) --load-average $(nproc)"

# KVM kernel has no modules...
#if [ "${KERNEL_TARGET}" != "kvm_guest" ]; then
#  chroot /mnt/gentoo /bin/bash -c "cd /usr/src/linux; make modules_install"
#fi

chroot /mnt/gentoo /bin/bash -c "cd /usr/src/linux; make bzImage"
chroot /mnt/gentoo /bin/bash -c "cp /usr/src/linux/arch/x86/boot/bzImage /boot/vmlinuz-current"

# TODO: boot process measurements aren't a bad idea, two projects are built
# into dracut for handling this 'app-benchmarks/bootchart2' and
# 'sys-process/acct' I may want to look at these in the future...

cat << 'EOF' > /mnt/gentoo/etc/dracut.conf.d/00_base_system.conf
# /etc/dracut.conf.d/00_base_system.conf

dracutmodules="base bash caps crypt dm i18n kernel-modules lvm rootfs-block selinux terminfo udev-rules usrmount"

#add_dracutmodules+="plymouth"

compress="lz4"
hostonly="no"
reproducible="yes"

do_strip="yes"
do_prelink="no"

persistent_policy="by-uuid"
EOF

#if [ "${KERNEL_TARGET}" = "kvm_guest" ]; then
  # The KVM kernel is very minimal and doesn't use modules, if it wasn't for
  # the posibility of encryption I wouldn't use a initramfs at all...
  # TODO: When encryption isn't used and we're on the KVM kernel skip dracut
  # and the initramfs altogether...
  chroot /mnt/gentoo /bin/bash -c 'dracut --no-kernel -f /boot/initramfs-current.img'
#else
  # Build an initramfs using the latest kernel modules (there should only be
  # one but it never hurts to be sure)
#  chroot /mnt/gentoo /bin/bash -c 'dracut --kver $(ls /lib/modules/ | sort -rn | head -n 1) -f /boot/initramfs-current.img'
#fi

exit 0

# This is for my personal take on the initramfs...
cat << 'EOF' >  /mnt/gentoo/etc/portage/package.use/initramfs
dev-libs/libtommath static-libs
sys-apps/busybox ipv6 static
net-misc/dropbear minimal multicall static -pam -shadow -syslog -zlib
EOF
emerge net-misc/busybox sys-apps/busybox
