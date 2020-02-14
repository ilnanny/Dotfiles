#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

cat << 'EOF' > /mnt/gentoo/etc/portage/package.use/ssh
net-misc/openssh ldns
EOF

chroot /mnt/gentoo emerge net-misc/openssh

cat << 'EOF' > /mnt/gentoo/etc/ssh/ssh_config
# /etc/ssh/ssh_config

Port 22
Port 2200

CheckHostIP yes
HashKnownHosts yes
IdentitiesOnly yes

PreferredAuthentications publickey,keyboard-interactive,password

# For Kerberos
#PreferredAuthentications gssapi-keyex,gssapi-with-mic,publickey,keyboard-interactive

#GSSAPIAuthentication yes
#GSSAPIDelegateCredentials yes
#GSSAPITrustDns yes

#CanonicalizeHostname yes
#CanonicalDomains prd.aus.devtty.net devtty.org
#CanonicalizePermittedCNAMEs *.prd.aus.devtty.org:*.devtty.org

#Host *.devtty.org
#  VerifyHostKeyDNS yes
EOF

# For listing supported ciphers, key algos, kex algos and macs
# ssh -Q cipher
# ssh -Q kex
# ssh -Q mac

cat << 'EOF' > /mnt/gentoo/etc/ssh/sshd_config
# /etc/ssh/sshd_config

HostKeyAlgorithms ssh-ed25519,ecdsa-sha2-nistp521,ssh-rsa

Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
KexAlgorithms curve25519-sha256@libssh.org,curve25519-sha256,diffie-hellman-group-exchange-sha256
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-sha1-96-etm@openssh.com

ClientAliveInterval 10

SyslogFacility AUTHPRIV
UseDNS no
PrintMotd no

AllowTcpForwarding no
Banner /etc/issue.net
PermitRootLogin no
UsePAM yes

PasswordAuthentication no

AllowGroups sshers

# For Kerberos
#GSSAPIAuthentication yes
#KerberosAuthentication yes
EOF

# These next two take a hot minute...
ssh-keygen -G moduli-2048.candidates -b 2048
ssh-keygen -T moduli-2048 -f moduli-2048.candidates
cp moduli-2048 /mnt/gentoo/etc/ssh/moduli
chmod 0600 /mnt/gentoo/etc/ssh/moduli
rm moduli*

chroot /mnt/gentoo rc-update add sshd default
