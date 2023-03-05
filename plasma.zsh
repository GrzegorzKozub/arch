#!/usr/bin/env zsh

set -e -o verbose

# https://github.com/shalva97/kde-configuration-files

# config

CONFIG=${XDG_CONFIG_HOME:-~/.config}

# locale

FILE=$CONFIG/plasma-localerc

kwriteconfig5 --file $FILE --group 'Formats' --key 'LC_MEASUREMENT' 'pl_PL.UTF-8'
kwriteconfig5 --file $FILE --group 'Formats' --key 'LC_MONETARY' 'pl_PL.UTF-8'
kwriteconfig5 --file $FILE --group 'Formats' --key 'LC_NUMERIC' 'pl_PL.UTF-8'
kwriteconfig5 --file $FILE --group 'Formats' --key 'LC_PAGE' 'pl_PL.UTF-8'
kwriteconfig5 --file $FILE --group 'Formats' --key 'LC_TIME' 'pl_PL.UTF-8'

# keyboard

FILE=$CONFIG/kxkbrc

kwriteconfig5 --file $FILE --group 'Layout' --key 'DisplayNames' ','
kwriteconfig5 --file $FILE --group 'Layout' --key 'LayoutList' 'pl,us'
kwriteconfig5 --file $FILE --group 'Layout' --key 'Use' 'true'

# mouse and touchpad

FILE=$CONFIG/kcminputrc

[[ $XDG_SESSION_TYPE = 'wayland' ]] && kwriteconfig5 --file $FILE --group 'Mouse' --key 'XLbInptPointerAcceleration' -- '-0.8'
[[ $XDG_SESSION_TYPE = 'x11' ]] && kwriteconfig5 --file $FILE --group 'Mouse' --key 'XLbInptPointerAcceleration' -- '-0.4'

# themes

plasma-apply-lookandfeel --apply 'org.kde.breezedark.desktop' # --resetLayout
plasma-apply-colorscheme 'BreezeDark'

/usr/lib/plasma-changeicons 'Papirus'

# wallpapers

DIR=${XDG_DATA_HOME:-~/.local/share}/wallpapers
[[ -d $DIR ]] && rm -rf $DIR
ln -s $(dirname $(realpath $0))/home/$USER/.local/share/backgrounds $DIR

plasma-apply-wallpaperimage $DIR/women.jpg

# window decorations

FILE=$CONFIG/kwinrc

kwriteconfig5 --file $FILE --group 'org.kde.kdecoration2' --key 'ButtonsOnLeft' ''
kwriteconfig5 --file $FILE --group 'org.kde.kdecoration2' --key 'ButtonsOnRight' 'IAX'

# panel

sed -i 's/^thickness=.*$/thickness=80/' $CONFIG/plasmashellrc

FILE=$CONFIG/plasma-org.kde.plasma.desktop-appletsrc

sed -i '/^plugin=org.kde.plasma.pager$/d' $FILE
sed -i '/^plugin=org.kde.plasma.showdesktop$/d' $FILE

echo "$(grep 'org.kde.plasma.kickoff' $FILE --before-context=2 | grep 'Containments')[Configuration][General]" >> $FILE
echo 'alphaSort=true' >> $FILE
echo 'applicationsDisplay=0' >> $FILE
echo 'primaryActions=3' >> $FILE
echo 'showActionButtonCaptions=false' >> $FILE
echo 'systemFavorites=lock-screen\\,logout\\,save-session\\,switch-user\\,suspend\\,hibernate\\,reboot\\,shutdown' >> $FILE

echo "$(grep 'org.kde.plasma.icontasks' $FILE --before-context=2 | grep 'Containments')[Configuration][General]" >> $FILE
echo 'indicateAudioStreams=false' >> $FILE
echo 'launchers=applications:org.kde.dolphin.desktop,applications:kitty.desktop,applications:code.desktop,applications:postman.desktop,preferred://browser,applications:org.keepassxc.KeePassXC.desktop' >> $FILE

sed -i -E 's/^(extraItems=.*)(,org.kde.plasma.mediacontroller)(.*)/\1\3/' $FILE
sed -i '/^extraItems=.*$/a hiddenItems=org.kde.plasma.clipboard,org.kde.plasma.keyboardlayout,org.kde.plasma.notifications' $FILE

echo "$(grep 'org.kde.plasma.digitalclock' $FILE --before-context=2 | grep 'Containments')[Configuration][Apperance]" >> $FILE
echo 'showDate=false' >> $FILE

# dnd

kwriteconfig5 --file $CONFIG/plasmanotifyrc --group 'DoNotDisturb' --key 'Until' "$[$(date --iso-8601 | cut -d- -f1) + 1],1,1,0,0,0"

# restart apps for some changes to take effect

kquitapp5 plasmashell && kstart5 plasmashell &

