#!/usr/bin/env zsh

set -o verbose

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# fetch

sudo pacman -S --noconfirm python-requests

# limine

[[ -d /etc/pacman.d/hooks ]] || sudo mkdir -p /etc/pacman.d/hooks
sudo cp $(dirname $0)/etc/pacman.d/hooks/90-limine-update.hook /etc/pacman.d/hooks/

sudo pacman -S --noconfirm limine

sudo cp $(dirname $0)/boot/EFI/limine/limine.conf /boot/EFI/limine/

# efi boot menu

BOOTNUM=$(efibootmgr | grep 'Linux Boot Manager' | awk '{print $1}' | grep -o '[0-9]*')
[[ $BOOTNUM ]] && sudo efibootmgr --delete-bootnum --bootnum "$BOOTNUM"

BOOTNUM=$(efibootmgr | grep 'limine' | awk '{print $1}' | grep -o '[0-9]*')
[[ $BOOTNUM ]] && sudo efibootmgr --delete-bootnum --bootnum "$BOOTNUM"

. `dirname $0`/$HOST.zsh

[[ $(efibootmgr | grep 'systemd-boot') ]] || \
  sudo efibootmgr --create --label 'systemd-boot' \
    --disk $MY_DISK --part $MY_EFI_PART_NBR --loader /EFI/systemd/PreLoader.efi

[[ $(efibootmgr | grep 'limine') ]] || \
  sudo efibootmgr --create --label 'limine' \
    --disk $MY_DISK --part $MY_EFI_PART_NBR --loader /EFI/limine/liminex64.efi \
    --unicode

# work

if [[ $HOST == 'worker' ]]; then

  rm -rf ~/.config/aws
  . ~/code/dot/aws.zsh

  systemctl --user disable iam.service
  rm -rf ~/.config/systemd/user/iam.service

  pushd ~/code/dot
  git update-index --no-assume-unchanged maven/maven/settings.xml
  popd

  sed -ie '/.*msteams.*/d' ~/.config/mimeapps.list

fi

# cleanup

`dirname $0`/packages.zsh
`dirname $0`/clean.zsh

