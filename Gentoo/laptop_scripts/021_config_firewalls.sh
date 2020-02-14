#!/bin/bash

. ./_config.sh
. ./_error_handling.sh


echo 'WARNING: perl 5.26.2 is deprecated but still required for nftables!'
mkdir -p /mnt/gentoo/etc/portage/package.unmask
echo '=dev-lang/perl-5.26.2' > /mnt/gentoo/etc/portage/package.unmask/nftables

chroot /mnt/gentoo emerge net-firewall/nftables

cat << 'EOF' > /mnt/gentoo/etc/conf.d/nftables
# /etc/conf.d/nftables

NFTABLES_SAVE="/var/lib/nftables/rules-save"
SAVE_OPTIONS="-n"
SAVE_ON_STOP="no"
EOF

cat << 'EOF' > /mnt/gentoo/var/lib/nftables/rules-save
# /var/lib/nftables/rules-save

flush ruleset

# Supports using the following syntax:
#include "/var/lib/nftables/rules/additional-rules"

table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;

    # Drop invalid connections and packets
    ct state invalid counter drop

    # Allow established and related connections
    ct state established,related accept

    # Allow traffic crossing the loopback interface
    iif "lo" accept

    # ICMP diagnostic messages that related to errors will be covered by the
    # related connection tracking rule above.

    # Allow IPv4 pings
    ip version 4 ip protocol icmp icmp type echo-request accept

    # Allow IPv6 basic functionality and pings, IPv6 routers will also want: nd-router-solicit
    ip6 version 6 ip6 nexthdr icmpv6 icmpv6 type { echo-request, nd-neighbor-advert, nd-neighbor-solicit, nd-router-advert } accept

    # SSH (port 22 locally and my alt port everywhere)
    ip saddr 192.168.122.0/24 tcp dport 22 accept
    tcp dport 2200 accept

    # Probably don't want this on production systems but great for
    # diagnostics...
    #ct state new log level warn prefix "ingress attempt: "

    # Keep track of all the packets dropped by the default rule explicitly
    counter drop
  }

  chain forward {
    type filter hook forward priority 0; policy drop;
  }

  chain output {
    type filter hook output priority 0; policy drop;

    # Allow established and related connections
    ct state established,related accept

    # Allow traffic crossing the loopback interface
    oif "lo" accept

    ip version 4 ip protocol icmp icmp type echo-request accept

    # IPv6 routers will also want: nd-router-advert
    ip6 version 6 ip6 nexthdr icmpv6 icmpv6 type { echo-request, nd-neighbor-advert, nd-neighbor-solicit, nd-router-solicit } accept

    # Allow DHCP
    ip version 4 udp dport 67 udp sport 68 accept
    ip6 version 6 udp dport 547 udp sport 546 accept

    # Allow HTTP, HTTPS, and rsync protocols, for updating. Could be restricted
    # with a dedicated update server and/or web proxies.
    tcp dport { 80, 443, 873 } accept

    # Allow SSH'ing into other local boxes once you're on one, this is libvirt specific
    # TODO: This should be whatever local network the box is on
    ip daddr 192.168.122.0/24 tcp dport 22 accept

    # Allow connecting to the NFS portage share and package server, this is
    # libvirt specific
    #
    # TODO: This should be whatever the local build box share is
    ip daddr 192.168.122.1 tcp dport { 2049, 8200 } accept

    # Allow DNS, could be restricted with a local recursive resolver
    tcp dport 53 accept
    udp dport 53 accept

    # Allow NTP, probably not needed in KVM guests...
    udp dport 123 accept

    # Logging attempts to leave the host are either hostile, or a
    # misconfiguration of something. Either way they should be logged and
    # addressed.
    ct state new log level warn prefix "egress attempt: "

    counter reject with icmp type admin-prohibited
  }
}
EOF

chroot /mnt/gentoo rc-update add nftables default
