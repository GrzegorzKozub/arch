#!/usr/bin/env bash

set -e

# https://wiki.archlinux.org/title/Gaming#Tweaking_kernel_parameters_for_response_time_consistency

echo 5 | sudo tee /sys/kernel/mm/lru_gen/enabled # 7

echo madvise | sudo tee /sys/kernel/mm/transparent_hugepage/enabled      # always
echo advise | sudo tee /sys/kernel/mm/transparent_hugepage/shmem_enabled # never
# echo never | sudo tee /sys/kernel/mm/transparent_hugepage/defrag         # madvise

# https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/tmpfiles.d/thp.conf

echo defer+madvise | sudo tee /sys/kernel/mm/transparent_hugepage/defrag # madvise

# https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/tmpfiles.d/thp-shrinker.conf

echo 409 | sudo tee /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none # 511
