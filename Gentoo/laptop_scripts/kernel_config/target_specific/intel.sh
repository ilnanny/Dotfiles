#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

./target_specific/physical_system.sh

log "Running target specific kernel options: intel"

kernel_config --enable CPU_SUP_INTEL
kernel_config --enable INTEL_IDLE
kernel_config --enable X86_CPU_RESCTRL
kernel_config --enable X86_INTEL_PSTATE
kernel_config --enable X86_P4_CLOCKMOD

kernel_config --enable CONFIG_MICROCODE
kernel_config --enable CONFIG_MICROCODE_AMD
kernel_config --enable CONFIG_MICROCODE_INTEL

kernel_config --enable HW_RANDOM_INTEL

kernel_config --enable IOMMU_SUPPORT
kernel_config --enable INTEL_IOATDMA
kernel_config --enable INTEL_IOMMU
kernel_config --enable INTEL_IOMMU_SVM
kernel_config --enable INTEL_ISH_HID
kernel_config --enable INTEL_PCH_THERMAL
kernel_config --enable INTEL_TXT
kernel_config --enable INTEL_TURBO_MAX_3
kernel_config --enable CRYPTO_AES_NI_INTEL
kernel_config --enable CRYPTO_CRC32C_INTEL

kernel_config --enable DRM_I915
kernel_config --disable DRM_I915_CAPTURE_ERROR

kernel_config --enable MTRR
kernel_config --enable SCHED_MC_PRIO

kernel_config --enable X86_INTEL_MEMORY_PROTECTION_KEYS
kernel_config --enable X86_INTEL_MPX
kernel_config --enable X86_MCE_INTEL

kernel_config --enable PERF_EVENTS_INTEL_CSTATE
kernel_config --enable PERF_EVENTS_INTEL_RAPL
kernel_config --enable PERF_EVENTS_INTEL_UNCORE

# Optimize the kernel with newer Intel instructions
kernel_config --disable GENERIC_CPU
kernel_config --enable MCORE2

kernel_config --enable KVM_INTEL

kernel_config --enable ITCO_WDT
kernel_config --enable ITCO_VENDOR_SUPPORT

kernel_config --enable MICROCODE
kernel_config --enable MICROCODE_INTEL

# NOTE: I may be able to use EXTRA_FIRMWARE to inject the intel microcode...
