set -e -o verbose

# time sync

sudo timedatectl set-ntp true

# service autostart

sudo systemctl enable gdm.service
sudo systemctl enable laptop-mode.service
sudo systemctl enable NetworkManager.service

# group check

sudo grpck

