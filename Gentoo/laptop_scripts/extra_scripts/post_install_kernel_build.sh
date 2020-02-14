#/bin/bash

. ../_config.sh
. ../_error_handling.sh

cd /usr/src/linux

make clean
make olddefconfig

# KVM kernel has no modules...
if [ "${KERNEL_CONFIG}" != "kvm" ]; then
  make modules_prepare
fi

make --jobs $(($(nproc) + 1)) --load-average $(nproc)

# KVM kernel has no modules...
if [ "${KERNEL_CONFIG}" != "kvm" ]; then
  make modules_install
fi

#make firmware_install

make bzImage
cp /usr/src/linux/arch/x86/boot/bzImage /boot/vmlinuz-current

# The KVM kernel is very minimal and doesn't use modules
if [ "${KERNEL_CONFIG}" = "kvm" ]; then
  chroot /mnt/gentoo /bin/bash -c 'dracut --no-kernel -f /boot/initramfs-current.img'
else
  chroot /mnt/gentoo /bin/bash -c 'dracut --kver $(ls /lib/modules/ | sort -rn | head -n 1) -f /boot/initramfs-current.img'
fi

# TODO: Should handle firmware for microcode updates...

# May be useful later on... not sure if in standard package repo or something
# sakaki added, but having a static GPG can be useful in the initramfs...
# emerge app-crypt/staticgpg

# Should drop these in a new root / one shot directory
#cat << 'EOF' >  /mnt/gentoo/etc/portage/package.use/initramfs
#dev-libs/libtommath static-libs
#sys-apps/busybox ipv6 static
#net-misc/dropbear minimal multicall static -pam -shadow -syslog -zlib
#EOF
#emerge net-misc/busybox sys-apps/busybox

# To sign the kernel...
#sbsign --key "${KEY}" --cert "${CERT}" \
#  --output "/boot/vmlinuz-current.signed" "/boot/vmlinux-current"

# Also random potentially useful note:

# > Normally. when kernel modules are signed, they are done so with a one-shot
# > key - on each build, a key pair is generated, the private part used to sign
# > the modules then tossed. The public key is then signed by a long-lived
# > signing key.
#
# > There is a module_sign target (not listed in "make help") Makefile target
# > for the linux kernel that signs all the modules after installation, thus
# > one can do make module_install, then install any out of tree packages, then
# > make module_sign to sign them all.
