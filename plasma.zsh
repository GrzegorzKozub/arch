#!/usr/bin/env zsh

set -e -o verbose

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

typeset -A OPTS=(
  'fixed' 'Cascadia Code,10,-1,5,50,0,0,0,0,0'
  'font' 'Noto Sans,11,-1,5,50,0,0,0,0,0'
  'menuFont' 'Noto Sans,11,-1,5,50,0,0,0,0,0'
  'smallestReadableFont' 'Noto Sans,9,-1,5,50,0,0,0,0,0'
  'toolBarFont' 'Noto Sans,11,-1,5,50,0,0,0,0,0'
)

for KEY VAL ("${(@kv)OPTS}")
  kwriteconfig5 --file $FILE --group 'General' --key $KEY $VAL

kwriteconfig5 --file $FILE --group 'WM' --key 'activeFont' 'Noto Sans,11,-1,5,50,0,0,0,0,0'

# appearance > icons

/usr/lib/plasma-changeicons 'Papirus'

# appearance > cursors

[[ $HOST = 'player' || $HOST = 'worker' ]] &&
  kwriteconfig5 --file $XDG_CONFIG_HOME/kcminputrc --group 'Mouse' --key 'cursorSize' '36'

FILE=$XDG_CONFIG_HOME/klaunchrc

kwriteconfig5 --file $FILE --group 'BusyCursorSettings' --key 'Bouncing' 'false'
kwriteconfig5 --file $FILE --group 'FeedbackStyle' --key 'BusyCursor' 'false'
kwriteconfig5 --file $FILE --group 'FeedbackStyle' --key 'TaskbarButton' 'false'

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

FILE=$XDG_CONFIG_HOME/kwinrc

kwriteconfig5 --file $FILE --group 'TabBox' --key 'ShowTabBox' 'false'

# window management > window rules

FILE=$XDG_CONFIG_HOME/kwinrulesrc

sed -i -r '/^\[\$Version]$|^update_info=.*$/!d' $FILE

ID=$(uuidgen)

typeset -A OPTS=(
  'Description' 'kitty'
  'decocolor' 'BreezeDark'
  'decocolorrule' '2'
  'wmclass' 'kitty'
  'wmclassmatch' '1'
)

for KEY VAL ("${(@kv)OPTS}")
  kwriteconfig5 --file $FILE --group $ID --key $KEY $VAL

kwriteconfig5 --file $FILE --group 'General' --key 'count' '1'
kwriteconfig5 --file $FILE --group 'General' --key 'rules' $ID

# shortcuts > shortcuts

FILE=$XDG_CONFIG_HOME/kglobalshortcutsrc

kwriteconfig5 --file $FILE --group 'plasmashell' --key 'stop current activity' 'none,Meta+S,Stop Current Activity'

typeset -A OPTS=(
  'Activate Window Demanding Attention' 'none,Meta+Ctrl+A,Activate Window Demanding Attention'

  'Window Quick Tile Bottom' 'none,Meta+Down,Quick Tile Window to the Bottom'
  'Window Quick Tile Top' 'none,Meta+Up,Quick Tile Window to the Top'

  'Window Maximize' 'Alt+F10\tMeta+Down\tMeta+Up,Meta+PgUp,Maximize Window'
  'Window Minimize' 'Meta+H,Meta+PgDown,Minimize Window'

  'Window Move' 'Alt+F7,,Move Window'
  'Window Resize' 'Alt+F8,,Resize Window'
  'Window Fullscreen' 'Alt+F11,,Make Window Fullscreen'

  'Window Move Center' 'Meta+Ctrl+C,,Move Window to the Center'

  'Overview' 'Meta+S,Meta+W,Toggle Overview'
)

for KEY VAL ("${(@kv)OPTS}")
  kwriteconfig5 --file $FILE --group 'kwin' --key $KEY $VAL

sed -i 's/\\\\t/\\t/g' $FILE

FILE=$XDG_CONFIG_HOME/kwinrc

# kwriteconfig5 --file $FILE --group 'ModifierOnlyShortcuts' --key 'Meta' 'org.kde.krunner,/App,,toggleDisplay'
kwriteconfig5 --file $FILE --group 'ModifierOnlyShortcuts' --key 'Meta' 'org.kde.kglobalaccel,/component/kwin,,invokeShortcut,Overview'

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

  typeset -A OPTS=(
    'Comment' ''
    'Enabled' 'true'
    'Name' $2
    'Type' 'SIMPLE_ACTION_DATA'
  )

  for KEY VAL ("${(@kv)OPTS}")
    kwriteconfig5 --file $FILE --group "Data_$nbr" --key $KEY "$VAL"

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

for NAME ('flameshot' 'audio output' 'audio input' 'night light') rem_shortcut $NAME

add_shortcut 'Print' 'flameshot' 'flameshot gui'
add_shortcut 'Meta+Ctrl+A' 'audio output' "/home/$USER/code/arch/audio.zsh sink"
add_shortcut 'Meta+Ctrl+M' 'audio input' "/home/$USER/code/arch/audio.zsh source"

[[ $HOST = 'player' || $HOST = 'worker' ]] &&
  add_shortcut 'Meta+Ctrl+N' 'night light' 'pkill -USR1 redshift'

qdbus org.kde.KWin /KWin reconfigure

# startup and shutdown > desktop session

typeset -A OPTS=(
  'confirmLogout' 'false'
  'loginMode' 'emptySession'
)

for KEY VAL ("${(@kv)OPTS}")
  kwriteconfig5 --file $XDG_CONFIG_HOME/ksmserverrc --group 'General' --key $KEY $VAL

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

for KEY VAL ("${(@kv)OPTS}")
  kwriteconfig5 --file $FILE --group 'Plugins' --key $KEY $VAL

# notifications

kwriteconfig5 --file $XDG_CONFIG_HOME/plasmanotifyrc \
  --group 'DoNotDisturb' --key 'Until' \
  "$[$(date --iso-8601 | cut -d- -f1) + 1],1,1,0,0,0"

# regional settings > region & language

typeset -A OPTS=(
  'LC_MEASUREMENT' 'pl_PL.UTF-8'
  'LC_MONETARY' 'pl_PL.UTF-8'
  'LC_NUMERIC' 'pl_PL.UTF-8'
  'LC_PAGE' 'pl_PL.UTF-8'
  'LC_TIME' 'pl_PL.UTF-8'
)

for KEY VAL ("${(@kv)OPTS}")
  kwriteconfig5 --file $XDG_CONFIG_HOME/plasma-localerc --group 'Formats' --key $KEY $VAL

# regional settings > spell check

kwriteconfig5 --file $XDG_CONFIG_HOME/KDE/Sonnet.conf --group 'General' --key 'preferredLanguages' 'en_US, pl_PL'

# accessibility > bell

kwriteconfig5 --file $XDG_CONFIG_HOME/kaccessrc --group 'Bell' --key 'SystemBell' 'false'

# accessibility > screen reader

kwriteconfig5 --file $XDG_CONFIG_HOME/kaccessrc --group 'ScreenReader' --key 'Enabled' 'false'

# applications > default applications

FILE=$XDG_CONFIG_HOME/kdeglobals

kwriteconfig5 --file $FILE --group 'General' --key 'TerminalApplication' 'kitty'
kwriteconfig5 --file $FILE --group 'General' --key 'TerminalService' 'kitty.desktop'

# input devices > keyboard

FILE=$XDG_CONFIG_HOME/kxkbrc

kwriteconfig5 --file $FILE --group 'Layout' --key 'LayoutList' 'pl'
kwriteconfig5 --file $FILE --group 'Layout' --key 'Use' 'true'

# input devices > mouse

# [[ $XDG_SESSION_TYPE = 'x11' ]] &&
#   kwriteconfig5 --file $XDG_CONFIG_HOME/kcminputrc --group 'Mouse' --key 'XLbInptPointerAcceleration' -- '-0.4'

# input devices > touchpad

if [[ $HOST = 'drifter' ]]; then

  [[ $XDG_SESSION_TYPE = 'x11' ]] && FILE=$XDG_CONFIG_HOME/touchpadxlibinputrc
  [[ $XDG_SESSION_TYPE = 'wayland' ]] && FILE=$XDG_CONFIG_HOME/kcminputrc

  for KEY ('naturalScroll' 'tapToClick')
    kwriteconfig5 --file $FILE \
      --group 'Libinput' --group '1739' --group '52710' --group 'DLL0945:00 06CB:CDE6 Touchpad' \
      --key $KEY 'true'

fi

# display and monitor

if [[ $HOST = 'drifter' ]]; then

  kscreen-doctor output.eDP-1.scale.2.0
  kwriteconfig5 --file $XDG_CONFIG_HOME/kdeglobals --group 'KScreen' --key 'ScaleFactor' 2.0

fi

if [[ $HOST = 'player' ]]; then

  kscreen-doctor output.DP-4.scale.1.5

  kwriteconfig5 --file $XDG_CONFIG_HOME/kdeglobals --group 'KScreen' --key 'ScaleFactor' 1.5

fi

if [[ $HOST = 'worker' ]]; then

  kscreen-doctor output.DP-2.scale.1.5
  kscreen-doctor output.DP-3.scale.1.5

  kwriteconfig5 --file $XDG_CONFIG_HOME/kdeglobals --group 'KScreen' --key 'ScaleFactor' 1.5

fi

# display and monitor > night color

[[ $HOST = 'drifter' ]] &&
  kwriteconfig5 --file $XDG_CONFIG_HOME/kwinrc --group 'NightColor' --key 'Active' 'true'

# power management

FILE=$XDG_CONFIG_HOME/powermanagementprofilesrc

kwriteconfig5 --file $FILE --group 'AC' --group 'DimDisplay' --key 'idleTime' '300000'
kwriteconfig5 --file $FILE --group 'AC' --group 'DPMSControl' --key 'idleTime' '600'
kwriteconfig5 --file $FILE --group 'AC' --group 'SuspendSession' --key 'idleTime' '3600000'
kwriteconfig5 --file $FILE --group 'AC' --group 'SuspendSession' --key 'suspendType' '1'
kwriteconfig5 --file $FILE --group 'AC' --group 'HandleButtonEvents' --key 'powerButtonAction' '1'

if [[ $HOST = 'drifter' ]]; then

  kwriteconfig5 --file $FILE --group 'AC' --group 'BrightnessControl' --key 'value' '25'

  kwriteconfig5 --file $FILE --group 'Battery' --group 'BrightnessControl' --key 'value' '25'
  kwriteconfig5 --file $FILE --group 'Battery' --group 'DimDisplay' --key 'idleTime' '120000'
  kwriteconfig5 --file $FILE --group 'Battery' --group 'DPMSControl' --key 'idleTime' '300'
  kwriteconfig5 --file $FILE --group 'Battery' --group 'SuspendSession' --key 'idleTime' '600000'
  kwriteconfig5 --file $FILE --group 'Battery' --group 'SuspendSession' --key 'suspendType' '1'
  kwriteconfig5 --file $FILE --group 'Battery' --group 'HandleButtonEvents' --key 'lidAction' '1'
  kwriteconfig5 --file $FILE --group 'Battery' --group 'HandleButtonEvents' --key 'powerButtonAction' '1'

  kwriteconfig5 --file $FILE --group 'LowBattery' --group 'BrightnessControl' --key 'value' '0'
  kwriteconfig5 --file $FILE --group 'LowBattery' --group 'DimDisplay' --key 'idleTime' '60000'
  kwriteconfig5 --file $FILE --group 'LowBattery' --group 'DPMSControl' --key 'idleTime' '120'
  kwriteconfig5 --file $FILE --group 'LowBattery' --group 'SuspendSession' --key 'idleTime' '300000'
  kwriteconfig5 --file $FILE --group 'LowBattery' --group 'SuspendSession' --key 'suspendType' '1'
  kwriteconfig5 --file $FILE --group 'LowBattery' --group 'HandleButtonEvents' --key 'lidAction' '1'
  kwriteconfig5 --file $FILE --group 'LowBattery' --group 'HandleButtonEvents' --key 'powerButtonAction' '1'

fi

# panel

for FILE ('plasmashellrc' 'plasma-org.kde.plasma.desktop-appletsrc')
  cp `dirname $0`/home/$USER/.config/$FILE.$HOST $XDG_CONFIG_HOME/$FILE

# wallpapers

DIR=$XDG_DATA_HOME/wallpapers

[[ -d $DIR ]] && rm -rf $DIR
ln -s $(dirname $(realpath $0))/home/$USER/.local/share/backgrounds $DIR

plasma-apply-wallpaperimage $DIR/women.jpg

