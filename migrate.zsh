#!/usr/bin/env zsh

set -o verbose

# 7z

sudo pacman -Rs --noconfirm p7zip
paru -S --aur --noconfirm 7-zip-full

# fetch

cp `dirname $0`/home/$USER/.config/systemd/user/fetch.service $XDG_CONFIG_HOME/systemd/user
systemctl --user enable fetch.service

# splash

sudo pacman -S --noconfirm plymouth
paru -S --aur --noconfirm plymouth-theme-neat

sudo sed -Ei \
  's/^HOOKS=\(base systemd autodetect/HOOKS=\(base systemd plymouth autodetect/' \
  /etc/mkinitcpio.conf

sudo cp `dirname $0`/etc/plymouth/plymouthd.conf /etc/plymouth/plymouthd.conf

mkinitcpio -p linux
mkinitcpio -p linux-lts

# vscode

code --uninstall-extension asvetliakov.vscode-neovim

# yazi

for PLUGIN in \
  GrzegorzKozub/mdcat
do
  ya pack --add "$PLUGIN"
done

# remove luks header backup

sudo rm /root/luks-header-backup.img

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

