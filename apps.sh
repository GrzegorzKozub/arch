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

# dotfiles

. `dirname $0`/dotfiles.zsh

# scripts

. `dirname $0`/scripts.sh

# apps

. `dirname $0`/gnome.sh

. `dirname $0`/fonts.sh
. `dirname $0`/terminal.sh

. `dirname $0`/zsh.sh
. `dirname $0`/tmux.sh

# usb unmount

sudo umount -R /mnt

