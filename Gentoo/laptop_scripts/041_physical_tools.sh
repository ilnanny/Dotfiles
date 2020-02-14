#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

if [ "${KERNEL_TARGET}" = "kvm_guest" ]; then
  exit 0
fi

# Install TPM tools. Taking control of it has to be a manual
chroot /mnt/gentoo emerge app-crypt/tpm-tools
chroot /mnt/gentoo rc-update add tcsd boot
