#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Setting some unnecessary options that are personal preferences"

# Expose a copy of the kernel's running config through /proc/config.gz
kernel_config --enable IKCONFIG
kernel_config --enable IKCONFIG_PROC
kernel_config --enable BUILD_BIN2C

# Prefer just using the BFQ scheduler
kernel_config --disable MQ_IOSCHED_DEADLINE
kernel_config --disable MQ_IOSCHED_KYBER
kernel_config --enable IOSCHED_BFQ

# Enable the hangcheck timer, it's like an internal watchdog system that will
# automatically reboot the system is certain parts of the kernel become
# unresponsive. Can't hurt to have another mechanism to automatically recover
# from failures.
kernel_config --enable HANGCHECK_TIMER

# Seems arch defaults its kernel loglevel default to the equivalent quiet
# default. These settings will match the arch linux versions. I don't know if I
# would prefer that or not.
#kernel_config --set-val CONSOLE_LOGLEVEL_DEFAULT 4
#kernel_config --undefine CONSOLE_LOGLEVEL_QUIET

kernel_config --enable BPFILTER
