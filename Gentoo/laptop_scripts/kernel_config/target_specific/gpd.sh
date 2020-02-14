#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

./target_specific/intel.sh

log "Running target specific kernel options: GPD Pocket"

# TODO: More drivers need to be enabled
kernel_config --enable BT
kernel_config --enable WIRELESS
kernel_config --enable CFG80211

kernel_config --enable ACPI_SBS
kernel_config --enable DPTF_POWER
kernel_config --enable FRAMEBUFFER_CONSOLE_ROTATION
kernel_config --enable USB_PRINTER

kernel_config --enable TYPEC
kernel_config --enable TYPEC_TCPM
kernel_config --enable TYPEC_TCPCI
kernel_config --enable TYPEC_UCSI
kernel_config --enable UCSI_ACPI
kernel_config --enable USB_ROLE_SWITCH
kernel_config --enable USB_ROLES_INTEL_XHCI

# Type C specific drivers may need to be enabled for this platform

kernel_config --enable USB_NET_DRIVERS
# TODO: More specific network drivers

kernel_config --enable GPD_POCKET_FAN

# Not sure if this will do anything for me but could be useful
#kernel_config --enable HID_BATTERY_STRENGTH
