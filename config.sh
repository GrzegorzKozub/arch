set -e -o verbose

# time sync

sudo timedatectl set-ntp true

# service autostart

sudo systemctl enable gdm.service
sudo systemctl enable NetworkManager.service
sudo systemctl enable tlp.service

# group check

sudo grpck

# tlp

sudo sed -i 's/CPU_HWP_ON_BAT=balance_power/CPU_HWP_ON_BAT=default/g' /etc/default/tlp

