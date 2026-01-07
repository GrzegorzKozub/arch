#!/usr/bin/env bash

set -o verbose

# shutdown bug: https://bbs.archlinux.org/viewtopic.php?pid=2278862

if [[ $HOST == 'worker' ]]; then

  # archiso

  for FILE in \
    archiso/vmlinuz-linux \
    archiso/vmlinuz-linux-lts; do
    sudo test -f /boot/$FILE || continue
    sudo sbctl sign --save /boot/$FILE
  done

  # gnome terminal

  sudo pacman -Rs --noconfirm gnome-terminal
  dconf reset -f '/org/gnome/terminal/'
  rm -f ~/.local/share/applications/org.gnome.Terminal.desktop

  # env

  sudo cp "${BASH_SOURCE%/*}"/etc/zsh/zshenv /etc/zsh
  rm -f ~/.zprofile

  # work

  rm -rf ~/.config/aws
  pushd ~/code/dot
  . ~/code/dot/aws.zsh
  popd

  set +e
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

  # limine

  [[ -d /etc/pacman.d/hooks ]] || sudo mkdir -p /etc/pacman.d/hooks
  sudo cp "${BASH_SOURCE%/*}"/etc/pacman.d/hooks/90-limine-update.hook /etc/pacman.d/hooks/

  sudo pacman -S --noconfirm limine

fi

# cleanup

"${BASH_SOURCE%/*}"/packages.zsh
"${BASH_SOURCE%/*}"/clean.zsh
