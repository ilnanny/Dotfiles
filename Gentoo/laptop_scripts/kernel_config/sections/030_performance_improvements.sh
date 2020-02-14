#!/bin/bash

. ./_error_handling.sh
. ./_config.sh
. ./_common_functions.sh

log "Adjusting some performance related settings"

# TODO: Look into Automatic process group scheduling as it applies to server
# loads. It's primarily designed for desktop loads but may provide some
# protection against resource stealing by aggressive processes.
#kernel_config --enable SCHED_AUTOGROUP

kernel_config --enable TRANSPARENT_HUGEPAGE

kernel_config --enable CLEANCACHE
kernel_config --enable FRONTSWAP
kernel_config --enable ZSWAP
kernel_config --enable ZBUD
kernel_config --enable Z3FOLD

kernel_config --enable CRYPTO_PCRYPT

# This is an interesting trade off. It defers initialization of some kernel
# structures into kernel threads allowing certain boot processes to happen
# earlier at the expense that some later processes may have a performance
# degradation until the kthreads have completed.
kernel_config --enable DEFERRED_STRUCT_PAGE_INIT

# This is still new and there are still bugs being found. It will speed up the
# boot process but at the expense of quality of the entropy pools. It seems
# stable enough for my purposes and my threat model doesn't include nation
# states.
kernel_config --enable RANDOM_TRUST_CPU

# These are available on both newer Intel and AMD processors. Some VMs do
# expose this as well. It won't be used when not available.
kernel_config --enable CRYPTO_CRCT10DIF_PCLMUL
kernel_config --enable CRYPTO_DES3_EDE_X86_64
kernel_config --enable CRYPTO_SHA1_SSSE3
kernel_config --enable CRYPTO_SHA512_SSSE3

# Speed up tcpdump usage
kernel_config --enable BPF_SYSCALL
kernel_config --enable BPF_JIT
