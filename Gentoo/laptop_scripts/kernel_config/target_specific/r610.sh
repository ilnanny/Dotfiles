#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

./target_specific/intel.sh

log "Running target specific kernel options: r610"

# Support ECC memory
kernel_config --enable MEMORY_FAILURE
kernel_config --enable HWPOISON_INJECT

kernel_config --enable NET_VENDOR_BROADCOM
kernel_config --enable BNX2

# This isn't supported on this platform so don't bother
kernel_config --disable PCIEASPM

# There is a PCI address collision on the R610 motherboard. We need to enable
# the quirk workarounds for it.
kernel_config --enable PCI_QUIRKS

kernel_config --enable WDAT_WDT
kernel_config --enable ACPI_IPMI
kernel_config --enable IPMI_DEVICE_INTERFACE
kernel_config --enable IPMI_HANDLER
kernel_config --enable IPMI_PANIC_EVENT
kernel_config --enable IPMI_POWEROFF
kernel_config --enable IPMI_SI
kernel_config --enable IPMI_SSIF
kernel_config --enable IPMI_WATCHDOG

kernel_config --enable DCDBAS
kernel_config --enable DELL_SMBIOS

kernel_config --enable CHR_DEV_SCH
kernel_config --enable CHR_DEV_ST
kernel_config --enable SCSI_LOWLEVEL
kernel_config --enable SCSI_SCAN_ASYNC

kernel_config --enable RAS_CEC

kernel_config --enable FUSION
kernel_config --enable FUSION_SAS

kernel_config --enable USB_PRINTER
kernel_config --enable USB_UAS

# TODO: Is this useful?
#kernel_config --enable SCSI_SAS_ATTRS

# If I start using iSCSI stuff
#kernel_config --enable SCSI_ISCSI_ATTRS
#kernel_config --enable ISCSI_TCP

# It may be better to include the NFS server in the default kernel but for now
# I'm happy to leave this only on this class of machines.
kernel_config --enable NFSD
kernel_config --enable NFSD_V4
kernel_config --enable NFSD_V4_SECURITY_LABEL

# If I have to support a v3 NFS client I should enable this to allow extending
# POSIX ACLs to clients (it will be enforced on the server no matter what).
#kernel_config --enable NFSD_V3_ACL

# In the future I may want to use this to export virtual machine images over
# NFS...
#kernel_config --enable EXPORTFS_BLOCK_OPS
#kernel_config --enable NFSD_BLOCKLAYOUT
#kernel_config --enable NFSD_SCSILAYOUT
#kernel_config --enable NFSD_FLEXFILELAYOUT

# I may still need one of these for the SAS card
#kernel_config --enable SCSI_MPT2SAS
#kernel_config --enable SCSI_MPT3SAS

# I need to figure out which one of these are in use...
#kernel_config --enable TCG_ATMEL
#kernel_config --enable TCG_INFINEON
#kernel_config --enable TCG_NSC
#kernel_config --enable TCG_TIS_I2C_ATMEL
#kernel_config --enable TCG_TIS_I2C_INFINEON
#kernel_config --enable TCG_TIS_I2C_NUVOTON
#kernel_config --enable TCG_TIS_ST33ZP24_I2C

# Seems the R610 uses this non-standard type to mark some memory as BIOS
# protected, we need to be able to handle it.
kernel_config --enable X86_PMEM_LEGACY

# Don't need this intel specific setting
kernel_config --disable DRM_I915

# Report detected memory errors
kernel_config --enable EDAC_DEBUG
kernel_config --enable EDAC_GHES
kernel_config --enable EDAC_I7CORE

# For lm_sensors
kernel_config --enable SENSORS_CORETEMP
