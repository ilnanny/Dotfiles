#!/bin/bash

CDLABEL="BOOTCD"
ISONAME="BOOTCD.ISO"

mkisofs -o "$ISONAME" -v -J -R -D -A "$CDLABEL" -V "$CDLABEL" \
-no-emul-boot -boot-info-table -boot-load-size 4 \
-b boot.img CD
