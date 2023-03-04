#!/usr/bin/env zsh

set -e -o verbose

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

