#!/usr/bin/env zsh

# vm

set -e

() {

# config

local mount=/run/media/$USER/backup
local dir=/run/media/$USER/backup/vm
local disk=windows.cow
local windows=windows.iso
local virtio=virtio-win-0.1.215.iso
local share=$HOME/Downloads

# mount

[[ -d $mount ]] || sudo mkdir -p $mount
[[ $(mount | grep "vg1-backup on $mount") ]] || sudo mount /dev/mapper/vg1-backup $mount

# dirs

[[ -d $dir ]] || (sudo mkdir $dir && sudo chown $USER $dir && sudo chgrp users $dir)

# dependencies

if [[ ! -f $dir/$windows || ! -f $dir/$virtio ]]; then
  echo "put windows and virtio-win iso from https://github.com/virtio-win/virtio-win-pkg-scripts in $dir"
  exit 1
fi

# disk

if [[ ! -f $dir/$disk ]]; then
  qemu-img create -f qcow2 $dir/$disk 128G > /dev/null
  echo 'use disk (viostor dir), vga and nic drivers from virtio-win and disable fast startup'
fi

# vm

# map \\10.0.2.4\qemu

# https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe

# sudo pacman -S virt-viewer

qemu-system-x86_64 \
  -name windows \
  -enable-kvm \
  -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,topoext \
  -smp 4,sockets=1,cores=2,threads=2 \
  -m 8G \
  -vga std \
  -device ich9-intel-hda \
  -device hda-output \
  -nic user,model=virtio-net-pci,smb=$share \
  -drive file=$dir/$disk,if=virtio,aio=native,cache.direct=on \
  -drive file=$dir/$windows,media=cdrom \
  -drive file=$dir/$virtio,media=cdrom \
-device virtio-serial-pci \
-spice port=5930,disable-ticketing=on \
-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
-chardev spicevmc,id=spicechannel0,name=vdagent \
-device virtserialport,chardev=spicechannel1,name=org.spice-space.webdav.0 \
-chardev spiceport,name=org.spice-space.webdav.0,id=spicechannel1
  -boot menu=on \
  -monitor stdio \
-display spice-app

}

