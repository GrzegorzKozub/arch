#!/usr/bin/env zsh

set -e -o verbose

# temporary keys

PENDRIVE=$(lsblk -r -o PATH,LABEL | grep ARCHISO | sed -e 's/\s.*$//')
[[ $PENDRIVE ]] || exit 1

[[ $(mount | grep $PENDRIVE) ]] && sudo umount $PENDRIVE
sudo mount $PENDRIVE /mnt

[[ -d ~/.ssh || -n ~/.ssh ]] && rm -rf ~/.ssh
mkdir ~/.ssh

cp /mnt/.arch/keys/openssh/.ssh/config ~/.ssh
cp -r /mnt/.arch/keys/openssh/.ssh/github.com ~/.ssh
chmod 600 ~/.ssh/github*

sudo umount -R /mnt

# repos

[[ -d ~/code ]] || mkdir ~/code

[[ -d ~/code/arch ]] && rm -rf ~/code/arch
git clone git@github.com:GrzegorzKozub/arch.git ~/code/arch

[[ -d ~/code/walls ]] && rm -rf ~/code/walls
git clone git@github.com:GrzegorzKozub/walls.git ~/code/walls

[[ -d ~/code/dotfiles ]] && rm -rf ~/code/dotfiles
git clone --recursive git@github.com:GrzegorzKozub/dotfiles.git ~/code/dotfiles

[[ -d ~/code/history ]] && rm -rf ~/code/history
git clone git@github.com:GrzegorzKozub/history.git ~/code/history

[[ -d ~/code/keys ]] && rm -rf ~/code/keys
git clone git@github.com:GrzegorzKozub/keys.git ~/code/keys

[[ -d ~/code/passwords ]] && rm -rf ~/code/passwords
git clone git@github.com:GrzegorzKozub/passwords.git ~/code/passwords

[[ -d ~/code/notes ]] && rm -rf ~/code/notes
git clone git@github.com:GrzegorzKozub/notes.git ~/code/notes

