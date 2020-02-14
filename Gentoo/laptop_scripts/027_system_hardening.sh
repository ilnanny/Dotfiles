#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

cat << EOF >> /mnt/gentoo/etc/security/limits.conf
# /etc/security/limits.conf

@adm    soft    nproc   100
@users  soft    nproc   50

@adm    hard    nproc   200
@users  hard    nproc   200

*       soft    core    0
*       hard    core    0
EOF

cat << EOF > /mnt/gentoo/etc/sysctl.d/fs_hardening.conf
# Prevent SUID executables from creating core dumps, should be set to '2' if an
# administrator needs a dump from one of these executables
fs.suid_dumpable = 0

# Provide protection against ToCToU races
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
EOF

cat << EOF > /mnt/gentoo/etc/sysctl.d/kernel_hardening.conf
# Make locating kernel addresses more difficult
kernel.kptr_restrict = 1

# Retrict perf calls to only be done by root
kernel.perf_event_paranoid = 2

# Disable the magic sysrq key
kernel.sysrq = 0

# Set ptrace protections (can't be 3 as gentoo build sandbox uses ptracing)
kernel.yama.ptrace_scope = 2
EOF

cat << EOF > /mnt/gentoo/etc/sysctl.d/net_hardening.conf
# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0

# Ignore source-routed packets
net.ipv4.conf.all.accept_source_route=0
net.ipv6.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Log spoofed, source-routed, and redirect packets
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# Reverse path filtering to help protect against IP spoofing
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Don't allow traffic between networks or act as a router
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Ignore ICMP redirects from non-GW hosts
net.ipv4.conf.all.secure_redirects = 1
net.ipv4.conf.default.secure_redirects = 1

# Don't allow traffic to traverse the system interfaces (will need to change
# for systems that actually route traffic)
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0
net.ipv6.conf.all.mc_forwarding = 0
net.ipv6.conf.default.forwarding = 0
net.ipv6.conf.default.mc_forwarding = 0

# Don't respond to garbage ICMP errors or broadcast pings
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Enable SYN flood protection
net.ipv4.tcp_syncookies = 1

# Implement informational RFC1337, this helps prevent against TIME_WAIT
# assasination and corruption of connections.
net.ipv4.tcp_rfc1337 = 1

# TODO: Additional options found in a hardening guide that had no explanations
# but should probably look into.
#net.ipv4.tcp_max_syn_backlog = 1024
#net.ipv4.tcp_max_tw_buckets = 1440000
#net.ipv4.tcp_fin_timeout = 15
#net.ipv4.tcp_keepalive_time = 1800
#net.ipv4.tcp_window_scaling = 0
#net.ipv4.tcp_sack = 0
#net.ipv4.ip_local_port_range = 16384 65536

## BEGIN QUESTIONABLE IPV6 SETTINGS

# These settings are mostly useful for statically configured IPv6

# In static environments we don't need to accept router advertisements
#net.ipv6.conf.default.accept_ra = 0

# When we're statically configured, we shouldn't send any router solicitations
#  as the information isn't useful to us.
#net.ipv6.conf.default.router_solicitations = 0

# When statically configured don't attempt any kind of auto configuration
#net.ipv6.conf.default.autoconf = 0

# We shouldn't need to check if our address is available on statically
# configured interfaces. If something else is using it must've been dynamic and
# will have to get off our address.
#net.ipv6.conf.default.dad_transmits = 0

# Don't accept the router preference field
#net.ipv6.conf.default.accept_ra_rtr_pref = 0

# Don't accept hop limit settings from router advertisements
#net.ipv6.conf.default.accept_ra_defrtr = 0

# Limit the maximum global addresses on individual interfaces, the only edge
# case this shouldn't be enabled is when privacy addresses with expiration is
# on. Link local addresses do not count toward this.
net.ipv6.conf.default.max_addresses = 1

# Privacy address settings (optional) can prefer outbound connections to use
# changing 'privacy' addresses. A static address can still be set on the
# interface for normal inbound operations. Unless the firewall is configured to
# prevent it services will also be available on the additional privacy
# addresses.
#
# These should only be enabled on servers when a static address is set.
# Otherwise the server will close connections once temp_valid_lft, and move to
# an unpredictable address.
#
# Note: When adjusting these values there are a couple things to consider:
#         * temp_valid_lft should be > than temp_prefered_lft
#         * max_desync_factor should be < (0.5 * temp_prefered_lft)
#         * max_addresses should be a minimum of:
#             2 + roundup(temp_valid_ft / temp_preferred_lft)
#           This accounts for the static address (1), the potential delay of
#           the lifetime by the desync factor (1), and the maximum temporary
#           active addresses the machine can have at once.
#net.ipv6.conf.all.addr_gen_mode = 3
#net.ipv6.conf.all.max_addresses = 5
#net.ipv6.conf.all.max_desync_factor = 600
#net.ipv6.conf.all.temp_prefered_lft = 7200
#net.ipv6.conf.all.temp_valid_lft = 14400
#net.ipv6.conf.all.use_tempaddr = 2
#net.ipv6.conf.default.addr_gen_mode = 3
#net.ipv6.conf.default.max_addresses = 5
#net.ipv6.conf.default.max_desync_factor = 600
#net.ipv6.conf.default.temp_prefered_lft = 7200
#net.ipv6.conf.default.temp_valid_lft = 14400
#net.ipv6.conf.default.use_tempaddr = 2

## END QUESTIONABLE IPV6 SETTINGS
EOF

cat << EOF > /mnt/gentoo/etc/sysctl.d/swap_tuning.conf
# Reduce default swappiness, this is a much better default for servers,
# especially databases. A value of 0 is never recommended.
vm.swappiness = 10

# Define at what percentage of total memory is dirty do we begin writing it
# out. These values are tuned for more database oriented workloads, but should
# be generally good on servers in general.
vm.dirty_ratio = 15
vm.dirty_background_ratio = 3

vm.overcommit_memory = 0
vm.overcommit_ratio = 50
EOF
