#!/usr/bin/zsh

set -e -o verbose

# validation

if [[ . == `dirname $0` ]]; then exit 1; fi

# usb mount

ARCHISO=$(lsblk -r -o NAME,LABEL | grep ARCH | sed -e 's/\s.*$//')
if [[ ! $ARCHISO ]]; then exit 1; fi

if [[ $(sudo mount | grep "/dev/$ARCHISO") ]]; then sudo umount /dev/$ARCHISO; fi
sudo mount /dev/$ARCHISO /mnt

unset $ARCHISO

# pacman db sync

sudo pacman -Syu --noconfirm

# git

. `dirname $0`/git.sh
. `dirname $0`/openssh.sh

# config

. `dirname $0`/dotfiles.zsh
. `dirname $0`/scripts.sh

# gnome

. `dirname $0`/fonts.sh

. `dirname $0`/gnome.sh
. `dirname $0`/terminal.sh

# terminal

. `dirname $0`/common.sh

. `dirname $0`/zsh.sh
. `dirname $0`/tmux.sh
. `dirname $0`/ranger.sh
. `dirname $0`/vim.sh

. `dirname $0`/aws.sh
. `dirname $0`/docker.sh

. `dirname $0`/dotnet.sh
. `dirname $0`/elixir.sh
. `dirname $0`/go.sh
. `dirname $0`/nodejs.sh
. `dirname $0`/perl.sh
. `dirname $0`/python.sh
. `dirname $0`/ruby.sh

. `dirname $0`/chrome.sh
. `dirname $0`/dropbox.sh
. `dirname $0`/flameshot.sh
. `dirname $0`/keepass.sh
. `dirname $0`/openconnect.sh
. `dirname $0`/peek.sh
. `dirname $0`/postman.sh
. `dirname $0`/slack.sh
. `dirname $0`/vscode.sh

# dotfiles init

. ~/.dotfiles.sh

# usb unmount

sudo umount -R /mnt

