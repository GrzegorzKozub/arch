#!/usr/bin/env zsh

set -e -o verbose

# packages

sudo pacman -S --noconfirm \
  plasma-desktop plasma-nm plasma-pa \
  bluedevil powerdevil \
  khotkeys kscreen \
  breeze-gtk \
  plasma-systemmonitor

# links

for APP in \
  assistant \
  designer \
  gnome-system-monitor-kde \
  linguist \
  org.kde.kmenuedit \
  org.kde.kuserfeedback-console \
  qdbusviewer
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i '2iNoDisplay=true' ~/.local/share/applications/$APP.desktop
done

for APP in \
  kdesystemsettings \
  org.kde.klipper
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i '2iNoDisplay=true' ~/.local/share/applications/$APP.desktop
done

for APP in \
  org.kde.plasma-systemmonitor
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i '2iNotShowIn=GNOME;' ~/.local/share/applications/$APP.desktop
done

# settings

# locale

kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/plasma-localerc --group 'Formats' --key 'LC_MEASUREMENT' 'pl_PL.UTF-8'
kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/plasma-localerc --group 'Formats' --key 'LC_MONETARY' 'pl_PL.UTF-8'
kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/plasma-localerc --group 'Formats' --key 'LC_NUMERIC' 'pl_PL.UTF-8'
kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/plasma-localerc --group 'Formats' --key 'LC_PAGE' 'pl_PL.UTF-8'
kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/plasma-localerc --group 'Formats' --key 'LC_TIME' 'pl_PL.UTF-8'

# themes

plasma-apply-lookandfeel --apply 'org.kde.breezedark.desktop' --resetLayout
plasma-apply-colorscheme 'BreezeDark'

/usr/lib/plasma-changeicons 'Papirus'

# wallpapers

[[ -d ${XDG_DATA_HOME:-~/.local/share}/wallpapers ]] || mkdir ${XDG_DATA_HOME:-~/.local/share}/wallpapers
cp `dirname $0`/home/$USER/.local/share/backgrounds/* ${XDG_DATA_HOME:-~/.local/share}/wallpapers

plasma-apply-wallpaperimage ${XDG_DATA_HOME:-~/.local/share}/wallpapers/women.jpg

