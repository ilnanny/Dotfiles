#!/bin/bash

echo 1 > /sys/module/snd_hda_intel/parameters/power_save
echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
echo auto > /sys/bus/i2c/devices/i2c-5/device/power/control
echo auto > /sys/bus/usb/devices/1-2/power/control
echo auto > /sys/bus/usb/devices/1-3/power/control
echo auto > /sys/bus/pci/devices/0000:00:00.0/power/control
echo auto > /sys/bus/pci/devices/0000:00:1a.0/power/control
echo auto > /sys/bus/pci/devices/0000:00:0b.0/power/control
echo auto > /sys/bus/pci/devices/0000:00:14.0/power/control
echo auto > /sys/bus/pci/devices/0000:00:1f.0/power/control
echo auto > /sys/bus/pci/devices/0000:01:00.0/power/control
