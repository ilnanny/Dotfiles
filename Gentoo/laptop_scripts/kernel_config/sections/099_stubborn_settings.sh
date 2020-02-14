#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Resetting some stubborn settings..."

# I'm not sure what is going on but some of the earlier settings aren't
# taking... This is setting them again to attempt to force them...
kernel_config --enable NFT_CT
kernel_config --enable NFT_COUNTER
