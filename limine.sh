#!/usr/bin/env bash

set -e

[[ $1 == 'update' ]] && {

  # update limine on esp

  DIR=/boot/EFI/limine
  [[ -d $DIR ]] || mkdir $DIR

  cp /usr/share/limine/BOOTX64.EFI $DIR/liminex64.efi
  [[ $(sbctl status --json | jq .installed) == 'true' ]] && sbctl sign --save $DIR/liminex64.efi

} || true
