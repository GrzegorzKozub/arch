set -e -o verbose

# openssh

sudo pacman -S --noconfirm openssh

if [ ! -d ~/.ssh ]; then mkdir ~/.ssh; fi

cp /mnt/.arch/keys/ssh/config ~/.ssh
chmod 600 ~/.ssh/config

cp -r /mnt/.arch/keys/ssh/github.com ~/.ssh
chmod 600 ~/.ssh/github.com/*

cp -r /mnt/.arch/keys/ssh/amazonaws.com ~/.ssh
chmod 600 ~/.ssh/amazonaws.com/*

