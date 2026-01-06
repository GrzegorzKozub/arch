#!/usr/bin/env zsh

set -e -o verbose

# bitlocker must be temporarily disabled

[[ $(lsblk -o FSTYPE | grep BitLocker) ]] && exit 1

# secure boot must be disabled & in setup mode

STATUS=$(sudo sbctl status --json)
[[ $(echo $STATUS | jq .secure_boot) = 'true' ]] && exit 1
[[ $(echo $STATUS | jq .setup_mode) = 'false' ]] && exit 1

# create & enroll keys

sudo sbctl create-keys
sudo sbctl enroll-keys --firmware-builtin --microsoft

# checkpoint

[[ $(sudo sbctl status --json | jq .installed) == 'false' ]] && exit 1

# sign efi binaries

for FILE in \
  EFI/limine/liminex64.efi \
  \
  EFI/systemd/systemd-bootx64.efi \
  \
  EFI/Microsoft/Boot/bootmgfw.efi \
  EFI/Microsoft/Boot/bootmgr.efi \
  EFI/Microsoft/Boot/memtest.efi \
  EFI/Microsoft/Boot/SecureBootRecovery.efi \
  \
  EFI/Boot/bootx64.efi \
  \
  vmlinuz-linux \
  vmlinuz-linux-lts \
  \
  archiso/vmlinuz-linux \
  archiso/vmlinuz-linux-lts
do
  sudo test -f /boot/$FILE || continue
  sudo sbctl sign --save /boot/$FILE
done

# list enrolled efi binaries

sudo sbctl list-files

