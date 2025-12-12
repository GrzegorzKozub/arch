#!/usr/bin/env bash

set -e

# https://wiki.archlinux.org/title/Gaming#Tweaking_kernel_parameters_for_response_time_consistency

echo 5 | sudo tee /sys/kernel/mm/lru_gen/enabled # 7

echo madvise | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
echo advise | sudo tee /sys/kernel/mm/transparent_hugepage/shmem_enabled
# echo never | sudo tee /sys/kernel/mm/transparent_hugepage/defrag

# https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/tmpfiles.d/thp.conf

echo defer+madvise | sudo tee /sys/kernel/mm/transparent_hugepage/defrag

# https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/tmpfiles.d/thp-shrinker.conf

echo 409 | sudo tee /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none

# https://wiki.archlinux.org/title/Gaming#Improve_PCI_Express_Latencies

sudo setpci -v -s '*:*' latency_timer=20
sudo setpci -v -s '0:0' latency_timer=0

sudo setpci -v -d "*:*:04xx" latency_timer=80
