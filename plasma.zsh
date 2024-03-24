#!/usr/bin/env zsh

set -e -o verbose

# input & output > mouse & touchpad > mouse

# [[ $XDG_SESSION_TYPE = 'x11' ]] &&
#   kwriteconfig6 --file $XDG_CONFIG_HOME/kcminputrc --group 'Mouse' --key 'XLbInptPointerAcceleration' -- '-0.4'

# input & output > mouse & touchpad > touchpad

if [[ $HOST = 'drifter' ]]; then

  [[ $XDG_SESSION_TYPE = 'x11' ]] && FILE=$XDG_CONFIG_HOME/touchpadxlibinputrc
  [[ $XDG_SESSION_TYPE = 'wayland' ]] && FILE=$XDG_CONFIG_HOME/kcminputrc

  for KEY ('naturalScroll' 'tapToClick')
    kwriteconfig6 --file $FILE \
      --group 'Libinput' --group '1739' --group '52710' --group 'DLL0945:00 06CB:CDE6 Touchpad' \
      --key $KEY 'true'

fi

# input & output > mouse & touchpad > screen edges

FILE=$XDG_CONFIG_HOME/kwinrc

for KEY ('BorderActivate' 'BorderActivateAll')
  kwriteconfig6 --file $FILE --group 'Effect-overview' --key $KEY '9'

# input & output > keyboard > layouts

FILE=$XDG_CONFIG_HOME/kxkbrc

kwriteconfig6 --file $FILE --group 'Layout' --key 'LayoutList' 'pl'
kwriteconfig6 --file $FILE --group 'Layout' --key 'Use' 'true'

# input & output > keyboard > shortcuts

FILE=$XDG_CONFIG_HOME/kglobalshortcutsrc

kwriteconfig6 --file $FILE --group 'plasmashell' --key 'stop current activity' 'none,Meta+S,Stop Current Activity'

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
  kwriteconfig6 --file $FILE --group 'kwin' --key $KEY $VAL

sed -i 's/\\\\t/\\t/g' $FILE

FILE=$XDG_CONFIG_HOME/kwinrc

# kwriteconfig6 --file $FILE --group 'ModifierOnlyShortcuts' --key 'Meta' 'org.kde.krunner,/App,,toggleDisplay'
kwriteconfig6 --file $FILE --group 'ModifierOnlyShortcuts' --key 'Meta' 'org.kde.kglobalaccel,/component/kwin,,invokeShortcut,Overview'

qdbus6 org.kde.KWin /KWin reconfigure

# input & output > keyboard > shortcuts > commands

FILE=$XDG_CONFIG_HOME/khotkeysrc

count() {
  echo $(grep --after-context=1 '\[Data\]' $FILE | grep 'DataCount' | cut -d= -f2)
}

rem_shortcut() {
  local nbr=$(grep --before-context=3 "Name=$1" $FILE | grep '\[Data_' | sed -r 's/[^0-9]*//g')
  if [[ $nbr ]]; then
    local id=$(grep --after-context=3 "\[Data_${nbr}Triggers0\]" $FILE | grep 'Uuid' | cut -d= -f2)
    kwriteconfig6 --file $XDG_CONFIG_HOME/kglobalshortcutsrc --group 'khotkeys' --key $id --delete
    sed -i -r -f - $FILE << END
      /^\[Data_${nbr}\]/,+5d
      /^\[Data_${nbr}Actions\]/,+2d
      /^\[Data_${nbr}Actions0\]/,+3d
      /^\[Data_${nbr}Conditions\]/,+3d
      /^\[Data_${nbr}Triggers\]/,+3d
      /^\[Data_${nbr}Triggers0\]/,+4d
END
    kwriteconfig6 --file $FILE --group 'Data' --key 'DataCount' $[$(count) - 1]
  fi
}

add_shortcut() {
  local nbr=$[$(count) + 1]
  local id="{$(uuidgen)}"

  kwriteconfig6 --file $XDG_CONFIG_HOME/kglobalshortcutsrc --group 'khotkeys' --key $id "$1,none,$2"

  typeset -A OPTS=(
    'Comment' ''
    'Enabled' 'true'
    'Name' $2
    'Type' 'SIMPLE_ACTION_DATA'
  )

  for KEY VAL ("${(@kv)OPTS}")
    kwriteconfig6 --file $FILE --group "Data_$nbr" --key $KEY "$VAL"

  kwriteconfig6 --file $FILE --group "Data_${nbr}Actions" --key 'ActionsCount' '1'

  kwriteconfig6 --file $FILE --group "Data_${nbr}Actions0" --key 'CommandURL' $3
  kwriteconfig6 --file $FILE --group "Data_${nbr}Actions0" --key 'Type' 'COMMAND_URL'

  kwriteconfig6 --file $FILE --group "Data_${nbr}Conditions" --key 'Comment' ''
  kwriteconfig6 --file $FILE --group "Data_${nbr}Conditions" --key 'ConditionsCount' '0'

  kwriteconfig6 --file $FILE --group "Data_${nbr}Triggers" --key 'Comment' ''
  kwriteconfig6 --file $FILE --group "Data_${nbr}Triggers" --key 'TriggersCount' '1'

  kwriteconfig6 --file $FILE --group "Data_${nbr}Triggers0" --key 'Key' $1
  kwriteconfig6 --file $FILE --group "Data_${nbr}Triggers0" --key 'Type' 'SHORTCUT'
  kwriteconfig6 --file $FILE --group "Data_${nbr}Triggers0" --key 'Uuid' $id

  kwriteconfig6 --file $FILE --group 'Data' --key 'DataCount' $nbr
}

for NAME ('flameshot gui' 'audio output' 'audio input' 'night light') rem_shortcut $NAME

add_shortcut 'Print' 'flameshot gui' 'flameshot gui'
add_shortcut 'Meta+Ctrl+A' 'audio output' "/home/$USER/code/arch/audio.zsh sink"
add_shortcut 'Meta+Ctrl+M' 'audio input' "/home/$USER/code/arch/audio.zsh source"

[[ $HOST = 'player' ]] &&
  add_shortcut 'Meta+Ctrl+N' 'night light' 'pkill -USR1 redshift'

qdbus6 org.kde.KWin /KWin reconfigure

# input & output > display & monitor

if [[ $HOST = 'drifter' ]]; then

  kscreen-doctor output.eDP-1.scale.2.0
  kwriteconfig6 --file $XDG_CONFIG_HOME/kdeglobals --group 'KScreen' --key 'ScaleFactor' 2.0

fi

if [[ $HOST = 'player' ]]; then

  kscreen-doctor output.DP-4.scale.1.5

  kwriteconfig6 --file $XDG_CONFIG_HOME/kdeglobals --group 'KScreen' --key 'ScaleFactor' 1.5

fi

if [[ $HOST = 'worker' ]]; then

  kscreen-doctor output.DP-2.scale.1.5
  kscreen-doctor output.DP-3.scale.1.5

  kwriteconfig6 --file $XDG_CONFIG_HOME/kdeglobals --group 'KScreen' --key 'ScaleFactor' 1.5

fi

# input & output > accessibility > bell

kwriteconfig6 --file $XDG_CONFIG_HOME/kaccessrc --group 'Bell' --key 'SystemBell' 'false'

# input & output > accessibility > screen reader

kwriteconfig6 --file $XDG_CONFIG_HOME/kaccessrc --group 'ScreenReader' --key 'Enabled' 'false'

# appearance & style > colors & themes > global theme

plasma-apply-lookandfeel --apply 'org.kde.breeze.desktop'

# appearance & style > colors & themes > night light

[[ $HOST = 'drifter' ]] &&
  kwriteconfig6 --file $XDG_CONFIG_HOME/kwinrc --group 'NightColor' --key 'Active' 'true'

# appearance & style > colors & themes > plasma style

kwriteconfig6 --file $XDG_CONFIG_HOME/plasmarc --group 'Theme' --key 'name' 'breeze-dark'

# appearance & style > colors & themes > window decorations

FILE=$XDG_CONFIG_HOME/kwinrc

kwriteconfig6 --file $FILE --group 'org.kde.kdecoration2' --key 'ButtonsOnLeft' ''
kwriteconfig6 --file $FILE --group 'org.kde.kdecoration2' --key 'ButtonsOnRight' 'X'

# appearance & style > colors & themes > icons

/usr/lib/plasma-changeicons 'Papirus'

# appearance & style > colors & themes > cursors

[[ $HOST = 'player' || $HOST = 'worker' ]] &&
  kwriteconfig6 --file $XDG_CONFIG_HOME/kcminputrc --group 'Mouse' --key 'cursorSize' '36'

FILE=$XDG_CONFIG_HOME/klaunchrc

kwriteconfig6 --file $FILE --group 'BusyCursorSettings' --key 'Bouncing' 'false'
kwriteconfig6 --file $FILE --group 'FeedbackStyle' --key 'BusyCursor' 'false'
kwriteconfig6 --file $FILE --group 'FeedbackStyle' --key 'TaskbarButton' 'false'

# appearance & style > colors & themes > system sounds

FILE=$XDG_CONFIG_HOME/kdeglobals

kwriteconfig6 --file $FILE --group 'Sounds' --key 'Enable' 'false'

# appearance & style > colors & themes > splash screen

FILE=$XDG_CONFIG_HOME/ksplashrc

kwriteconfig6 --file $FILE --group 'KSplash' --key 'Engine' 'none'
kwriteconfig6 --file $FILE --group 'KSplash' --key 'Theme' 'None'

# appearance & style > text & fonts > fonts

FILE=$XDG_CONFIG_HOME/kdeglobals

typeset -A OPTS=(
  'fixed' 'Cascadia Code,10,-1,5,50,0,0,0,0,0'
  'font' 'Noto Sans,11,-1,5,50,0,0,0,0,0'
  'menuFont' 'Noto Sans,11,-1,5,50,0,0,0,0,0'
  'smallestReadableFont' 'Noto Sans,9,-1,5,50,0,0,0,0,0'
  'toolBarFont' 'Noto Sans,11,-1,5,50,0,0,0,0,0'
)

for KEY VAL ("${(@kv)OPTS}")
  kwriteconfig6 --file $FILE --group 'General' --key $KEY $VAL

kwriteconfig6 --file $FILE --group 'WM' --key 'activeFont' 'Noto Sans,11,-1,5,50,0,0,0,0,0'

# appearance & style > wallpaper

DIR=$XDG_DATA_HOME/wallpapers

[[ -L $DIR ]] && rm -rf $DIR
ln -s ~/code/walls $DIR

plasma-apply-wallpaperimage $DIR/women.jpg

# apps & windows > default applications

FILE=$XDG_CONFIG_HOME/kdeglobals

kwriteconfig6 --file $FILE --group 'General' --key 'TerminalApplication' 'kitty'
kwriteconfig6 --file $FILE --group 'General' --key 'TerminalService' 'kitty.desktop'

# apps & windows > notifications

kwriteconfig6 --file $XDG_CONFIG_HOME/plasmanotifyrc \
  --group 'DoNotDisturb' --key 'Until' \
  "$[$(date --iso-8601 | cut -d- -f1) + 1],1,1,0,0,0"

# apps & windows > window management > task switcher

# FILE=$XDG_CONFIG_HOME/kwinrc
#
# kwriteconfig6 --file $FILE --group 'TabBox' --key 'ShowTabBox' 'false'

# workspace > search > file search

FILE=$XDG_CONFIG_HOME/baloofilerc

kwriteconfig6 --file $FILE --group 'Basic Settings' --key 'Indexing-Enabled' 'false'

# workspace > search > plasma search

FILE=$XDG_CONFIG_HOME/krunnerrc

kwriteconfig6 --file $FILE --group 'General' --key 'RetainPriorSearch' 'false'

typeset -A OPTS=(
  'baloosearchEnabled' 'false'
  'krunner_appstreamEnabled' 'false'
  'krunner_bookmarksrunnerEnabled' 'false'
  'krunner_recentdocumentsEnabled' 'false'
  'krunner_shellEnabled' 'false'
  'krunner_webshortcutsEnabled' 'false'
)

for KEY VAL ("${(@kv)OPTS}")
  kwriteconfig6 --file $FILE --group 'Plugins' --key $KEY $VAL

# security & privacy > screen locking

FILE=$XDG_CONFIG_HOME/kscreenlockerrc

kwriteconfig6 --file $FILE \
  --group 'Greeter' --group 'LnF' --group 'General' \
  --key 'showMediaControls' 'false'

typeset -A OPTS=(
  'Image' "$XDG_DATA_HOME/wallpapers/women.jpg"
  'PreviewImage' "$XDG_DATA_HOME/wallpapers/women.jpg"
)

for KEY VAL ("${(@kv)OPTS}")
  kwriteconfig6 --file $FILE \
    --group 'Greeter' --group 'Wallpaper' --group 'org.kde.image' --group 'General' \
    --key $KEY $VAL

# security & privacy > recent files

FILE=$XDG_CONFIG_HOME/kactivitymanagerdrc

kwriteconfig6 --file $FILE --group 'Plugins' --key 'org.kde.ActivityManager.ResourceScoringEnabled' 'false'

FILE=$XDG_CONFIG_HOME/kactivitymanagerd-pluginsrc

kwriteconfig6 --file $FILE --group 'Plugin-org.kde.ActivityManager.Resources.Scoring' --key 'what-to-remember' '2'

# language & time > region & language

typeset -A OPTS=(
  'LC_MEASUREMENT' 'pl_PL.UTF-8'
  'LC_MONETARY' 'pl_PL.UTF-8'
  'LC_NUMERIC' 'pl_PL.UTF-8'
  'LC_PAGE' 'pl_PL.UTF-8'
  'LC_TIME' 'pl_PL.UTF-8'
)

for KEY VAL ("${(@kv)OPTS}")
  kwriteconfig6 --file $XDG_CONFIG_HOME/plasma-localerc --group 'Formats' --key $KEY $VAL

# language & time > spell check

kwriteconfig6 --file $XDG_CONFIG_HOME/KDE/Sonnet.conf --group 'General' --key 'preferredLanguages' 'en_US, pl_PL'

# system > energy saving

FILE=$XDG_CONFIG_HOME/powerdevilrc

kwriteconfig6 --file $FILE --group 'AC' --group 'SuspendAndShutdown' --key 'AutoSuspendIdleTimeoutSec' '3600'
kwriteconfig6 --file $FILE --group 'AC' --group 'SuspendAndShutdown' --key 'PowerButtonAction' '1'

if [[ $HOST = 'drifter' ]]; then

  kwriteconfig6 --file $FILE --group 'AC' --group 'Display' --key 'DisplayBrightness' '25'
  kwriteconfig6 --file $FILE --group 'AC' --group 'Display' --key 'UseProfileSpecificDisplayBrightness' 'true'

  kwriteconfig6 --file $FILE --group 'Battery' --group 'SuspendAndShutdown' --key 'AutoSuspendIdleTimeoutSec' '600'
  kwriteconfig6 --file $FILE --group 'Battery' --group 'SuspendAndShutdown' --key 'PowerButtonAction' '1'
  kwriteconfig6 --file $FILE --group 'Battery' --group 'Display' --key 'DisplayBrightness' '25'
  kwriteconfig6 --file $FILE --group 'Battery' --group 'Display' --key 'UseProfileSpecificDisplayBrightness' 'true'

  kwriteconfig6 --file $FILE --group 'LowBattery' --group 'SuspendAndShutdown' --key 'AutoSuspendIdleTimeoutSec' '300'
  kwriteconfig6 --file $FILE --group 'LowBattery' --group 'SuspendAndShutdown' --key 'PowerButtonAction' '1'
  kwriteconfig6 --file $FILE --group 'LowBattery' --group 'Display' --key 'DisplayBrightness' '1'
  kwriteconfig6 --file $FILE --group 'LowBattery' --group 'Display' --key 'UseProfileSpecificDisplayBrightness' 'true'

fi

# session > desktop session

typeset -A OPTS=(
  'confirmLogout' 'false'
  'loginMode' 'emptySession'
)

for KEY VAL ("${(@kv)OPTS}")
  kwriteconfig6 --file $XDG_CONFIG_HOME/ksmserverrc --group 'General' --key $KEY $VAL

# panel

for FILE ('plasmashellrc' 'plasma-org.kde.plasma.desktop-appletsrc')
  cp `dirname $0`/home/$USER/.config/$FILE.$HOST $XDG_CONFIG_HOME/$FILE

