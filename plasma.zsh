#!/usr/bin/env zsh

set -e -o verbose

# https://github.com/shalva97/kde-configuration-files

# appearance > global theme

plasma-apply-lookandfeel --apply 'org.kde.breeze.desktop'

# appearance > plasma style

kwriteconfig5 --file $XDG_CONFIG_HOME/plasmarc --group 'Theme' --key 'name' 'breeze-dark'

# appearance > window decorations

FILE=$XDG_CONFIG_HOME/kwinrc

kwriteconfig5 --file $FILE --group 'org.kde.kdecoration2' --key 'ButtonsOnLeft' ''
kwriteconfig5 --file $FILE --group 'org.kde.kdecoration2' --key 'ButtonsOnRight' 'IAX'

# appearance > fonts

# ...

# appearance > icons

/usr/lib/plasma-changeicons 'Papirus'

# appearance > cursors

kwriteconfig5 --file $XDG_CONFIG_HOME/kcminputrc --group 'Mouse' --key 'cursorSize' '36'

# appearance > splash screen

FILE=$XDG_CONFIG_HOME/ksplashrc

kwriteconfig5 --file $FILE --group 'KSplash' --key 'Engine' 'none'
kwriteconfig5 --file $FILE --group 'KSplash' --key 'Theme' 'None'

# window management > window rules

FILE=$XDG_CONFIG_HOME/kwinrulesrc

sed -i -r '/^\[\$Version]$|^update_info=.*$/!d' $FILE

ID=$(uuidgen)

kwriteconfig5 --file $FILE --group $ID --key 'Description' 'kitty'
kwriteconfig5 --file $FILE --group $ID --key 'decocolor' 'BreezeDark'
kwriteconfig5 --file $FILE --group $ID --key 'decocolorrule' '2'
kwriteconfig5 --file $FILE --group $ID --key 'wmclass' 'kitty'
kwriteconfig5 --file $FILE --group $ID --key 'wmclassmatch' '1'

kwriteconfig5 --file $FILE --group 'General' --key 'count' '1'
kwriteconfig5 --file $FILE --group 'General' --key 'rules' $ID

# shortcuts > custom shortcuts

shortcut() {
  local file=$XDG_CONFIG_HOME/khotkeysrc

  local old_data=$(grep --before-context=3 "Name=$2" $file | grep '\[Data_' | sed -r 's/\[|\]//g')
  local old_id=$(grep --after-context=3 "\[${old_data}Triggers0\]" $file | grep 'Uuid' | cut -d= -f2)

  local id=$(uuidgen)
  local count=$[$(grep --after-context=1 '\[Data\]' $file | grep 'DataCount' | cut -d= -f2) + 1]

  sed -i "/$old_id/d" $XDG_CONFIG_HOME/kglobalshortcutsrc

  sed -i "/^\[${old_data}\]/,+5d" $file
  sed -i "/^\[${old_data}Actions\]/,+2d" $file
  sed -i "/^\[${old_data}Actions0\]/,+3d" $file
  sed -i "/^\[${old_data}Conditions\]/,+3d" $file
  sed -i "/^\[${old_data}Triggers\]/,+3d" $file
  sed -i "/^\[${old_data}Triggers0\]/,+4d" $file

  # kwriteconfig5 --file $file --group 'Data' --key 'DataCount' $count
  #
  # kwriteconfig5 --file $file --group "Data_$count" --key 'Comment' ''
  # kwriteconfig5 --file $file --group "Data_$count" --key 'Enabled' 'true'
  # kwriteconfig5 --file $file --group "Data_$count" --key 'Name' $2
  # kwriteconfig5 --file $file --group "Data_$count" --key 'Type' 'SIMPLE_ACTION_DATA'
  #
  # kwriteconfig5 --file $file --group "Data_${count}Actions" --key 'ActionsCount' '1'
  # kwriteconfig5 --file $file --group "Data_${count}Actions0" --key 'CommandURL' $3
  # kwriteconfig5 --file $file --group "Data_${count}Actions0" --key 'Type' 'COMMAND_URL'
  #
  # kwriteconfig5 --file $file --group "Data_${count}Conditions" --key 'Comment' ''
  # kwriteconfig5 --file $file --group "Data_${count}Conditions" --key 'ConditionsCount' '0'
  #
  # kwriteconfig5 --file $file --group "Data_${count}Triggers" --key 'Comment' ''
  # kwriteconfig5 --file $file --group "Data_${count}Triggers" --key 'TriggersCount' '1'
  # kwriteconfig5 --file $file --group "Data_${count}Triggers0" --key 'Key' $1
  # kwriteconfig5 --file $file --group "Data_${count}Triggers0" --key 'Type' 'SHORTCUT'
  # kwriteconfig5 --file $file --group "Data_${count}Triggers0" --key 'Uuid' "{$id}"
  #
  # kwriteconfig5 --file $XDG_CONFIG_HOME/kglobalshortcutsrc --group 'khotkeys' --key "{$id}" "$1,none,$2"
}

if [[ $HOST = 'worker' ]]; then
  shortcut 'Print' 'flameshot' "env QT_SCREEN_SCALE_FACTORS='1.5,1.5' flameshot gui"
else
  shortcut 'Print' 'flameshot' 'flameshot gui'
fi

sed -i 's/^Activate Window Demanding Attention=Meta+Ctrl+A/Activate Window Demanding Attention=none/' $XDG_CONFIG_HOME/kglobalshortcutsrc

# shortcut 'Meta+Ctrl+A' 'audio output' 'audio.zsh sink'
# shortcut 'Meta+Ctrl+M' 'audio input' 'audio.zsh source'
# shortcut 'Meta+Ctrl+N' 'night light' 'pkill -USR1 redshift'

# notifications

kwriteconfig5 --file $XDG_CONFIG_HOME/plasmanotifyrc --group 'DoNotDisturb' --key 'Until' "$[$(date --iso-8601 | cut -d- -f1) + 1],1,1,0,0,0"

# regional settings > region & language

FILE=$XDG_CONFIG_HOME/plasma-localerc

kwriteconfig5 --file $FILE --group 'Formats' --key 'LC_MEASUREMENT' 'pl_PL.UTF-8'
kwriteconfig5 --file $FILE --group 'Formats' --key 'LC_MONETARY' 'pl_PL.UTF-8'
kwriteconfig5 --file $FILE --group 'Formats' --key 'LC_NUMERIC' 'pl_PL.UTF-8'
kwriteconfig5 --file $FILE --group 'Formats' --key 'LC_PAGE' 'pl_PL.UTF-8'
kwriteconfig5 --file $FILE --group 'Formats' --key 'LC_TIME' 'pl_PL.UTF-8'

# input devices > keyboard

FILE=$XDG_CONFIG_HOME/kxkbrc

kwriteconfig5 --file $FILE --group 'Layout' --key 'LayoutList' 'pl'
kwriteconfig5 --file $FILE --group 'Layout' --key 'Use' 'true'

# input devices > mouse

[[ $XDG_SESSION_TYPE = 'wayland' ]] && VAL='-0.8'
[[ $XDG_SESSION_TYPE = 'x11' ]] && VAL='-0.4'

kwriteconfig5 --file $XDG_CONFIG_HOME/kcminputrc --group 'Mouse' --key 'XLbInptPointerAcceleration' -- $VAL

# display and monitor

# kscreen-doctor output.DP-4.scale.1.5
# kwriteconfig5 --file $XDG_CONFIG_HOME/kdeglobals --group 'KScreen' --key 'ScaleFactor' '1.5'

# wallpapers

DIR=$XDG_DATA_HOME/wallpapers

[[ -d $DIR ]] && rm -rf $DIR
ln -s $(dirname $(realpath $0))/home/$USER/.local/share/backgrounds $DIR

plasma-apply-wallpaperimage $DIR/women.jpg

# panel

sed -i 's/^thickness=.*$/thickness=80/' $XDG_CONFIG_HOME/plasmashellrc

FILE=$XDG_CONFIG_HOME/plasma-org.kde.plasma.desktop-appletsrc

sed -i -f - $FILE << END
  /^plugin=org.kde.plasma.pager$/d
  /^plugin=org.kde.plasma.showdesktop$/d
END

# panel > application launcher

cat << END >> $FILE
$(grep --before-context=2 'org.kde.plasma.kickoff' $FILE | grep 'Containments')[Configuration][General]
alphaSort=true
applicationsDisplay=0
primaryActions=3
showActionButtonCaptions=false
systemFavorites=lock-screen\\,logout\\,save-session\\,switch-user\\,suspend\\,hibernate\\,reboot\\,shutdown
END

# panel > icons-only task manager

cat << END >> $FILE
$(grep --before-context=2 'org.kde.plasma.icontasks' $FILE | grep 'Containments')[Configuration][General]
indicateAudioStreams=false
launchers=applications:org.kde.dolphin.desktop,applications:kitty.desktop,applications:code.desktop,applications:postman.desktop,applications:brave-browser.desktop,applications:org.keepassxc.KeePassXC.desktop
END

# panel > system tray

sed -i -r -f - $FILE << END
  /^plugin=org.kde.kscreen$/d
  /^plugin=org.kde.plasma.mediacontroller$/d
  s/^(extraItems=.*)(,org.kde.kscreen)(.*)/\1\3/
  s/^(extraItems=.*)(,org.kde.plasma.mediacontroller)(.*)/\1\3/
  /^hiddenItems=.*$/d
  /^extraItems=.*$/a hiddenItems=org.kde.plasma.clipboard,org.kde.plasma.keyboardlayout,org.kde.plasma.notifications
  /^shownItems=.*$/d
END

# panel > digital clock

cat << END >> $FILE
$(grep --before-context=2 'org.kde.plasma.digitalclock' $FILE | grep 'Containments')[Configuration][Appearance]
customDateFormat=d MMM
dateFormat=custom
END

cat << END >> $FILE
$(grep --before-context=2 'org.kde.plasma.digitalclock' $FILE | grep 'Containments')[Configuration][Apperance]
showDate=false
END

