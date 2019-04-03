set -e -o verbose

# time sync

sudo timedatectl set-ntp true

# service autostart

sudo systemctl enable gdm.service
sudo systemctl enable NetworkManager.service

# group check

sudo grpck

# gnome

if [ ! -d ~/Pictures ]; then mkdir ~/Pictures; fi
cp `dirname $0`/home/greg/Pictures/Small\ River.png ~/Pictures

gsettings set org.gnome.desktop.background picture-uri 'file:///home/greg/Pictures/Small%20River.png'
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///home/greg/Pictures/Small%20River.png'

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'pl')]"
gsettings set org.gnome.system.locale region "pl_PL.UTF-8"

gsettings set org.gnome.desktop.interface text-scaling-factor 1.25

gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true

