#!/usr/bin/env bash

set -e

chk() {
  b2sum "$1" | awk '{print $1}'
}

[[ $1 == 'update' ]] && {

  DIR=/boot/EFI/limine
  [[ -d $DIR ]] || mkdir $DIR

  SOURCE=/usr/share/limine/BOOTX64.EFI
  TARGET=$DIR/liminex64.efi

  if [[ -f $TARGET && $(chk "$SOURCE") == $(chk "$TARGET") ]]; then
    exit
  fi

  cp /usr/share/limine/BOOTX64.EFI $TARGET
  sbctl sign --save $TARGET
}
