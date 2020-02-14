#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Running target specific kernel options: kvm_guest"

kernel_config --enable VIRTIO_MENU

kernel_config --enable HYPERVISOR_GUEST
kernel_config --enable PARAVIRT
kernel_config --enable VIRTIO_PCI

# Note to self: This driver's description is hilarious, I may want it but all
# my hosts should be new and not need this.
kernel_config --disable VIRTIO_PCI_LEGACY

kernel_config --enable VIRTIO_BALLOON
kernel_config --enable VIRTIO_BLK
kernel_config --enable VIRTIO_CONSOLE
kernel_config --enable VIRTIO_INPUT
kernel_config --enable VIRTIO_NET

kernel_config --enable CRYPTO_DEV_VIRTIO
kernel_config --enable DRM_VIRTIO_GPU
kernel_config --enable HW_RANDOM_VIRTIO
kernel_config --enable PARAVIRT_SPINLOCKS
kernel_config --enable RPMSG_VIRTIO

kernel_config --enable SOFT_WATCHDOG
kernel_config --enable SOFT_WATCHDOG_PRETIMEOUT

# Allow the VM host to add and remove memory
kernel_config --enable MEMORY_HOTPLUG
kernel_config --enable MEMORY_HOTPLUG_DEFAULT_ONLINE
kernel_config --enable MEMORY_HOTREMOVE

kernel_config --enable PVPANIC

# These also might be needed... but maybe not?
#kernel_config --enable SCSI_VIRTIO
#kernel_config --enable VIRTIO_BLK_SCSI
#kernel_config --enable VIRTIO_MMIO
#kernel_config --enable VIRTIO_VSOCKETS
#kernel_config --enable VIRTIO_VSOCKETS_COMMON
