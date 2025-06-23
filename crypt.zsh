#!/usr/bin/env zsh

set -e -o verbose

ARCH_PART="$(
  lsblk -lno PATH,PARTTYPE,FSTYPE |
  grep -i '0fc63daf-8483-4772-8e79-3d69d8477de4' |
  grep 'crypto_LUKS' |
  cut -d' ' -f1
)"

# disk unlock via tpm 2.0
# enroll again after updating secure boot keys via secboot.zsh and after windows updates

if [[ $HOST =~ ^(player|sacrifice|worker)$ ]]; then

  SLOT=$(sudo systemd-cryptenroll $ARCH_PART | grep tpm2 | awk '{print $1}')

  if [[ ! $SLOT ]]; then
    sudo systemd-cryptenroll --tpm2-device=auto $ARCH_PART
  fi

  if [[ $SLOT && $1 == '--fix-tpm' ]]; then
    sudo systemd-cryptenroll $ARCH_PART --wipe-slot=$SLOT
    sudo systemd-cryptenroll --tpm2-device=auto $ARCH_PART
  fi

fi

# dm-crypt recovery key

if [[ ! $(sudo systemd-cryptenroll $ARCH_PART | grep recovery) ]]; then
  sudo systemd-cryptenroll $ARCH_PART --recovery-key
fi

