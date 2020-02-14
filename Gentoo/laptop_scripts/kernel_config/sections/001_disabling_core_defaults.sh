#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Disabling selective core default features"

# TODO: I've never been sure about this. It probably makes sense for a VM host
# but does this help me or do anything at all under normal workloads? Maybe for
# forked processes? Needs additional research.
kernel_config --disable KSM

# This is specifically virtual hosting (allowing guests to run under this
# kernel). Generally my kernels are used more as guests and thus don't need
# this whole class of options.
kernel_config --disable VIRTUALIZATION
kernel_config --disable VIRTIO_MENU

# This is a legacy compatibility layer I won't be using
kernel_config --disable USELIB

# For servers and server workloads we want to disable kernel preemption to
# allow it to prioritise work over an interactive session's latency.
kernel_config --enable PREEMPT_NONE
kernel_config --disable PREEMPT_VOLUNTARY

# Don't support some obscure extended platforms
kernel_config --disable X86_EXTENDED_PLATFORM

# I don't need core dumps and they may reveal sensitive memory contents
kernel_config --disable CRASH_DUMP

kernel_config --enable EXPERT
kernel_config --disable ELF_CORE

# No. Just No.
kernel_config --disable PCSPKR_PLATFORM

# This is an interesting feature but can allow unprivileged triggering of
# certain behaviors such as hard rebooting. The kernels are stable enough that
# the magic sequences have the potential for more harm than good.
kernel_config --disable MAGIC_SYSRQ

# These compression methods aren't ever used by me, eventually I'll likely want
# to disable LZ4 as well when I embed the initramfs CPIO file in the kernel
# itself for EFI but until then it's the only one I need.
kernel_config --disable RD_BZIP2
kernel_config --disable RD_GZIP
kernel_config --disable RD_LZMA
kernel_config --disable RD_LZO
kernel_config --disable RD_XZ

# Use LZ4 to compress the kernel instead of the Gzip default
kernel_config --disable KERNEL_GZIP
kernel_config --enable KERNEL_LZ4

kernel_config --disable SUSPEND
kernel_config --disable HIBERNATION

kernel_config --disable ACPI_AC
kernel_config --disable ACPI_BATTERY
kernel_config --disable ACPI_DOCK
kernel_config --disable ACPI_FAN
kernel_config --disable ACPI_VIDEO

# Not sure what might actually use this but I'm going to disable this until
# something indicates otherwise. I should definitely test a few things with
# this.
kernel_config --disable CONNECTOR

# Disable the old school legacy application emulation support. Since I'm using
# a Gentoo target all of my code should be freshly compiled and not require
# this fallback. I've been wrong before though...
kernel_config --disable LEGACY_VSYSCALL_EMULATE
kernel_config --enable LEGACY_VSYSCALL_NONE

# Another couple of legacy emulation layers that I don't need
kernel_config --disable MODIFY_LDT_SYSCALL
kernel_config --disable X86_VSYSCALL_EMULATION

# TODO: Test if this is needed, I kind of doubt it for modern systems
kernel_config --disable ISA_DMA_API

kernel_config --disable MODULE_UNLOAD

kernel_config --disable IP_MROUTE
kernel_config --disable IP_MULTIPLE_TABLES
kernel_config --disable IP_PNP

# This may be necessary to enable for physical hardware
kernel_config --disable PCI_QUIRKS
kernel_config --disable HOTPLUG_PCI

# Disable modules, just bake everything in. It simplifies a lot and removes the
# main vector backdoors get into the kernel.
kernel_config --disable MODULES
