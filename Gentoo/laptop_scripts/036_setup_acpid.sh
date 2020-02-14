#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

# Fully virtual machines don't need ACPId
if [ "${KERNEL_TARGET}" = "kvm_guest" ]; then
  exit 0
fi

chroot /mnt/gentoo emerge sys-power/acpid sys-power/acpitool sys-power/acpi
chroot /mnt/gentoo rc-update add acpid default
