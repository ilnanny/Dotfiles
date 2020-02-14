#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Enabling generic hardening options"

# If the kernel panics for any reason, oops out and automatically reboot
kernel_config --enable PANIC_ON_OOPS
kernel_config --set-val PANIC_ON_OOPS_VALUE 1
kernel_config --set-val PANIC_TIMEOUT 30

# Harden the memory allocator to make it less predictable
kernel_config --enable SLAB_FREELIST_RANDOM
kernel_config --enable SLAB_FREELIST_HARDENED

# Un-seeded randomness could be particularly dangerous depending on how it's
# used. Warning on this and getting into logs is important.
kernel_config --enable WARN_ALL_UNSEEDED_RANDOM

# This option would add a performance penalty but ensures that freed memory
# doesn't have any sensitive data in it. Ideally we'd also disable the
# PAGE_POISONING_NO_SANITY option but that additional requirements that need to
# be addressed.
#kernel_config --enable PAGE_POISONING
#kernel_config --enable PAGE_POISONING_ZERO # See also: GFP_ZERO

# This may cause issues with X display server, the documentation indicates
# "legacy X" so it may not apply. In turn it provides greater memory
# protections from userspace applications.
kernel_config --enable IO_STRICT_DEVMEM

# Warn when kernel memory includes writable executable pages
kernel_config --enable DEBUG_WX
kernel_config --enable X86_PTDUMP_CORE

# Only root should be able to access dmesg
kernel_config --enable SECURITY_DMESG_RESTRICT

# For TPM and IMA support the securityfs filesystem needs to be enabled
kernel_config --enable SECURITYFS

# Perform additional checks when copying memory between the userspace and the
# kernel. This protects against large classes of heap overflow exploits and
# memory exposures. TODO: Disabling the fallback may have negative consequences
kernel_config --enable HARDENED_USERCOPY
kernel_config --disable HARDENED_USERCOPY_FALLBACK

# Provide additional protection on string and memory functions when the
# compiler is aware of buffer sizes.
kernel_config --enable FORTIFY_SOURCE

# Provide some hardening around ptrace'ing processes.
kernel_config --enable SECURITY_YAMA

# For the various integrity subsystems, support signing the data with
# asymmetric keys to prevent tampering of the data.
kernel_config --enable SIGNATURE
kernel_config --enable INTEGRITY_SIGNATURE
kernel_config --enable INTEGRITY_ASYMMETRIC_KEYS
kernel_config --enable INTEGRITY_TRUSTED_KEYRING

# Enable system integrity measurements
kernel_config --enable IMA

# Selected automatically:
kernel_config --enable IMA_LSM_RULES
kernel_config --set-val IMA_MEASURE_PCR_IDX 10

# Deprecated
kernel_config --disable IMA_TRUSTED_KEYRING

# Use SHA1 it should be collision resistent enough for this task
kernel_config --set-val IMA_DEFAULT_HASH \"sha1\"
kernel_config --enable IMA_DEFAULT_HASH_SHA1

# For the integrity measurements have them include a signature
kernel_config --enable IMA_SIG_TEMPLATE
kernel_config --disable IMA_NG_TEMPLATE
kernel_config --set-val IMA_DEFAULT_TEMPLATE "ima-sig"

# When there is an integrity measurement on a file, we do want to actually
# perform the validation against it.
kernel_config --enable IMA_APPRAISE

# TODO: These two would be useful once I get the all in one EFI system in place
# to enforce the system security and preload a readonly integrity policy:
#kernel_config --enable IMA_ARCH_POLICY
#kernel_config --enable IMA_APPRAISE_BUILD_POLICY

# TODO: This seems like it should be temporary but I need it until I'm sure I
# have all the kinks worked out.
kernel_config --enable IMA_APPRAISE_BOOTPARAM

# Protect files extended attributes as well
kernel_config --enable EVM
kernel_config --enable EVM_ATTR_FSUUID

# Selected by EVM & INTEGRITY, protect the keys used for integrity checking
kernel_config --enable ENCRYPTED_KEYS
kernel_config --enable TRUSTED_KEYS

# Allow a present TPM device to provide additional entropy to our random pools
kernel_config --enable HW_RANDOM_TPM

# Enabled by the appraisal specifications
kernel_config --enable TCG_TPM
kernel_config --enable TCG_CRB
kernel_config --enable TCG_TIS_CORE
kernel_config --enable TCG_TIS
kernel_config --enable TPM_KEY_PARSER
kernel_config --enable ASYMMETRIC_TPM_KEY_SUBTYPE

# Validate the stack when things are scheduled
kernel_config --enable SCHED_STACK_END_CHECK

# TODO: I really want to test this to see if I can restrict all the contents to
# a signed on boot initramfs. This would prevent loading modules post-boot, but
# I vastly prefer static kernel anyways.
#kernel_config --enable SECURITY_LOADPIN

# This is a performance trade of but provides more aggressive protections
# against use-after-free conditions.
kernel_config --enable REFCOUNT_FULL

# Some additional GCC plugins can be used to harden the systems, some of these
# decrease the performance a bit. The latent entropy slows the boot a bit but
# can help ensure entropy is available earlier.
kernel_config --enable GCC_PLUGINS
kernel_config --enable GCC_PLUGIN_LATENT_ENTROPY
kernel_config --enable GCC_PLUGIN_RANDSTRUCT
kernel_config --enable GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
kernel_config --enable GCC_PLUGIN_STACKLEAK
kernel_config --enable GCC_PLUGIN_STRUCTLEAK
kernel_config --enable GCC_PLUGIN_STRUCTLEAK_BYREF_ALL

# TODO: Enable required crypto for hard drive encryption?
