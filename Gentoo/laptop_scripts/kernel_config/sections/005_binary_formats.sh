#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Configuring binary execution options"

# Neither of these are required for general use
kernel_config --disable BINFMT_MISC
kernel_config --disable COREDUMP

# I also don't need to be able to execute / emulate 32 bit code
kernel_config --disable IA32_EMULATION
