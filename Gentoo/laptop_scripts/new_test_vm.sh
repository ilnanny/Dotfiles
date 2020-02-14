#!/bin/bash

. ./_error_handling.sh

if [ "$(getenforce)" == "Enforcing" ]; then
  echo "Unable to run with SELinux in enforcing mode..."
  exit 1
fi

# NOTE: The current gentoo install CD needs to be downloaded and placed at
# /var/lib/libvirt/images/gentoo_minima_install_cd.iso

sudo virt-install --connect qemu:///system --name gentoo_test --ram 8192 \
  --arch x86_64 --vcpus 3 --security="type=dynamic" --hvm --virt-type=kvm \
  --cdrom /var/lib/libvirt/images/gentoo_minimal_install_cd.iso \
  --os-type=linux --os-variant=rhel7.5 --noautoconsole --graphics=spice \
  --video qxl --channel spicevmc --network="network=default" \
  --disk="pool=default,size=20,sparse=true,format=qcow2" \
  --console="pty,target_type=virtio" --memballoon=virtio --check-cpu
