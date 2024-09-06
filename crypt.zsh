#!/usr/bin/env zsh

set -e -o verbose

ARCH_PART="$(
  lsblk -lno PATH,PARTTYPE,FSTYPE |
  grep -i '0FC63DAF-8483-4772-8E79-3D69D8477DE4' |
  grep 'crypto_LUKS' |
  cut -d' ' -f1
)"

# disk unlock via tpm 2.0
# enroll again after updating secure boot keys via secboot.zsh

if [[ $HOST =~ ^(player|worker)$ ]]; then
  if [[ ! $(sudo systemd-cryptenroll $ARCH_PART | grep tpm2) ]]; then
    sudo systemd-cryptenroll --tpm2-device=auto $ARCH_PART
  fi
fi

# dm-crypt recovery key

if [[ ! $(sudo systemd-cryptenroll $ARCH_PART | grep recovery) ]]; then
  sudo systemd-cryptenroll $ARCH_PART --recovery-key
fi

# luks header backup

FILE=/root/luks-header-backup.img

set +e
sudo rm $FILE
set -e

sudo cryptsetup luksHeaderBackup $ARCH_PART --header-backup-file $FILE

