set -o verbose

timedatectl set-ntp true

systemctl enable gdm.service
systemctl enable NetworkManager.service

grpck

