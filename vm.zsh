#!/usr/bin/env zsh

set -e

# config

zparseopts clipboard=PARAMS folder=PARAMS

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

# options

OPTS+=('-name windows')

OPTS+=('-enable-kvm')

OPTS+=('-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,topoext')
OPTS+=('-smp 4,sockets=1,cores=2,threads=2')

OPTS+=('-m 8G')

OPTS+=('-vga std')
#OPTS+=('-vga qxl')
#OPTS+=('-vga none -device qxl-vga,vgamem_mb=32') # hi-res with spice but slow
#OPTS+=('-vga virtio')
#OPTS+=('-vga virtio -display gtk,gl=on')

#OPTS+=('-usbdevice tablet') # works with std; with qxl/virtio only with spice
#OPTS+=('-display default,show-cursor=on')

OPTS+=('-device ich9-intel-hda')
OPTS+=('-device hda-output')

OPTS+=("-nic user,model=virtio-net-pci,smb=$SHARE")

OPTS+=("-drive file=$DIR/$DISK,if=virtio,aio=native,cache.direct=on")
[[ -f $DIR/$WINDOWS ]] && OPTS+=("-drive file=$DIR/$WINDOWS,media=cdrom")
[[ -f $DIR/$VIRTIO ]] && OPTS+=("-drive file=$DIR/$VIRTIO,media=cdrom")

if (( $PARAMS[(I)-clipboard|-folder] )); then

  OPTS+=('-spice port=5930,disable-ticketing=on')
  OPTS+=('-display spice-app')
  OPTS+=('-device virtio-serial-pci')

  if (( $PARAMS[(Ie)-clipboard] )); then
    OPTS+=('-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0')
    OPTS+=('-chardev spicevmc,id=spicechannel0,name=vdagent')
  fi

  if (( $PARAMS[(Ie)-folder] )); then
    OPTS+=('-device virtserialport,chardev=spicechannel1,name=org.spice-space.webdav.0')
    OPTS+=('-chardev spiceport,name=org.spice-space.webdav.0,id=spicechannel1')
  fi

fi

OPTS+=('-boot menu=on')
OPTS+=('-monitor stdio')

# start

setopt shwordsplit

qemu-system-x86_64 $OPTS

unsetopt shwordsplit

