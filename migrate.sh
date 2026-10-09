#!/usr/bin/env bash
set -eo pipefail -ux

# prep

sudo pacman -Sy && pushd ~/code/dot && git pull && ./repos.sh && popd

# cleanup

[[ $HOST == 'worker' ]] && rm -rf "$XDG_CACHE_HOME"/fsh/

# crypttab.initramfs deprecation

# https://github.com/archlinux/mkinitcpio/blob/master/CHANGELOG
# https://wiki.archlinux.org/title/Dm-crypt/System_configuration

if [[ -f /etc/crypttab.initramfs ]]; then
  sed 's/$/,x-initrd.attach/' /etc/crypttab.initramfs |
    sudo tee -a /etc/crypttab > /dev/null
  sudo rm /etc/crypttab.initramfs
  sudo mkinitcpio -p linux
  sudo mkinitcpio -p linux-lts
  sudo mkinitcpio -p linux-cachyos
  sudo mkinitcpio -p linux-cachyos-lts
fi

# ghostty

sudo pacman -Rs --noconfirm ghostty || true
yay --aur --noconfirm --removemake --cleanmenu=false --answerdiff=None -S ghostty-nightly-bin

# gnome 51

sudo pacman -S --noconfirm gnome-extensions-app gst-plugin-pipewire power-profiles-daemon malcontent
gnome-extensions disable 'blur-my-shell@aunetx'

# vscode

rm -rf "$XDG_DATA_HOME"/applications/{code,code-url-handler}.desktop

# worktrunk

yay --aur --noconfirm --removemake --cleanmenu=false --answerdiff=None -S worktrunk-bin

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh
