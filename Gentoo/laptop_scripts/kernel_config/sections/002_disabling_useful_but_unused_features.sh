#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

# To keep my kernel minimal I want to disable these things that I'm not
# actively using. They're interesting enough that they warrant additional
# research and when I get there I'll want to turn them on.

log "Disabling features that may be useful in the future but are generally unused"

# Process accounting seem particularly fascinating but may be covered by the
# auditing subsystem already. The tools would allow me to quickly view usage
# breakdown at the expense of disk space. Could also be used for tracking down
# how background processes spawn and the like. If I use this I'll likely want
# to enable the V3 file format as it allow tracking process hierarchy
# information.
#
# https://www.linuxjournal.com/article/6144
kernel_config --disable BSD_PROCESS_ACCT
#kernel_config --enable BSD_PROCESS_ACCT_V3

# This may be used by tools like top but I'm not sure. For now I'm going to
# disable it and see if any packages request it get re-enabled. If this is not
# what is used by those programs it may be worth looking into similar to
# process accounting.
kernel_config --disable TASKSTATS
kernel_config --disable TASK_DELAY_ACCT
kernel_config --disable TASK_IO_ACCOUNTING
kernel_config --disable TASK_XACCT

# The following may be needed by kexec but until then I don't need it
kernel_config --disable FIRMWARE_MEMMAP

kernel_config --disable KEXEC
