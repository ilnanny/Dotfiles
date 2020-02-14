#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Removing any existing kernel config and all build artifacts"
run_command /usr/src/linux make mrproper

# Start with a completely standard config, we'll enable / disable hardware
# support and software selection as we need / want to for our appropriate
# base config and specific targets.
log "Creating the default kernel config"
run_command /usr/src/linux make defconfig
