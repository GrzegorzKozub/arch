#!/usr/bin/env zsh

set -e -o verbose

# https://github.com/shalva97/kde-configuration-files

# locale

CFG=${XDG_CONFIG_HOME:-~/.config}/plasma-localerc

kwriteconfig5 --file $CFG --group 'Formats' --key 'LC_MEASUREMENT' 'pl_PL.UTF-8'
kwriteconfig5 --file $CFG --group 'Formats' --key 'LC_MONETARY' 'pl_PL.UTF-8'
kwriteconfig5 --file $CFG --group 'Formats' --key 'LC_NUMERIC' 'pl_PL.UTF-8'
kwriteconfig5 --file $CFG --group 'Formats' --key 'LC_PAGE' 'pl_PL.UTF-8'
kwriteconfig5 --file $CFG --group 'Formats' --key 'LC_TIME' 'pl_PL.UTF-8'

# keyboard

CFG=${XDG_CONFIG_HOME:-~/.config}/kxkbrc

kwriteconfig5 --file $CFG --group 'Layout' --key 'DisplayNames' ','
kwriteconfig5 --file $CFG --group 'Layout' --key 'LayoutList' 'pl,us'
kwriteconfig5 --file $CFG --group 'Layout' --key 'Use' 'true'

# mouse and touchpad

CFG=${XDG_CONFIG_HOME:-~/.config}/kcminputrc

[[ $XDG_SESSION_TYPE = 'wayland' ]] && kwriteconfig5 --file $CFG --group 'Mouse' --key 'XLbInptPointerAcceleration' -- '-0.8'
[[ $XDG_SESSION_TYPE = 'x11' ]] && kwriteconfig5 --file $CFG --group 'Mouse' --key 'XLbInptPointerAcceleration' -- '-0.4'

# themes

plasma-apply-lookandfeel --apply 'org.kde.breezedark.desktop' # --resetLayout
plasma-apply-colorscheme 'BreezeDark'

/usr/lib/plasma-changeicons 'Papirus'

# wallpapers

DIR=${XDG_DATA_HOME:-~/.local/share}/wallpapers

[[ -d $DIR ]] || mkdir $DIR
cp `dirname $0`/home/$USER/.local/share/backgrounds/* $DIR

plasma-apply-wallpaperimage $DIR/women.jpg

# window decorations

CFG=${XDG_CONFIG_HOME:-~/.config}/kwinrc

kwriteconfig5 --file $CFG --group 'org.kde.kdecoration2' --key 'ButtonsOnLeft' ''
kwriteconfig5 --file $CFG --group 'org.kde.kdecoration2' --key 'ButtonsOnRight' 'IAX'

# panel

sed -i 's/^thickness=.*$/thickness=80/' ${XDG_CONFIG_HOME:-~/.config}/plasmashellrc

CFG=${XDG_CONFIG_HOME:-~/.config}/plasma-org.kde.plasma.desktop-appletsrc

sed -i '/^plugin=org.kde.plasma.pager$/d' $CFG
sed -i '/^plugin=org.kde.plasma.showdesktop$/d' $CFG

echo "$(grep 'org.kde.plasma.kickoff' $CFG --before-context=2 | grep 'Containments')[Configuration][General]" >> $CFG
echo 'alphaSort=true' >> $CFG
echo 'applicationsDisplay=0' >> $CFG
echo 'primaryActions=3' >> $CFG
echo 'showActionButtonCaptions=false' >> $CFG
echo 'systemFavorites=lock-screen\\,logout\\,save-session\\,switch-user\\,suspend\\,hibernate\\,reboot\\,shutdown' >> $CFG

echo "$(grep 'org.kde.plasma.icontasks' $CFG --before-context=2 | grep 'Containments')[Configuration][General]" >> $CFG
echo 'indicateAudioStreams=false' >> $CFG
echo 'launchers=applications:org.kde.dolphin.desktop,applications:kitty.desktop,applications:code.desktop,applications:postman.desktop,preferred://browser,applications:org.keepassxc.KeePassXC.desktop' >> $CFG

sed -i -E 's/^(extraItems=.*)(,org.kde.plasma.mediacontroller)(.*)/\1\3/' $CFG
sed -i '/^extraItems=.*$/a hiddenItems=org.kde.plasma.clipboard,org.kde.plasma.keyboardlayout,org.kde.plasma.notifications' $CFG

echo "$(grep 'org.kde.plasma.digitalclock' $CFG --before-context=2 | grep 'Containments')[Configuration][Apperance]" >> $CFG
echo 'showDate=false' >> $CFG

# dnd

kwriteconfig5 --file ${XDG_CONFIG_HOME:-~/.config}/plasmanotifyrc --group 'DoNotDisturb' --key 'Until' "$[$(date --iso-8601 | cut -d- -f1) + 1],1,1,0,0,0"

# restart apps for some changes to take effect

kquitapp5 plasmashell && kstart5 plasmashell &

