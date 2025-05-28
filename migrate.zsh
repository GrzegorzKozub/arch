#!/usr/bin/env zsh

set -o verbose

# aws-cli-v2

sudo sed -i -e 's/^IgnorePkg.*$/#IgnorePkg   =/' /etc/pacman.conf # aws-cli-v2 python-prompt_toolkit

# nvim

rm -rf $XDG_CACHE_HOME/nvim
rm -rf $XDG_DATA_HOME/nvim
rm -rf ~/.local/state/nvim

nvim \
  -c 'autocmd User MasonToolsUpdateCompleted quitall' \
  -c 'autocmd User VeryLazy MasonToolsUpdate'

# splash

for FILE in 01-arch 02-arch-lts; do
  sudo sed -i 's/ splash//' /boot/loader/entries/$FILE.conf
done

sudo sed -i 's/ plymouth//' /etc/mkinitcpio.conf
sudo rm -rf /etc/plymouth

paru -Rs --noconfirm plymouth-theme-neat
sudo pacman -Rs --noconfirm plymouth

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

