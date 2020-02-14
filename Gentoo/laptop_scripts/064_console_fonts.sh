#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

exit 0

# This is primarily for the GPD pocket which has a very high DPI screen and
# need the font bumped up to be usable. TODO: Increase font size in plymouth as
# well...
#
# TODO: Should probably just sed out the default for the preferred one to keep
# the remaining bits of the file intact...
cat << 'EOF' > /mnt/gentoo/etc/conf.d/consolefont
# /etc/conf.d/consolefont
consolefont="latarcyrheb-sun32"
EOF

chroot /mnt/gentoo rc-update add consolefont boot

# This is necessary to adjust the font earlier in the boot process but is only
# effective if dracut is being used to generate an initramfs...
cat << 'EOF' > /mnt/gentoo/etc/vconsole.conf
KEYMAP="us"
FONT="latarcyrheb-sun32"
EOF

# It seems like one the terminus console fonts may be better for the
# consolefont config but requires an additional (unknown named) package. It
# seems like it includes a 16x32 variant which is worth looking into.

# On a similar but different note there are larger fonts that can be compiled
# into the kernel under the "Library Routines" top level config. The 10x18,
# SUN8x16 and the SUN12x22 all seem promising for the GPD pocket...
#
# These can be selected by updating the grub command line to include
# 'fbcon:font:SUN8x16'
