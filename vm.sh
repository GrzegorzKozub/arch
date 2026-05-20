#!/usr/bin/env bash
set -eo pipefail -ux

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

[[ $(pacman -Qqs qemu-desktop) ]] || sudo pacman -S --noconfirm qemu-desktop
[[ $(pacman -Qqs samba) ]] || sudo pacman -S --noconfirm samba

# mount

[[ -d $MOUNT ]] || sudo mkdir -p "$MOUNT"
mount | grep -q "vg1-data on $MOUNT" || sudo mount /dev/mapper/vg1-data "$MOUNT"

# dirs

[[ -d $DIR ]] || (sudo mkdir "$DIR" && sudo chown "$USER" "$DIR" && sudo chgrp users "$DIR")

# image

[[ ! -f $DIR/$DISK ]] && qemu-img create -f qcow2 "$DIR/$DISK" 96G

# general

OPTS+=('-name' "$NAME")
OPTS+=('-boot' 'menu=on')
OPTS+=('-monitor' 'stdio')

# hardware virtualization via the kvm kernel module

OPTS+=('-enable-kvm')

# cpu

OPTS+=('-cpu' 'host,hv_frequencies,hv_ipi,hv_reenlightenment,hv_relaxed,hv_runtime,hv_spinlocks=0x1fff,hv_stimer,hv_stimer_direct,hv_synic,hv_time,hv_tlbflush,hv_tlbflush_ext,hv_vapic,hv_vpindex,hv_xmm_input,topoext')
OPTS+=('-smp' '4,sockets=1,cores=2,threads=2')

# gpu

if [[ $HOST =~ ^(player|worker)$ ]]; then

  # OPTS+=('-vga' 'virtio' '-display' 'sdl,gl=on')
  OPTS+=('-vga' 'none' '-device' 'qxl-vga,vgamem_mb=64,ram_size_mb=128,vram_size_mb=256,vram64_size_mb=256')

else

  OPTS+=('-vga' 'std')

fi

# memory

OPTS+=('-object' 'memory-backend-memfd,id=mem1,size=4G')
OPTS+=('-machine' 'q35,smm=on,memory-backend=mem1')

# audio

OPTS+=('-audiodev' 'pipewire,id=snd0')
OPTS+=('-device' 'ich9-intel-hda')
OPTS+=('-device' 'hda-duplex,audiodev=snd0')

# drives

OPTS+=('-object' 'iothread,id=io1')
OPTS+=('-drive' "file=$DIR/$DISK,if=none,id=drive0,aio=io_uring,cache.direct=on")
OPTS+=('-device' 'virtio-blk-pci,drive=drive0,iothread=io1')

[[ -f $DIR/$OS ]] && OPTS+=('-drive' "file=$DIR/$OS,media=cdrom")
[[ -f $DIR/$DRIVERS ]] && OPTS+=('-drive' "file=$DIR/$DRIVERS,media=cdrom")

# network

OPTS+=('-nic' "user,model=virtio-net-pci,smb=$SHARE")

# input

OPTS+=('-device' 'qemu-xhci')
OPTS+=('-device' 'usb-tablet')

# uefi

if [[ $UEFI == 1 ]]; then

  [[ $(pacman -Qqs swtpm) ]] || sudo pacman -S --noconfirm swtpm
  [[ $(pacman -Qqs edk2-ovmf) ]] || sudo pacman -S --noconfirm edk2-ovmf

  [[ -d $DIR/$TPM ]] || mkdir "$DIR/$TPM"

  swtpm socket \
    --tpm2 \
    --tpmstate "dir=$DIR/$TPM" \
    --ctrl "type=unixio,path=$DIR/$TPM/socket" \
    --daemon

  OPTS+=('-chardev' "socket,path=$DIR/$TPM/socket,id=chardev0")
  OPTS+=('-tpmdev' 'emulator,chardev=chardev0,id=tpmdev0')
  OPTS+=('-device' 'tpm-tis,tpmdev=tpmdev0')

  [[ -f $DIR/$VARS ]] || cp /usr/share/edk2/x64/OVMF_VARS.4m.fd "$DIR/$VARS"

  OPTS+=('-drive' 'if=pflash,format=raw,unit=0,file=/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd,readonly=on')
  OPTS+=('-drive' "if=pflash,format=raw,unit=1,file=$DIR/$VARS")

fi

# spice

if [[ $SPICE == 1 ]]; then

  [[ $(pacman -Qqs virt-viewer) ]] || {

    # packages

    sudo pacman -S --noconfirm virt-viewer

    # links

    cp /usr/share/applications/remote-viewer.desktop "$XDG_DATA_HOME/applications"
    sed -i '2iNoDisplay=true' "$XDG_DATA_HOME/applications/remote-viewer.desktop"

    xdg-mime default remote-viewer.desktop x-scheme-handler/spice+unix
  }

  OPTS+=('-spice' 'port=5930,disable-ticketing=on')
  OPTS+=('-display' 'spice-app')
  OPTS+=('-device' 'virtio-serial-pci')

  # clipboard sharing

  OPTS+=('-chardev' 'spicevmc,name=vdagent,id=chardev1')
  OPTS+=('-device' 'virtserialport,name=com.redhat.spice.0,chardev=chardev1')

  # folder sharing

  OPTS+=('-chardev' 'spiceport,name=org.spice-space.webdav.0,id=chardev2')
  OPTS+=('-device' 'virtserialport,name=org.spice-space.webdav.0,chardev=chardev2')

fi

# start

qemu-system-x86_64 "${OPTS[@]}"
