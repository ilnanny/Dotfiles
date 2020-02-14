#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

lvscan > /dev/null
pvscan > /dev/null
vgscan > /dev/null

[ -b /dev/mapper/system-swap ] && lvremove --force system/swap > /dev/null
[ -b /dev/mapper/system-root ] && lvremove --force system/root > /dev/null

vgdisplay | grep -q system && vgremove --force system > /dev/null
