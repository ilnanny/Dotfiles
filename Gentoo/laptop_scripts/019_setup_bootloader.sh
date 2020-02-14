#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

if [ "${EFI}" = "yes" ]; then
  mkdir -p /mnt/gentoo/etc/portage/package.accept_keywords
  echo 'app-crypt/efitools ~amd64' > /mnt/gentoo/etc/portage/package.accept_keywords/efi

  chroot /mnt/gentoo emerge app-crypt/efitools sys-boot/efibootmgr
fi

chroot /mnt/gentoo emerge sys-boot/grub

# We want to additionally spit out the kernel messages to the KVM serial
# console
if [ "${KERNEL_TARGET}" = "kvm_guest" ]; then
  ADDITIONAL_BOOT_OPTS="console=tty0 console=ttyS0,115200n8"
fi

# GPD also wants "i915.fastboot=1 fbcon=rotate:1"
# Plymouth wants "quiet splash"
cat << EOF > /mnt/gentoo/etc/default/grub
# /etc/default/grub

GRUB_CMDLINE_LINUX_DEFAULT="lvm net.ifnames=0 ${ADDITIONAL_BOOT_OPTS:-}"

GRUB_DEFAULT=1
GRUB_TIMEOUT=3

GRUB_DISABLE_LINUX_UUID=false
GRUB_DISABLE_RECOVERY=true
GRUB_DISABLE_SUBMENU=y

GRUB_DISTRIBUTOR="Whisper"
EOF

# Enable grub on both the standard console and over serial when using the KVM
# kernel
if [ "${KERNEL_TARGET}" = "kvm_guest" ]; then
  cat << 'EOF' >> /mnt/gentoo/etc/default/grub

GRUB_TERMINAL="console serial"
GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"
EOF
fi

# For some stupid reason this kernel is getting installed...
rm -f /mnt/gentoo/boot/*-openstack

if [ "${EFI}" = "yes" ]; then
  chroot /mnt/gentoo grub-install --target=x86_64-efi --efi-directory=/boot --removable

  # TODO: efitools to setup / sign EFI applications:
  # http://tomsblog.gschwinds.net/2014/08/uefi-secure-boot-hands-on-experience/
else
  chroot /mnt/gentoo grub-install --target=i386-pc ${DISK}
fi

chroot /mnt/gentoo grub-mkconfig -o /boot/grub/grub.cfg
