#!/usr/bin/env zsh

set -o verbose

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

# archiso

for FILE in \
  archiso/vmlinuz-linux \
  archiso/vmlinuz-linux-lts
do
  sudo test -f /boot/$FILE || continue
  sudo sbctl sign --save /boot/$FILE
done

# gnome terminal

sudo pacman -Rs gnome-terminal
dconf reset -f '/org/gnome/terminal/'
rm -f ~/.local/share/applications/org.gnome.Terminal.desktop

if [[ $HOST == 'worker' ]]; then

  # work

  rm -rf ~/.config/aws
  . ~/code/dot/aws.zsh

  systemctl --user disable iam.service
  rm -rf ~/.config/systemd/user/iam.service

  pushd ~/code/dot
  git update-index --no-assume-unchanged maven/maven/settings.xml
  popd

  sed -ie '/.*msteams.*/d' ~/.config/mimeapps.list

  # fetch

  sudo pacman -S --noconfirm python-requests

  # systemd-boot

  for FILE in \
    loader.efi \
    HashTool.efi \
    PreLoader.efi; do
      sudo sbctl remove-file /boot/EFI/systemd/$FILE
  done

  BOOTNUM=$(efibootmgr | grep 'Linux Boot Manager' | awk '{print $1}' | grep -o '[0-9]*' || true)
  [[ $BOOTNUM ]] && sudo efibootmgr --delete-bootnum --bootnum "$BOOTNUM"

  `dirname $0`/preloader.sh disable

  # limine

  [[ -d /etc/pacman.d/hooks ]] || sudo mkdir -p /etc/pacman.d/hooks
  sudo cp $(dirname $0)/etc/pacman.d/hooks/90-limine-update.hook /etc/pacman.d/hooks/

  sudo pacman -S --noconfirm limine

  sudo cp $(dirname $0)/boot/EFI/limine/limine.conf /boot/EFI/limine/
  sudo cp ~/code/walls/women.jpg /boot/EFI/limine/wall.jpg

  sudo sed -i "s/<host>/$HOST/g" /boot/EFI/limine/limine.conf

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

  BOOTNUM=$(efibootmgr | grep 'limine' | awk '{print $1}' | grep -o '[0-9]*' || true)
  [[ $BOOTNUM ]] && sudo efibootmgr --delete-bootnum --bootnum "$BOOTNUM"

  . `dirname $0`/$HOST.zsh

  sudo efibootmgr --create --label 'limine' \
    --disk $MY_DISK --part $MY_EFI_PART_NBR --loader /EFI/limine/liminex64.efi \
    --unicode

fi

# cleanup

`dirname $0`/packages.zsh
`dirname $0`/clean.zsh

