#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Enabling various options for k3s"

kernel_config --enable BRIDGE
kernel_config --enable CGROUP_NET_CLASSID
kernel_config --enable CGROUP_NET_PRIO
kernel_config --enable CGROUP_PERF
kernel_config --enable IP_VS
kernel_config --enable IP_VS_IPV6
kernel_config --enable VETH
kernel_config --enable VLAN_8021Q
kernel_config --enable VXLAN

kernel_config --enable CFS_BANDWIDTH
kernel_config --enable RT_GROUP_SCHED

kernel_config --enable IP_VS_NFCT
kernel_config --enable IP_VS_PROTO_TCP
kernel_config --enable IP_VS_PROTO_UDP
kernel_config --enable IP_VS_RR

kernel_config --enable BRIDGE_VLAN_FILTERING
kernel_config --enable IP_NF_TARGET_REDIRECT
#kernel_config --enable NFT_NAT
#kernel_config --enable NFT_REDIR
kernel_config --enable NETFILTER_XT_MATCH_ADDRTYPE
kernel_config --enable NETFILTER_XT_MATCH_IPVS
kernel_config --enable NETFILTER_XT_TARGET_REDIRECT
# This was the dick bag that was breaking proxier.go...
kernel_config --enable NETFILTER_XT_MATCH_COMMENT
# This was breaking coreDNS
kernel_config --enable NETFILTER_XT_MATCH_MULTIPORT

kernel_config --enable DM_THIN_PROVISIONING
kernel_config --enable BFQ_GROUP_IOSCHED
kernel_config --enable BLK_DEV_THROTTLING

kernel_config --enable OVERLAY_FS
kernel_config --enable OVERLAY_FS_INDEX
kernel_config --enable OVERLAY_FS_METACOPY
kernel_config --enable OVERLAY_FS_REDIRECT_DIR

# Undocumented but I bet this is the issue:
kernel_config --enable NF_CONNTRACK_BRIDGE
