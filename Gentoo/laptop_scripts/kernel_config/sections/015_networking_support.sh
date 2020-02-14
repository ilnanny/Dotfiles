#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Enabling various networking components and options"

# I believe these are needed for 'ss' and 'iproute2' to function correctly but
# I want to test that assumption.
#kernel_config --enable INET_DIAG
#kernel_config --enable PACKET_DIAG
#kernel_config --enable UNIX_DIAG

# My servers don't need Ham radio options
kernel_config --disable HAMRADIO

# This may get re-enabled on a system specific basis later on, but generally
# for what I build kernels for I don't need wireless support.
kernel_config --disable RFKILL
kernel_config --disable WLAN
kernel_config --disable WIRELESS

# Core IPSec support
kernel_config --enable INET_AH
kernel_config --enable INET_ESP
kernel_config --enable INET_XFRM_MODE_TRANSPORT
kernel_config --enable INET_XFRM_MODE_TUNNEL
kernel_config --enable NET_KEY

# May also need IPSec compression but that seems like a bad idea
#kernel_config --enable INET_IPCOMP
#kernel_config --enable INET6_IPCOMP

# Default TCP congestion control. I chose this in the past over others but I
# didn't have a place to document why. For now I'm going to leave it at this
# until I can revisit my research on which one generally works best for my
# uses.
kernel_config --enable TCP_CONG_BBR
kernel_config --disable TCP_CONG_CUBIC
kernel_config --enable DEFAULT_BBR
kernel_config --disable DEFAULT_CUBIC

# I need to figure out if it's better in general to support this router
# preference setting. It might help protect against some weak forms of
# malicious router advertisements, or could exascerbate the issue.
#kernel_config --enable IPV6_ROUTER_PREF

# Allow autoconfigured IPv6 addresses to be used quickly by detecting duplicate
# addresses faster.
kernel_config --enable IPV6_OPTIMISTIC_DAD

# This is a garbage IPSec mode I have no interest in using
kernel_config --disable INET6_XFRM_MODE_BEET

# Don't enable the IPv6-in-IPv4 tunnels
kernel_config --disable IPV6_SIT

# Disable QoS support, might re-enable this in the future
kernel_config --disable NET_SCHED
