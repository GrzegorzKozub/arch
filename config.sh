set -e -o verbose

# time sync

sudo timedatectl set-ntp true

# service autostart

sudo systemctl enable gdm.service
sudo systemctl enable NetworkManager.service

# group check

sudo grpck

# dirs

if [ ! -d ~/AUR ]; then mkdir ~/AUR; fi

# terminal

. `dirname $0`/fonts.sh
. `dirname $0`/terminal.sh
. `dirname $0`/zsh.sh

