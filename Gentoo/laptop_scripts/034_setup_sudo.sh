#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

chroot /mnt/gentoo emerge app-admin/sudo

cat << 'EOF' > /mnt/gentoo/etc/sudoers
# /etc/sudoers

Cmnd_Alias ALLOWED_EXEC = /bin/mount, /bin/passwd, /bin/umount, \
    /sbin/poweroff, /sbin/rc-service, /sbin/rc-status, /sbin/rc-update, \
    /sbin/reboot, /sbin/shutdown, /usr/bin/emerge, /usr/bin/equery, \
    /usr/bin/eselect, /usr/sbin/usermod

Cmnd_Alias BLACKLIST = /bin/su
Cmnd_Alias SHELLS = /bin/sh, /bin/bash
Cmnd_Alias USER_WRITEABLE = /home/*, /tmp/*, /var/tmp/*

Defaults env_reset, ignore_dot, mail_badpass, mail_no_perms, noexec
Defaults requiretty, use_pty
Defaults !path_info, !use_netgroups, !visiblepw

Defaults editor = /usr/bin/vim
Defaults env_keep += "TZ"
Defaults iolog_dir = /var/log/sudo-io/%{user}
Defaults passwd_timeout = 2
Defaults secure_path = /sbin:/bin:/usr/sbin:/usr/bin

Defaults mailfrom = root
Defaults mailsub = "Sudo Policy Violation on %H by %u"

Defaults!ALLOWED_EXEC,SHELLS !noexec
Defaults!SHELLS log_output

# Disable this once proper authentication has been setup:
Defaults !authenticate

root      ALL=(ALL)   ALL
#%sudoers  ALL=(ALL)   ALL,!BLACKLIST,!USER_WRITEABLE,!SHELLS
%sudoers  ALL=(ALL)   ALL,!BLACKLIST,!USER_WRITEABLE
EOF
