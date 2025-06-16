#!/usr/bin/env zsh

# worker

export MY_DISK=/dev/nvme0n1

export MY_EFI_PART=/dev/nvme0n1p2
export MY_EFI_PART_NBR=${MY_EFI_PART: -1}
export MY_ARCH_PART=/dev/nvme0n1p5

export MY_HOSTNAME=worker

export MY_DESKTOP=GNOME

