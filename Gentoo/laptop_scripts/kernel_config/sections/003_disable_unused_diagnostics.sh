#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

# There are a lot of diagnostic flags turned on by default that don't provide
# any runtime diagnostics, and are primarily targetted at kernel developers.
# They usually have a runtime cost associated with them. I disable these to
# squeeze out a bit more performance at very little potential cost to my use
# cases.

log "Disabling unused diagnostic information"

kernel_config --disable ATA_VERBOSE_ERROR
kernel_config --disable BUG
kernel_config --disable DEBUG_BOOT_PARAMS
kernel_config --disable DEBUG_BUGVERBOSE
kernel_config --disable DEBUG_MEMORY_INIT
kernel_config --disable DEBUG_STACK_USAGE
kernel_config --disable DYNAMIC_EVENTS
kernel_config --disable EARLY_PRINTK_DBGP
kernel_config --disable EVENT_TRACING
kernel_config --disable FTRACE
kernel_config --disable KALLSYMS
kernel_config --disable KPROBES
kernel_config --disable PM_DEBUG
kernel_config --disable PNP_DEBUG_MESSAGES
kernel_config --disable PROFILING
kernel_config --disable PROVIDE_OHCI1394_DMA_INIT
kernel_config --disable RCU_TRACE
kernel_config --disable RUNTIME_TESTING_MENU
kernel_config --disable SCHEDSTATS
kernel_config --disable SCSI_CONSTANTS
kernel_config --disable SLUB_DEBUG
kernel_config --disable STACKTRACE
kernel_config --disable UPROBE_EVENTS

# This doesn't quite belong here, but trigger a compilation warning for section
# mismatches.
kernel_config --disable SECTION_MISMATCH_WARN_ONLY

kernel_config --disable ALLOW_DEV_COREDUMP
kernel_config --disable DEBUG_DEVRES
