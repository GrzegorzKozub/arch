#!/usr/bin/env zsh

set -e

# config

zparseopts clipboard=PARAMS folder=PARAMS

UEFI=0

MOUNT=/run/media/$USER/data
DIR=$MOUNT/vm
TPM=$DIR/tpm

DISK=windows.cow
WINDOWS=windows.iso
VARS=windows.fd
VIRTIO=virtio-win-0.1.217.iso

SHARE=$HOME/Downloads

# mount

[[ -d $MOUNT ]] || sudo mkdir -p $MOUNT
[[ $(mount | grep "vg1-data on $MOUNT") ]] || sudo mount /dev/mapper/vg1-data $MOUNT

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

if [[ $HOST = 'player' || $HOST = 'worker' ]]; then

  # 1920x1080
  # OPTS+=('-vga virtio -display sdl,gl=on')
  OPTS+=('-vga none -device qxl-vga,vgamem_mb=64,ram_size_mb=128,vram_size_mb=256,vram64_size_mb=256')

else

  # 1920x1080
  OPTS+=('-vga std')

fi

OPTS+=('-device ich9-intel-hda')
OPTS+=('-device hda-output')

OPTS+=("-nic user,model=virtio-net-pci,smb=$SHARE")

OPTS+=('-usbdevice tablet')

OPTS+=("-drive file=$DIR/$DISK,if=virtio,aio=native,cache.direct=on")
[[ -f $DIR/$WINDOWS ]] && OPTS+=("-drive file=$DIR/$WINDOWS,media=cdrom")
[[ -f $DIR/$VIRTIO ]] && OPTS+=("-drive file=$DIR/$VIRTIO,media=cdrom")

if [[ $UEFI = 1 ]]; then

  OPTS+=('-machine q35,smm=on')

  [[ -d $TPM ]] || mkdir $TPM

  swtpm socket \
    --tpm2 \
    --tpmstate dir=$TPM \
    --ctrl type=unixio,path=$TPM/socket \
    --daemon

  OPTS+=("-chardev socket,path=$TPM/socket,id=chardev0")
  OPTS+=('-tpmdev emulator,chardev=chardev0,id=tpmdev0')
  OPTS+=('-device tpm-tis,tpmdev=tpmdev0')

  [[ -f $DIR/$VARS ]] || cp /usr/share/edk2-ovmf/x64/OVMF_VARS.fd $DIR/$VARS

  OPTS+=('-drive if=pflash,format=raw,unit=0,file=/usr/share/edk2-ovmf/x64/OVMF_CODE.secboot.fd,readonly=on')
  OPTS+=("-drive if=pflash,format=raw,unit=1,file=$DIR/$VARS")

fi

if (( $PARAMS[(I)-clipboard|-folder] )); then

  OPTS+=('-spice port=5930,disable-ticketing=on')
  OPTS+=('-display spice-app')
  OPTS+=('-device virtio-serial-pci')

  if (( $PARAMS[(Ie)-clipboard] )); then
    OPTS+=('-chardev spicevmc,name=vdagent,id=chardev1')
    OPTS+=('-device virtserialport,name=com.redhat.spice.0,chardev=chardev1')
  fi

  if (( $PARAMS[(Ie)-folder] )); then
    OPTS+=('-chardev spiceport,name=org.spice-space.webdav.0,id=chardev2')
    OPTS+=('-device virtserialport,name=org.spice-space.webdav.0,chardev=chardev2')
  fi

fi

OPTS+=('-boot menu=on')
OPTS+=('-monitor stdio')

# start

setopt shwordsplit

qemu-system-x86_64 $OPTS

unsetopt shwordsplit

