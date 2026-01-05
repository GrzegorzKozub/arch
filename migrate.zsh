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
sudo cp ~/code/walls/women.jpg /boot/EFI/limine/wall.jpg

[[ $HOST = 'drifter' ]] &&
  sudo sed -i 's/<font>/3x3/g' /boot/EFI/limine/limine.conf

[[ $HOST =~ ^(player|worker)$ ]] &&
  sudo sed -i 's/<font>/2x2/g' /boot/EFI/limine/limine.conf

[[ $HOST = 'drifter' ]] &&
  sudo sed -i 's/<ucode>/intel-ucode/g' /boot/EFI/limine/limine.conf

[[ $HOST =~ ^(player|worker)$ ]] &&
  sudo sed -i 's/<ucode>/amd-ucode/g' /boot/EFI/limine/limine.conf

[[ $HOST =~ ^(player|worker)$ ]] &&
  sudo sed -i 's/<params>/amd_pstate=active <params>/g' /boot/EFI/limine/limine.conf

[[ $HOST =~ ^(player|worker)$ ]] &&
  sudo sed -i 's/<params>/nvidia-drm.modeset=1 <params>/g' /boot/EFI/limine/limine.conf

[[ $HOST = 'drifter' ]] &&
  sudo sed -i 's/<params>/rcutree.enable_rcu_lazy=1 <params>/g' /boot/EFI/limine/limine.conf

sudo sed -i 's/<params>/quiet loglevel=3 rd.udev.log_level=3 <params>/g' /boot/EFI/limine/limine.conf
sudo sed -i 's/ <params>//g' /boot/EFI/limine/limine.conf

# efi boot menu

BOOTNUM=$(efibootmgr | grep 'Linux Boot Manager' | awk '{print $1}' | grep -o '[0-9]*' || true)
[[ $BOOTNUM ]] && sudo efibootmgr --delete-bootnum --bootnum "$BOOTNUM"

BOOTNUM=$(efibootmgr | grep 'limine' | awk '{print $1}' | grep -o '[0-9]*' || true)
[[ $BOOTNUM ]] && sudo efibootmgr --delete-bootnum --bootnum "$BOOTNUM"

. `dirname $0`/$HOST.zsh

[[ $(efibootmgr | grep 'systemd-boot') ]] || \
  sudo efibootmgr --create --label 'systemd-boot' \
    --disk $MY_DISK --part $MY_EFI_PART_NBR --loader /EFI/systemd/systemd-bootx64.efi

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

