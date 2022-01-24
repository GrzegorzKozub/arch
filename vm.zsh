#!/usr/bin/env zsh

# vm

set -e

() {

local dir=/run/media/greg/backup/vm
local disk=win.cow
local win=win.iso
local virtio=virtio-win-0.1.215.iso

[[ -d $dir ]] || (sudo mkdir $dir && sudo chown greg $dir && sudo chgrp users $dir)

if [[ ! -f $dir/$win || ! -f $dir/$virtio ]]; then
  echo "put windows and virtio-win iso from https://github.com/virtio-win/virtio-win-pkg-scripts in $dir"
  exit 1
fi

if [[ ! -f $dir/$disk ]]; then
  qemu-img create -f qcow2 $dir/$disk 128G > /dev/null
  echo 'use disk (viostor dir), vga and nic drivers from virtio-win and disable fast startup'
fi

qemu-system-x86_64 \
  -name win \
  -enable-kvm \
  -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,topoext \
  -smp 4,sockets=1,cores=2,threads=2 \
  -m 8G \
  -vga std \
  -nic user,model=virtio-net-pci \
  -drive file=$dir/$disk,if=virtio,aio=native,cache.direct=on \
  -drive file=$dir/$win,media=cdrom \
  -drive file=$dir/$virtio,media=cdrom \
  -boot menu=on \
  -monitor stdio

}

