#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Enabling SELinux supporting settings"

# Enable security hooks for sockets
kernel_config --enable SECURITY_NETWORK_XFRM

# TODO: Once policies are tight, these settings should be revisited.
#kernel_config --disable SECURITY_SELINUX_BOOTPARAM
#kernel_config --disable SECURITY_SELINUX_DEVELOP
