#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

chroot /mnt/gentoo emerge app-editors/vim app-portage/gentoolkit \
  mail-client/mailx

#emerge sys-power/powertop

# DHCPCd should only be configuring my IP and routes
#sed '/option domain_name_servers, domain_name, domain_search, host_name/d' /mnt/gentoo/etc/dhcpcd.conf
#set '/option ntp_servers/d' /mnt/gentoo/etc/dhcpcd.conf

# GPD Pocket Notes: https://gpdpc.org/d/9-arch-linux-installation-instructions
