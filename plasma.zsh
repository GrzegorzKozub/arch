#!/usr/bin/env zsh

set -e -o verbose

# locale

kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/plasma-localerc --group 'Formats' --key 'LC_MEASUREMENT' 'pl_PL.UTF-8'
kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/plasma-localerc --group 'Formats' --key 'LC_MONETARY' 'pl_PL.UTF-8'
kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/plasma-localerc --group 'Formats' --key 'LC_NUMERIC' 'pl_PL.UTF-8'
kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/plasma-localerc --group 'Formats' --key 'LC_PAGE' 'pl_PL.UTF-8'
kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/plasma-localerc --group 'Formats' --key 'LC_TIME' 'pl_PL.UTF-8'

# keyboard

kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/kxkbrc --group 'Layout' --key 'DisplayNames' ','
kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/kxkbrc --group 'Layout' --key 'LayoutList' 'pl,us'
kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/kxkbrc --group 'Layout' --key 'Use' 'true'

# mouse and touchpad

[[ $XDG_SESSION_TYPE = 'wayland' ]] && kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/kcminputrc --group 'Mouse' --key 'XLbInptPointerAcceleration' -- '-0.8'
[[ $XDG_SESSION_TYPE = 'x11' ]] && kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/kcminputrc --group 'Mouse' --key 'XLbInptPointerAcceleration' -- '-0.4'

# themes

plasma-apply-lookandfeel --apply 'org.kde.breezedark.desktop' --resetLayout
plasma-apply-colorscheme 'BreezeDark'

/usr/lib/plasma-changeicons 'Papirus'

# wallpapers

[[ -d ${XDG_DATA_HOME:-~/.local/share}/wallpapers ]] || mkdir ${XDG_DATA_HOME:-~/.local/share}/wallpapers
cp `dirname $0`/home/$USER/.local/share/backgrounds/* ${XDG_DATA_HOME:-~/.local/share}/wallpapers

plasma-apply-wallpaperimage ${XDG_DATA_HOME:-~/.local/share}/wallpapers/women.jpg

# shell

kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/kwinrc --group 'org.kde.kdecoration2' --key 'ButtonsOnLeft' ''
kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/kwinrc --group 'org.kde.kdecoration2' --key 'ButtonsOnRight' 'IAX'

