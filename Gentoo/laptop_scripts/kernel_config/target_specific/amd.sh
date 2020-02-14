#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

./target_specific/physical_system.sh

log "Running target specific kernel options: amd"

kernel_config --enable CPU_SUP_AMD

kernel_config --enable AMD_MEM_ENCRYPT
kernel_config --enable EDAC_DECODE_MCE
kernel_config --enable PERF_EVENTS_AMD_POWER
kernel_config --enable X86_MCE_AMD
kernel_config --enable X86_AMD_PLATFORM_DEVICE
kernel_config --enable CRYPTO_DEV_CCP

# Optimize the kernel with newer Intel instructions
kernel_config --disable GENERIC_CPU
kernel_config --enable MK8

kernel_config --enable IOMMU_SUPPORT
kernel_config --enable AMD_IOMMU

kernel_config --enable MICROCODE
kernel_config --enable MICROCODE_AMD

kernel_config --enable KVM_AMD
