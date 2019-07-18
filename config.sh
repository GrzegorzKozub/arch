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

UUID=$(gsettings get org.gnome.Terminal.ProfilesList default)
UUID=${UUID:1:-1}
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/default-size-columns" 100
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/default-size-rows" 25
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/font" "'Fira Code weight=453 12'" # Retina
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/use-system-font" false
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/audible-bell" false
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/use-theme-colors" false
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/palette" "['rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)', 'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', 'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)', 'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', 'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', 'rgb(253,246,227)']"
unset UUID

