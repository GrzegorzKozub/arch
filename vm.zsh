#!/usr/bin/env zsh

set -e

# config

NAME=windows
UEFI=1
SPICE=1

MOUNT=/run/media/$USER/data
DIR=$MOUNT/vm
SHARE=$HOME/Downloads

DISK=$NAME.cow
VARS=$NAME.fd
TPM=$NAME-tpm

OS=$NAME.iso
DRIVERS=virtio-win-0.1.271.iso

# packages

[[ $(pacman -Qs qemu-desktop) ]] || sudo pacman -S --noconfirm qemu-desktop
[[ $(pacman -Qs samba) ]] || sudo pacman -S --noconfirm samba

# mount

[[ -d $MOUNT ]] || sudo mkdir -p $MOUNT
[[ $(mount | grep "vg1-data on $MOUNT") ]] || sudo mount /dev/mapper/vg1-data $MOUNT

# dirs

[[ -d $DIR ]] || (sudo mkdir $DIR && sudo chown $USER $DIR && sudo chgrp users $DIR)

# image

[[ ! -f $DIR/$DISK ]] && qemu-img create -f qcow2 $DIR/$DISK 96G

# options

OPTS+=("-name $NAME")

OPTS+=('-machine q35,smm=on')

OPTS+=('-enable-kvm')

OPTS+=('-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,topoext')
OPTS+=('-smp 4,sockets=1,cores=2,threads=2')

OPTS+=('-m 4G')

if [[ $HOST =~ ^(player|sacrifice|worker)$ ]]; then

  # OPTS+=('-vga virtio -display sdl,gl=on')
  OPTS+=('-vga none -device qxl-vga,vgamem_mb=64,ram_size_mb=128,vram_size_mb=256,vram64_size_mb=256')

else

  OPTS+=('-vga std')

fi

OPTS+=('-device ich9-intel-hda')
OPTS+=('-device hda-output')

OPTS+=("-nic user,model=virtio-net-pci,smb=$SHARE")

OPTS+=('-usbdevice tablet')

OPTS+=("-drive file=$DIR/$DISK,if=virtio,aio=native,cache.direct=on")
[[ -f $DIR/$OS ]] && OPTS+=("-drive file=$DIR/$OS,media=cdrom")
[[ -f $DIR/$DRIVERS ]] && OPTS+=("-drive file=$DIR/$DRIVERS,media=cdrom")

if [[ $UEFI = 1 ]]; then

  [[ $(pacman -Qs swtpm) ]] || sudo pacman -S --noconfirm swtpm
  [[ $(pacman -Qs edk2-ovmf) ]] || sudo pacman -S --noconfirm edk2-ovmf

  [[ -d $DIR/$TPM ]] || mkdir $DIR/$TPM

  swtpm socket \
    --tpm2 \
    --tpmstate dir=$DIR/$TPM \
    --ctrl type=unixio,path=$DIR/$TPM/socket \
    --daemon

  OPTS+=("-chardev socket,path=$DIR/$TPM/socket,id=chardev0")
  OPTS+=('-tpmdev emulator,chardev=chardev0,id=tpmdev0')
  OPTS+=('-device tpm-tis,tpmdev=tpmdev0')

  [[ -f $DIR/$VARS ]] || cp /usr/share/edk2/x64/OVMF_VARS.4m.fd $DIR/$VARS

  OPTS+=('-drive if=pflash,format=raw,unit=0,file=/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd,readonly=on')
  OPTS+=("-drive if=pflash,format=raw,unit=1,file=$DIR/$VARS")

fi

if [[ $SPICE = 1 ]]; then

  [[ $(pacman -Qs virt-viewer) ]] || {

    # packages

    sudo pacman -S --noconfirm virt-viewer

    # links

    cp /usr/share/applications/remote-viewer.desktop $XDG_DATA_HOME/applications
    sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/remote-viewer.desktop

    xdg-mime default remote-viewer.desktop x-scheme-handler/spice+unix
  }

  OPTS+=('-spice port=5930,disable-ticketing=on')
  OPTS+=('-display spice-app')
  OPTS+=('-device virtio-serial-pci')

  # clipboard sharing
  OPTS+=('-chardev spicevmc,name=vdagent,id=chardev1')
  OPTS+=('-device virtserialport,name=com.redhat.spice.0,chardev=chardev1')

  # folder sharing
  OPTS+=('-chardev spiceport,name=org.spice-space.webdav.0,id=chardev2')
  OPTS+=('-device virtserialport,name=org.spice-space.webdav.0,chardev=chardev2')

fi

OPTS+=('-boot menu=on')
OPTS+=('-monitor stdio')

# start

setopt shwordsplit

qemu-system-x86_64 $OPTS

unsetopt shwordsplit

