#!/usr/bin/env zsh

set -e

# config

zparseopts clipboard=OPTS folder=OPTS

MOUNT=/run/media/$USER/backup
DIR=/run/media/$USER/backup/vm
DISK=windows.cow
WINDOWS=windows.iso
VIRTIO=virtio-win-0.1.215.iso
SHARE=$HOME/Downloads

# mount

[[ -d $MOUNT ]] || sudo mkdir -p $MOUNT
[[ $(mount | grep "vg1-backup on $MOUNT") ]] || sudo mount /dev/mapper/vg1-backup $MOUNT

# dirs

[[ -d $DIR ]] || (sudo mkdir $DIR && sudo chown $USER $DIR && sudo chgrp users $DIR)

# image

[[ ! -f $DIR/$DISK ]] && qemu-img create -f qcow2 $DIR/$DISK 128G

# params

opts='-name windows'

opts="$opts -enable-kvm"

opts="$opts -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,topoext"
opts="$opts -smp 4,sockets=1,cores=2,threads=2"

opts="$opts -m 8G"

opts="$opts -vga std"

opts="$opts -device ich9-intel-hda"
opts="$opts -device hda-output"

opts="$opts -nic user,model=virtio-net-pci,smb=$SHARE"

opts="$opts -drive file=$DIR/$DISK,if=virtio,aio=native,cache.direct=on"
[[ -f $DIR/$WINDOWS ]] && opts="$opts -drive file=$DIR/$WINDOWS,media=cdrom"
[[ -f $DIR/$VIRTIO ]] && opts="$opts -drive file=$DIR/$VIRTIO,media=cdrom"

if (( $OPTS[(I)-clipboard|-folder] )); then

  opts="$opts -spice port=5930,disable-ticketing=on"
  opts="$opts -display spice-app"
  opts="$opts -device virtio-serial-pci"

  if (( $OPTS[(Ie)-clipboard] )); then
    opts="$opts -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0"
    opts="$opts -chardev spicevmc,id=spicechannel0,name=vdagent"
  fi

  if (( $OPTS[(Ie)-folder] )); then
    opts="$opts -device virtserialport,chardev=spicechannel1,name=org.spice-space.webdav.0"
    opts="$opts -chardev spiceport,name=org.spice-space.webdav.0,id=spicechannel1"
  fi

fi

opts="$opts -boot menu=on"
opts="$opts -monitor stdio"

# run

setopt shwordsplit

qemu-system-x86_64 $opts

unsetopt shwordsplit

# better name for $opts
  #echo 'use disk (viostor dir), vga and nic drivers from virtio-win and disable fast startup'
#  echo "put windows and virtio-win iso from https://github.com/virtio-win/virtio-win-pkg-scripts in $DIR"
# map \\10.0.2.4\qemu
# https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe
# sudo pacman -S virt-viewer
