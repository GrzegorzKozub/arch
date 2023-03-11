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
kwriteconfig5 --file $FILE --group 'org.kde.kdecoration2' --key 'ButtonsOnRight' 'X'

# appearance > fonts

FILE=$XDG_CONFIG_HOME/kdeglobals

kwriteconfig5 --file $FILE --group 'General' --key 'fixed' 'Cascadia Code,10,-1,5,50,0,0,0,0,0'
kwriteconfig5 --file $FILE --group 'General' --key 'font' 'Noto Sans,11,-1,5,50,0,0,0,0,0'
kwriteconfig5 --file $FILE --group 'General' --key 'menuFont' 'Noto Sans,11,-1,5,50,0,0,0,0,0'
kwriteconfig5 --file $FILE --group 'General' --key 'smallestReadableFont' 'Noto Sans,9,-1,5,50,0,0,0,0,0'
kwriteconfig5 --file $FILE --group 'General' --key 'toolBarFont' 'Noto Sans,11,-1,5,50,0,0,0,0,0'

# appearance > icons

/usr/lib/plasma-changeicons 'Papirus'

# appearance > cursors

kwriteconfig5 --file $XDG_CONFIG_HOME/kcminputrc --group 'Mouse' --key 'cursorSize' '36'

# appearance > splash screen

FILE=$XDG_CONFIG_HOME/ksplashrc

kwriteconfig5 --file $FILE --group 'KSplash' --key 'Engine' 'none'
kwriteconfig5 --file $FILE --group 'KSplash' --key 'Theme' 'None'

# workspace behavior > general behavior

FILE=$XDG_CONFIG_HOME/kdeglobals

kwriteconfig5 --file $FILE --group 'KDE' --key 'SingleClick' 'false'

# workspace behavior > scren edges

FILE=$XDG_CONFIG_HOME/kwinrc

kwriteconfig5 --file $FILE --group 'Effect-windowview' --key 'BorderActivateAll' '9'

# workspace behavior > screen locking

FILE=$XDG_CONFIG_HOME/kscreenlockerrc

kwriteconfig5 --file $FILE \
  --group 'Greeter' --group 'LnF' --group 'General' \
  --key 'showMediaControls' 'false'

typeset -A OPTS=(
  'Image' "$XDG_DATA_HOME/wallpapers/women.jpg"
  'PreviewImage' "$XDG_DATA_HOME/wallpapers/women.jpg"
)

for KEY VAL ("${(@kv)OPTS}")
  kwriteconfig5 --file $FILE \
    --group 'Greeter' --group 'Wallpaper' --group 'org.kde.image' --group 'General' \
    --key $KEY $VAL

# window management > task switcher

FILE=$XDG_CONFIG_HOME/kwinrulesrc

kwriteconfig5 --file $FILE --group 'TabBox' --key 'ShowTabBox' 'false'

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

# shortcuts > shortcuts

FILE=$XDG_CONFIG_HOME/kglobalshortcutsrc

kwriteconfig5 --file $FILE --group 'kaccess' --key 'Toggle Screen Reader On and Off' 'none,Meta+Alt+S,Toggle Screen Reader On and Off'

kwriteconfig5 --file $XDG_CONFIG_HOME/kwinrc --group 'ModifierOnlyShortcuts' --key Meta 'org.kde.krunner,/App,,toggleDisplay'

kwriteconfig5 --file $FILE --group 'kwin' --key 'Activate Window Demanding Attention' 'none,Meta+Ctrl+A,Activate Window Demanding Attention'

kwriteconfig5 --file $FILE --group 'kwin' --key 'Window Maximize' 'Meta+Down\tMeta+Up,Meta+PgUp,Maximize Window'
kwriteconfig5 --file $FILE --group 'kwin' --key 'Window Minimize' 'Meta+H,Meta+PgDown,Minimize Window'

kwriteconfig5 --file $FILE --group 'kwin' --key 'Window Move Center' 'Meta+Ctrl+C,,Move Window to the Center'

kwriteconfig5 --file $FILE --group 'kwin' --key 'Window Quick Tile Bottom' 'none,Meta+Down,Quick Tile Window to the Bottom'
kwriteconfig5 --file $FILE --group 'kwin' --key 'Window Quick Tile Top' 'none,Meta+Up,Quick Tile Window to the Top'

kwriteconfig5 --file $FILE --group 'kwin' --key 'Switch to Previous Desktop' 'Meta+PgUp,,Switch to Previous Desktop'
kwriteconfig5 --file $FILE --group 'kwin' --key 'Switch to Next Desktop' 'Meta+PgDown,,Switch to Next Desktop'

kwriteconfig5 --file $FILE --group 'kwin' --key 'Window to Previous Desktop' 'Meta+Shift+PgUp,,Window to Previous Desktop'
kwriteconfig5 --file $FILE --group 'kwin' --key 'Window to Next Desktop' 'Meta+Shift+PgDown,,Window to Next Desktop'

qdbus org.kde.KWin /KWin reconfigure

# shortcuts > custom shortcuts

FILE=$XDG_CONFIG_HOME/khotkeysrc

count() {
  echo $(grep --after-context=1 '\[Data\]' $FILE | grep 'DataCount' | cut -d= -f2)
}

rem_shortcut() {
  local nbr=$(grep --before-context=3 "Name=$1" $FILE | grep '\[Data_' | sed -r 's/[^0-9]*//g')
  if [[ $nbr ]]; then
    local id=$(grep --after-context=3 "\[Data_${nbr}Triggers0\]" $FILE | grep 'Uuid' | cut -d= -f2)
    kwriteconfig5 --file $XDG_CONFIG_HOME/kglobalshortcutsrc --group 'khotkeys' --key $id --delete
    sed -i -r -f - $FILE << END
      /^\[Data_${nbr}\]/,+5d
      /^\[Data_${nbr}Actions\]/,+2d
      /^\[Data_${nbr}Actions0\]/,+3d
      /^\[Data_${nbr}Conditions\]/,+3d
      /^\[Data_${nbr}Triggers\]/,+3d
      /^\[Data_${nbr}Triggers0\]/,+4d
END
    kwriteconfig5 --file $FILE --group 'Data' --key 'DataCount' $[$(count) - 1]
  fi
}

add_shortcut() {
  local nbr=$[$(count) + 1]
  local id="{$(uuidgen)}"

  kwriteconfig5 --file $XDG_CONFIG_HOME/kglobalshortcutsrc --group 'khotkeys' --key $id "$1,none,$2"

  kwriteconfig5 --file $FILE --group "Data_$nbr" --key 'Comment' ''
  kwriteconfig5 --file $FILE --group "Data_$nbr" --key 'Enabled' 'true'
  kwriteconfig5 --file $FILE --group "Data_$nbr" --key 'Name' $2
  kwriteconfig5 --file $FILE --group "Data_$nbr" --key 'Type' 'SIMPLE_ACTION_DATA'

  kwriteconfig5 --file $FILE --group "Data_${nbr}Actions" --key 'ActionsCount' '1'
  kwriteconfig5 --file $FILE --group "Data_${nbr}Actions0" --key 'CommandURL' $3
  kwriteconfig5 --file $FILE --group "Data_${nbr}Actions0" --key 'Type' 'COMMAND_URL'

  kwriteconfig5 --file $FILE --group "Data_${nbr}Conditions" --key 'Comment' ''
  kwriteconfig5 --file $FILE --group "Data_${nbr}Conditions" --key 'ConditionsCount' '0'

  kwriteconfig5 --file $FILE --group "Data_${nbr}Triggers" --key 'Comment' ''
  kwriteconfig5 --file $FILE --group "Data_${nbr}Triggers" --key 'TriggersCount' '1'
  kwriteconfig5 --file $FILE --group "Data_${nbr}Triggers0" --key 'Key' $1
  kwriteconfig5 --file $FILE --group "Data_${nbr}Triggers0" --key 'Type' 'SHORTCUT'
  kwriteconfig5 --file $FILE --group "Data_${nbr}Triggers0" --key 'Uuid' $id

  kwriteconfig5 --file $FILE --group 'Data' --key 'DataCount' $nbr
}

for NAME ('flameshot' 'night light' 'audio output' 'audio input') rem_shortcut $NAME

if [[ $HOST = 'worker' ]]; then
  add_shortcut 'Print' 'flameshot' "env QT_SCREEN_SCALE_FACTORS='1.5,1.5' flameshot gui"
else
  add_shortcut 'Print' 'flameshot' 'flameshot gui'
fi

add_shortcut 'Meta+Ctrl+N' 'night light' 'pkill -USR1 redshift'
add_shortcut 'Meta+Ctrl+A' 'audio output' "/home/$USER/code/arch/audio.zsh sink"
add_shortcut 'Meta+Ctrl+M' 'audio input' "/home/$USER/code/arch/audio.zsh source"

qdbus org.kde.KWin /KWin reconfigure

# startup and shutdown > desktop session

FILE=$XDG_CONFIG_HOME/ksmserverrc

typeset -A OPTS=(
  'confirmLogout' 'false'
  'loginMode' 'emptySession'
)

for KEY VAL ("${(@kv)OPTS}") kwriteconfig5 --file $FILE --group 'General' --key $KEY $VAL

# search > file search

FILE=$XDG_CONFIG_HOME/baloofilerc

kwriteconfig5 --file $FILE --group 'Basic Settings' --key 'Indexing-Enabled' 'false'

# search > plasma search

FILE=$XDG_CONFIG_HOME/krunnerrc

kwriteconfig5 --file $FILE --group 'General' --key 'RetainPriorSearch' 'false'

typeset -A OPTS=(
  'bookmarksEnabled' 'false'
  'shellEnabled' 'false'
  'baloosearchEnabled' 'false'
  'recentdocumentsEnabled' 'false'
  'appstreamEnabled' 'false'
  'krunner_systemsettingsEnabled' 'false'
  'webshortcutsEnabled' 'false'
)

for KEY VAL ("${(@kv)OPTS}") kwriteconfig5 --file $FILE --group 'Plugins' --key $KEY $VAL

# notifications

kwriteconfig5 --file $XDG_CONFIG_HOME/plasmanotifyrc \
  --group 'DoNotDisturb' --key 'Until' \
  "$[$(date --iso-8601 | cut -d- -f1) + 1],1,1,0,0,0"

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
  /^plugin=org.kde.plasma.kickoff$/d
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
iconSpacing=3
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
autoFontAndSize=false
customDateFormat=d MMM
dateFormat=custom
fontFamily=Noto Sans
fontSize=14
fontStyleName=Regular
END

cat << END >> $FILE
$(grep --before-context=2 'org.kde.plasma.digitalclock' $FILE | grep 'Containments')[Configuration][Apperance]
showDate=false
END

