set -e -o verbose

# internet

sudo wifi-menu
sleep 10

# usb mount

if [[ $(sudo mount | grep "/dev/sda1") ]]; then sudo umount /dev/sda1; fi
sudo mount /dev/sda1 /mnt

# pacman db sync

sudo pacman -Syu --noconfirm

# dirs

if [ ! -d ~/AUR ]; then mkdir ~/AUR; fi
if [ ! -d ~/Code ]; then mkdir ~/Code; fi

# apps

. ./git.sh
. ./openssh.sh
. ./aws.sh
. ./code.sh
. ./fonts.sh
. ./zsh.sh
. ./nodejs.sh
. ./dotnet.sh
. ./perl.sh
. ./python.sh
. ./ruby.sh
. ./go.sh
. ./elixir.sh
. ./vim.sh
. ./vscode.sh
. ./docker.sh
. ./chrome.sh
. ./keepass.sh

# usb unmount

sudo umount -R /mnt

