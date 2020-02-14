#!/bin/bash

. ./_config.sh
. ./_error_handling.sh

# I don't want this running automatically...
exit 0

#???CONFIG_VFIO_IOMMU_TYPE1=m

# The kernel config needs the following options enabled (I just compiled them
# into the kernel)
#CONFIG_IOMMU_SUPPORT=y
#CONFIG_AMD_IOMMU=n (if using AMD CPU)
#CONFIG_AMD_IOMMU_V2=n (if using AMD CPU)
#CONFIG_INTEL_IOMMU=y (if using Intel CPU)
#CONFIG_INTEL_IOMMU_SVM=y (if using Intel CPU)
#CONFIG_IRQ_REMAP=y
#CONFIG_VFIO=m
#CONFIG_VFIO_PCI=m
#CONFIG_VFIO_PCI_VGA=y

# After compiling the above into the kernel, updating my kernel and init
# settings, I rebooted into it.
#
# A few things in dmesg to verify things are working:
#
# The following command will allow you find how devices are broken down into
# their own IOMMU groups:
#
for iommu_group in $(find /sys/kernel/iommu_groups/ -maxdepth 1 -mindepth 1 -type d); do
  echo "IOMMU group $(basename "$iommu_group")"

  for device in $(ls -1 "$iommu_group"/devices/); do
    echo -n $'\t'
    lspci -nns "$device"
  done
done

# Importantly my NVidia card is in IOMMU group 1.
#IOMMU group 1
#        00:01.0 PCI bridge [0604]: Intel Corporation Skylake PCIe Controller (x16) [8086:1901] (rev 07)
#        00:01.1 PCI bridge [0604]: Intel Corporation Skylake PCIe Controller (x8) [8086:1905] (rev 07)
#        02:00.0 VGA compatible controller [0300]: NVIDIA Corporation GM204 [GeForce GTX 970] [10de:13c2] (rev a1)
#        02:00.1 Audio device [0403]: NVIDIA Corporation GM204 High Definition Audio Controller [10de:0fbb] (rev a1)

The first number for the targetted devices '02:00.0' and '02:00.1' are the
numbers we'll need to hold on to as well as the numbers almost at the end
within the brackets (more important).

Let's configure our VFIO module:

cat << 'EOF' > /etc/modprobe.d/vfio.conf
options vfio-pci ids=10de:13c2,10de:0fbb
EOF










# I found this little script

```
#!/bin/bash

for dev in "$@"; do
  vendor=$(cat /sys/bus/pci/devices/$dev/vendor)
  device=$(cat /sys/bus/pci/devices/$dev/device)

  if [ -e /sys/bus/pci/devices/$dev/driver ]; then
    echo $dev > /sys/bus/pci/devices/$dev/driver/unbind
  fi

  echo $vendor $device > /sys/bus/pci/drivers/vfio-pci/new_id
done
```

After saving it as vfio-bind and marking it executable I used it to unbind the
Nvidia card by executing it like so:

```
./vfio-bind 0000:02:00.0 0000:02:00.1
```

And of course my kernel panics and rebooted...

# When I get to it there are tuning notes at the bottom of:
# https://wiki.installgentoo.com/index.php/PCI_passthrough
