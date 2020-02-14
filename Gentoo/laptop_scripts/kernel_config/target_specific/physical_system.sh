#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Running target specific kernel options: physical_system"

kernel_config --enable PROCESSOR_SELECT

kernel_config --enable ENERGY_MODEL
kernel_config --enable KSM
kernel_config --enable SFI
kernel_config --enable WQ_POWER_EFFICIENT_DEFAULT
kernel_config --enable X86_ACPI_CPUFREQ
kernel_config --enable X86_PCC_CPUFREQ

kernel_config --disable CPU_FREQ_DEFAULT_GOV_PERFORMANCE
kernel_config --enable CPU_FREQ_DEFAULT_GOV_SCHEDUTIL

kernel_config --disable CPU_FREQ_GOV_PERFORMANCE
kernel_config --enable CPU_FREQ_GOV_CONSERVATIVE

kernel_config --enable ACPI_AC
kernel_config --enable ACPI_APEI
kernel_config --enable ACPI_APEI_GHES
kernel_config --enable ACPI_APEI_MEMORY_FAILURE
kernel_config --enable ACPI_APEI_PCIEAER
kernel_config --enable ACPI_BATTERY
kernel_config --enable ACPI_BGRT
kernel_config --enable ACPI_EXTLOG
kernel_config --enable ACPI_FAN
kernel_config --enable ACPI_PCI_SLOT
kernel_config --enable ACPI_PROCESSOR_AGGREGATOR
kernel_config --enable DPTC_POWER
kernel_config --enable NUMA_BALANCING
kernel_config --enable PMIC_OPREGION
kernel_config --enable X86_CPU_RESCTRL

kernel_config --enable NETWORK_PHY_TIMESTAMPING

# Allow IPSec offloading
kernel_config --enable INET_ESP_OFFLOAD
kernel_config --enable INET6_ESP_OFFLOAD

kernel_config --enable VIRTUALIZATION
kernel_config --enable VHOST_NET
kernel_config --enable KVM

kernel_config --enable ETHERNET

# Allows more complicated SCSI commands
kernel_config --enable BLK_DEV_BSG

kernel_config --enable USB_GADGET
kernel_config --enable USB_MASS_STORAGE
kernel_config --enable USB_SERIAL
kernel_config --enable USB_SERIAL_GENERIC

# This needs additional testing and may cause boot hanging on systems that
# don't work with it. Otherwise it may allow passing the actual screen
# resolution set by the early boot to the kernel to give a better console
# experience.
kernel_config --enable FIRMWARE_EDID

# On systems that support ACPI 4.0 we should be able to read power details
kernel_config --enable SENSORS_ACPI_POWER

# Use the RTC to save and restore the current clock
kernel_config --enable RTC_HCTOSYS

# Enable access to physical sensors
kernel_config --enable I2C_CHARDEV
