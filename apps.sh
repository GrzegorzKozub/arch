set -e -o verbose

# usb mount

if [[ $(sudo mount | grep "/dev/sda1") ]]; then sudo umount /dev/sda1; fi
sudo mount /dev/sda1 /mnt

# pacman db sync

sudo pacman -Syu --noconfirm

# apps

. `dirname $0`/yay.sh

. `dirname $0`/fonts.sh

. `dirname $0`/gnome.sh
. `dirname $0`/terminal.sh

. `dirname $0`/openssh.sh
. `dirname $0`/aws.sh
. `dirname $0`/scripts.sh

. `dirname $0`/common.sh
. `dirname $0`/git.sh

. `dirname $0`/dotnet.sh
. `dirname $0`/elixir.sh
. `dirname $0`/go.sh
. `dirname $0`/nodejs.sh
. `dirname $0`/perl.sh
. `dirname $0`/python.sh
. `dirname $0`/ruby.sh

. `dirname $0`/chromium.sh
. `dirname $0`/docker.sh
. `dirname $0`/dropbox.sh
. `dirname $0`/keepass.sh
. `dirname $0`/openconnect.sh
. `dirname $0`/postman.sh
. `dirname $0`/slack.sh
. `dirname $0`/vim.sh
. `dirname $0`/vscode.sh

. `dirname $0`/zsh.sh

# usb unmount

sudo umount -R /mnt

