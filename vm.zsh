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

#  echo "put windows and virtio-win iso from https://github.com/virtio-win/virtio-win-pkg-scripts in $dir"

# map \\10.0.2.4\qemu

# https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe

# sudo pacman -S virt-viewer
# disk

if [[ ! -f $dir/$disk ]]; then
  qemu-img create -f qcow2 $dir/$disk 128G > /dev/null
  echo 'use disk (viostor dir), vga and nic drivers from virtio-win and disable fast startup'
fi

# params

local opts='-name windows'

opts="$opts -enable-kvm"

opts="$opts -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,topoext"
opts="$opts -smp 4,sockets=1,cores=2,threads=2"

opts="$opts -m 8G"

opts="$opts -vga std"

opts="$opts -device ich9-intel-hda"
opts="$opts -device hda-output"

opts="$opts -nic user,model=virtio-net-pci,smb=$share"

opts="$opts -drive file=$dir/$disk,if=virtio,aio=native,cache.direct=on"
[[ -f $dir/$windows ]] && opts="$opts -drive file=$dir/$windows,media=cdrom"
[[ -f $dir/$virtio ]] && opts="$opts -drive file=$dir/$virtio,media=cdrom"


# todo: better opts

if [[ $1 = 'spice' ]]; then

  opts="$opts -spice port=5930,disable-ticketing=on"
  opts="$opts -display spice-app"
  opts="$opts -device virtio-serial-pci"

  # clipboard sharing
  opts="$opts -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0"
  opts="$opts -chardev spicevmc,id=spicechannel0,name=vdagent"

  # folder sharing
  opts="$opts -device virtserialport,chardev=spicechannel1,name=org.spice-space.webdav.0"
  opts="$opts -chardev spiceport,name=org.spice-space.webdav.0,id=spicechannel1"

fi

opts="$opts -boot menu=on"
opts="$opts -monitor stdio"

# run

setopt shwordsplit

qemu-system-x86_64 $opts

unsetopt shwordsplit

} $1

