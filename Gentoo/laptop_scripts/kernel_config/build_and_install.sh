#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

if [ ! -f /usr/src/linux/.config ]; then
  echo "A kernel config need to be in place before a kernel can be installed..."
  exit 1
fi

if [ "${EUID}" != "0" ]; then
  echo "This needs to be done by root"
  exit 2
fi

# TODO: initrd creation for embedding in the kernel

log "Beginning kernel compilation..."
run_command /usr/src/linux make -j $(nproc)

log "Installing new kernel..."
run_command /usr/src/linux cp ./arch/x86/boot/bzImage /boot/vmlinuz-current

log "Installation complete"
