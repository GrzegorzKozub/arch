#!/usr/bin/env bash

set -e -o verbose

# systemd-boot secure boot support using preloader

EFI_PART=${MY_EFI_PART:-$(mount | grep '/boot' | awk '{print $1}')}
EFI_PART_NBR=${MY_EFI_PART_NBR:-${EFI_PART: -1}}
DISK=${MY_DISK:-${EFI_PART%%p[0-9]*}}

efi-boot-menu() {

  BOOTNUM=$(efibootmgr | grep 'systemd-boot' | awk '{print $1}' | grep -o '[0-9]*' || true)
  [[ $BOOTNUM ]] && sudo efibootmgr --delete-bootnum --bootnum "$BOOTNUM"

  sudo efibootmgr --create --label 'systemd-boot' \
    --disk "$DISK" --part "$EFI_PART_NBR" --loader /EFI/systemd/"$1".efi
}

[[ $1 == 'enable' ]] && {

  paru -S --aur --noconfirm \
    preloader-signed

  sudo cp /usr/share/preloader-signed/{HashTool,PreLoader}.efi /boot/EFI/systemd/
  sudo cp /boot/EFI/systemd/systemd-bootx64.efi /boot/EFI/systemd/loader.efi

  paru -Rs --aur --noconfirm \
    preloader-signed

  efi-boot-menu 'PreLoader'
}

[[ $1 == 'disable' ]] && {

  sudo rm -rf /boot/EFI/systemd/{loader,HashTool,PreLoader}.efi

  efi-boot-menu 'systemd-bootx64'

  for FILE in \
    loader.efi \
    HashTool.efi \
    PreLoader.efi; do
      sudo sbctl remove-file /boot/EFI/systemd/$FILE || true
  done
}
