set -e -o verbose

# usb mount

if [[ $(sudo mount | grep "/dev/sda1") ]]; then sudo umount /dev/sda1; fi
sudo mount /dev/sda1 /mnt

# pacman db sync

sudo pacman -Syu --noconfirm

# config

. `dirname $0`/gnome.sh

. `dirname $0`/git.sh
. `dirname $0`/yay.sh

. `dirname $0`/openssh.sh
. `dirname $0`/aws.sh
. `dirname $0`/scripts.sh

. `dirname $0`/fonts.sh
. `dirname $0`/terminal.sh

. `dirname $0`/zsh.sh

# usb unmount

sudo umount -R /mnt

