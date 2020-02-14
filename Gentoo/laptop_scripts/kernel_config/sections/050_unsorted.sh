#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Setting all the generally unsorted options"

# https://lwn.net/Articles/680989/
# https://lwn.net/Articles/681763/
kernel_config --enable BLK_WBT
kernel_config --enable BLK_WBT_MQ

# This is a huge boon to interactive and desktop workloads, not so much for
# servers with long running forking processes.
# https://www.phoronix.com/scan.php?page=article&item=linux_2637_video&num=1
#kernel_config --enable SCHED_AUTOGROUP

# TODO: These various lock detection mechanisms are likely good to enable but
# need more research
#kernel_config --enable SOFTLOCKUP_DETECTOR
#kernel_config --enable HARDLOCKUP_DETECTOR
#kernel_config --enable DETECT_HUNG_TASK
#kernel_config --enable WQ_WATCHDOG

# This seems super interesting but probably isn't generally necessary. The
# reboot to enable also kind of sucks. If I ever needed these kind of
# diagnostics I wouldn't want to effect the bad state by rebooting to try and
# get metrics. The reboot would destroy the state and we'd have to wait for the
# issue to re-occur.
#
# https://lwn.net/Articles/759781/
#kernel_config --enable PSI
#kernel_config --disable PSI_DEFAULT_DISABLED

# TODO: For UEFI any additional parameters we might want to pass to the kernel
# at boot need to be specified here:
#kernel_config --enable CMDLINE_BOOL
#kernel_config --set-str CMDLINE "console=tty0 console=ttyS0"
