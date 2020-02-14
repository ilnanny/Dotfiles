#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Configuring the available filesystems"

# Allow access to AHCI commands for SATA attached devices. This allows
# increased performance in both virtual and physical machines.
kernel_config --enable SATA_AHCI_PLATFORM

# Allow encrypted datamapper targets (and allow authenticated encryption using
# the integrity options)
kernel_config --enable DM_CRYPT
kernel_config --enable DM_INTEGRITY

# EXT4 isn't necessary for me
kernel_config --disable EXT4_FS

# XFS is my root filesystem of choice
kernel_config --enable XFS_FS
kernel_config --enable XFS_POSIX_ACL
kernel_config --enable XFS_ONLINE_SCRUB
kernel_config --enable XFS_ONLINE_REPAIR

# Quota support isn't needed for my systems
kernel_config --disable QUOTA

# Old school AutoFS support also isn't needed
kernel_config --disable AUTOFS4_FS
kernel_config --disable AUTOFS_FS

# Disable ISO filesystems
kernel_config --disable ISO9660_FS

# Tweaks to DOS/Win filesystems
kernel_config --disable MSDOS_FS
kernel_config --enable FAT_DEFAULT_UTF8

# Tweaks to the proc filesystem, both security and sanity reasons
kernel_config --disable PROC_KCORE

# TODO: This might be worth disabling if not necessary
#kernel_config --disable PROC_PAGE_MONITOR

# Random other filesystems
kernel_config --disable MISC_FILESYSTEMS

# Enable NFS client (but version 4.x only)
kernel_config --enable NFS_FS

kernel_config --disable NFS_V2
kernel_config --disable NFS_V3

kernel_config --enable NFS_V4
kernel_config --enable NFS_V4_1
kernel_config --enable NFS_V4_2
kernel_config --set-val NFS_V4_1_IMPLEMENTATION_ID_DOMAIN "kernel.org"
kernel_config --enable NFS_V4_SECURITY_LABEL

# This would be pretty neat to play around with at some point for some of my
# virtual machines but I don't need it for now.
#kernel_config --disable ROOT_NFS

# Eventually I will play with Ceph, I'll want to enable this:
#kernel_config --enable CEPH_FS
#kernel_config --enable CEPH_FS_POSIX_ACL
#kernel_config --enable CEPH_LIB
#kernel_config --enable BLK_DEV_RBD

# Samba / CIFS
#kernel_config --enable CIFS
#kernel_config --disable CIFS_ALLOW_INSECURE_LEGACY
#kernel_config --enable CIFS_UPCALL
#kernel_config --enable CIFS_XATTR
#kernel_config --enable CIFS_ACL
#kernel_config --enable CIFS_DFS_UPCALL

# Various block layer stuff I don't need
kernel_config --disable BLK_DEBUG_FS
kernel_config --disable BLK_DEV_BSG

# Get rid of various partition types we don't need
kernel_config --disable AMIGA_PARTITION
kernel_config --disable BSD_DISKLABEL
kernel_config --disable KARMA_PARTITION
kernel_config --disable MAC_PARTITION
kernel_config --disable MINIX_SUBPARTITION
kernel_config --disable OSF_PARTITION
kernel_config --disable SGI_PARTITION
kernel_config --disable SUN_PARTITION
kernel_config --disable SOLARIS_X86_PARTITION
kernel_config --disable UNIXWARE_DISKLABEL

# Various EFI settings

# Allow choosing the next entry to boot into
kernel_config --enable EFI_BOOTLOADER_CONTROL

# NOTE: DO NOT Enable EFI_VARS* as data corruption can happen for anything that
# uses that interface mixed with the new EFIVAR_FS system.
# https://bugzilla.redhat.com/show_bug.cgi?id=1252137
kernel_config --disable EFI_VARS
kernel_config --enable EFIVAR_FS

# Allow the kernel to be booted directly by UEFI, but also via a normal bootloader
kernel_config --enable EFI_STUB

# If the firmware is 32-bit I may need to enable this for EFI boot handoff
#kernel_config --enable EFI_MIXED

# Allow the kernel to print it's diagnostics to the EFI framebuffer early on
kernel_config --enable EARLY_PRINTK_EFI

# This avoids a vulnerability in EFI systems that could allow said attacker to
# reboot the system without clearing secrets from RAM. For this to not cause
# excessive delays userland needs to be configured to clear the
# MemoryOverwriteRequest flag on a clean shutdown. TODO: I need to create a
# service target for this.
#
#kernel_config --enable RESET_ATTACK_MITIGATION

# Framebuffer / early output control including graphics & text. The EFI & VESA
# framebuffers are fallbacks for the simple framebuffer which is newer. Note: I
# probably don't need the fallbacks anymore.
kernel_config --enable FB_EFI
kernel_config --enable FB_VESA
kernel_config --enable X86_SYSFB
kernel_config --enable FB_SIMPLE

kernel_config --enable VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT
kernel_config --enable FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER

# Enable the crypto required for the disk encryption setup in this repo
kernel_config --enable CRYPTO_XTS
kernel_config --enable CRYPTO_AES_X86_64

kernel_config --enable PROC_CHILDREN

# Additional cgroup and namespace bits, mostly used by containerization stuff
kernel_config --enable BLK_CGROUP
kernel_config --enable CGROUP_DEVICE
kernel_config --enable CGROUP_HUGETLB
kernel_config --enable CGROUP_PIDS
kernel_config --enable MEMCG
kernel_config --enable MEMCG_SWAP
kernel_config --enable USER_NS
