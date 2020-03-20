#!/usr/bin/env zsh

set -e -o verbose

# temporary keys

PENDRIVE=$(lsblk -r -o NAME,LABEL | grep ARCH | sed -e 's/\s.*$//')
if [[ ! $PENDRIVE ]]; then exit 1; fi

if [[ $(sudo mount | grep "/dev/$PENDRIVE") ]]; then sudo umount /dev/$PENDRIVE; fi
sudo mount /dev/$PENDRIVE /mnt

unset $PENDRIVE

if [ ! -d ~/.ssh ]; then mkdir ~/.ssh; fi

cp /mnt/.bootstrap/keys/openssh/.ssh/config ~/.ssh
chmod 600 ~/.ssh/config

cp -r /mnt/.bootstrap/keys/openssh/.ssh/github.com ~/.ssh
chmod 600 ~/.ssh/github.com/*

sudo umount -R /mnt

# repos

if [ ! -d ~/code ]; then mkdir ~/code; fi

if [ -d ~/code/arch ]; then rm -rf ~/code/arch; fi
git clone git@github.com:GrzegorzKozub/arch.git ~/code/arch

if [ -d ~/code/dotfiles ]; then rm -rf ~/code/dotfiles; fi
git clone --recursive git@github.com:GrzegorzKozub/dotfiles.git ~/code/dotfiles

if [ -d ~/code/keys ]; then rm -rf ~/code/keys; fi
git clone git@github.com:GrzegorzKozub/keys.git ~/code/keys

if [ -d ~/code/mac ]; then rm -rf ~/code/mac; fi
git clone git@github.com:GrzegorzKozub/mac.git ~/code/mac

if [ -d ~/code/passwords ]; then rm -rf ~/code/passwords; fi
git clone git@github.com:GrzegorzKozub/passwords.git ~/code/passwords

if [ -d ~/code/themes ]; then rm -rf ~/code/themes; fi
git clone git@github.com:GrzegorzKozub/themes.git ~/code/themes

