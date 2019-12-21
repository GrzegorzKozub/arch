set -e -o verbose

# openssh

sudo pacman -S --noconfirm openssh

if [ ! -d ~/.ssh ]; then mkdir ~/.ssh; fi

cp /mnt/.Arch/keys/ssh/config ~/.ssh
chmod 600 ~/.ssh/config

cp -r /mnt/.Arch/keys/ssh/github.com ~/.ssh
chmod 600 ~/.ssh/github.com/*

cp -r /mnt/.Arch/keys/ssh/amazonaws.com ~/.ssh
chmod 600 ~/.ssh/amazonaws.com/*

