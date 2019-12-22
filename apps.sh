set -e -o verbose

# usb mount

if [[ $(sudo mount | grep "/dev/sda1") ]]; then sudo umount /dev/sda1; fi
sudo mount /dev/sda1 /mnt

# pacman db sync

sudo pacman -Syu --noconfirm

# dirs

if [ ! -d ~/AUR ]; then mkdir ~/AUR; fi
if [ ! -d ~/Code ]; then mkdir ~/Code; fi

# apps

. `dirname $0`/gnome.sh
. `dirname $0`/openssh.sh
. `dirname $0`/aws.sh
. `dirname $0`/common.sh
. `dirname $0`/nodejs.sh
. `dirname $0`/dotnet.sh
. `dirname $0`/perl.sh
. `dirname $0`/python.sh
. `dirname $0`/ruby.sh
. `dirname $0`/go.sh
. `dirname $0`/elixir.sh
. `dirname $0`/vim.sh
. `dirname $0`/vscode.sh
. `dirname $0`/docker.sh
. `dirname $0`/chrome.sh
. `dirname $0`/keepass.sh
. `dirname $0`/postman.sh
. `dirname $0`/slack.sh
. `dirname $0`/openconnect.sh
#. `dirname $0`/dropbox.sh

# usb unmount

sudo umount -R /mnt

