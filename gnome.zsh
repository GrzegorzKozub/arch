#!/usr/bin/env zsh

set -e -o verbose

# appearance

DIR=$XDG_DATA_HOME/backgrounds

[[ -d $DIR ]] && rm -rf $DIR
ln -s $(dirname $(realpath $0))/home/$USER/.local/share/backgrounds $DIR

FILE="file:///home/$USER/.local/share/backgrounds/women.jpg"

gsettings set org.gnome.desktop.background picture-uri $FILE
gsettings set org.gnome.desktop.background picture-uri-dark $FILE

gsettings set org.gnome.desktop.screensaver picture-uri $FILE

# notifications

gsettings set org.gnome.desktop.notifications show-banners false
gsettings set org.gnome.desktop.notifications show-in-lock-screen false

# search

gsettings set org.gnome.desktop.search-providers disabled "['org.gnome.Nautilus.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Software.desktop']"
gsettings set org.gnome.desktop.search-providers disable-external true

# applications > document viewer

gsettings set org.gnome.Evince.Default show-sidebar false
gsettings set org.gnome.Evince.Default sizing-mode 'fit-width'

xdg-mime default org.gnome.Evince.desktop application/pdf

# applications > files

gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

dconf write /org/gtk/settings/file-chooser/show-hidden true
dconf write /org/gtk/settings/file-chooser/sort-directories-first true

# applications > image viewer

gsettings set org.gnome.eog.ui sidebar false

xdg-mime default org.gnome.eog.desktop image/jpeg
xdg-mime default org.gnome.eog.desktop image/png

# applications > software

# gsettings set org.gnome.software download-updates false

# applications > terminal

UUID=$(gsettings get org.gnome.Terminal.ProfilesList default)
UUID=${UUID:1:-1}

dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/default-size-columns" 100
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/default-size-rows" 25

dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/font" "'Fira Code weight=450 12'" # Retina
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/use-system-font" false

dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/audible-bell" false

dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/use-theme-colors" false

# solarized
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/palette" "['rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)', 'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', 'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)', 'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', 'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', 'rgb(253,246,227)']"

# solarized dark
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/background-color" "'rgb(0,43,54)'"
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/foreground-color" "'rgb(131,148,150)'"

# solarized light
# dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/background-color" "'rgb(253,246,227)'"
# dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/foreground-color" "'rgb(101,123,131)'"

dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/scrollbar-policy" "'never'"

# applications > tweaks

gsettings set org.gnome.tweaks show-extensions-notice false

# power

if [[ $HOST = 'drifter' ]]; then

  gsettings set org.gnome.desktop.session idle-delay 300
  gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
  gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'

else
  gsettings set org.gnome.desktop.session idle-delay 600
fi

gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 25

gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 600

gsettings set org.gnome.SessionManager logout-prompt false

# displays

if [[ $HOST = 'drifter' ]]; then

  # depends on colord.service that is disabled when using custom color profiles 
  gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
  gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true

  gdbus call \
    --session \
    --dest org.gnome.SettingsDaemon.Power \
    --object-path /org/gnome/SettingsDaemon/Power \
    --method org.freedesktop.DBus.Properties.Set org.gnome.SettingsDaemon.Power.Screen Brightness '<int32 25>'

fi

# mouse and touchpad

[[ $XDG_SESSION_TYPE = 'wayland' ]] && gsettings set org.gnome.desktop.peripherals.mouse speed -0.75
[[ $XDG_SESSION_TYPE = 'x11' ]] && gsettings set org.gnome.desktop.peripherals.mouse speed -0.5

if [[ $HOST = 'drifter' ]]; then

  [[ $XDG_SESSION_TYPE = 'wayland' ]] && gsettings set org.gnome.desktop.peripherals.touchpad speed 0.25
  [[ $XDG_SESSION_TYPE = 'x11' ]] && gsettings set org.gnome.desktop.peripherals.touchpad speed 0.5

  gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

fi

# keyboard > input sources

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'pl')]"

# keyboard > keyboard shortcuts

DIR='/org/gnome/desktop/wm/keybindings'

for KEY in $(dconf list $DIR/)
  dconf reset $DIR/$KEY

# keyboard > keyboard shortcuts > navigation

dconf write $DIR/show-desktop "['<Super>d']"

dconf write $DIR/switch-applications '@as []'
dconf write $DIR/switch-applications-backward '@as []'

dconf write $DIR/cycle-windows "['<Alt>Tab']"
dconf write $DIR/cycle-windows-backward "['<Shift><Alt>Tab']"

dconf write $DIR/cycle-group "['<Alt>grave']"
dconf write $DIR/cycle-group-backward "['<Shift><Alt>grave']"

dconf write $DIR/switch-group '@as []'
dconf write $DIR/switch-group-backward '@as []'

dconf write $DIR/switch-to-workspace-1 "['<Control><Super>Home']"
dconf write $DIR/switch-to-workspace-left "['<Control><Super>Left']"
dconf write $DIR/switch-to-workspace-right "['<Control><Super>Right']"
dconf write $DIR/switch-to-workspace-last "['<Control><Super>End']"

dconf write $DIR/move-to-workspace-1 "['<Shift><Control><Super>Home']"
dconf write $DIR/move-to-workspace-left "['<Shift><Control><Super>Left']"
dconf write $DIR/move-to-workspace-right "['<Shift><Control><Super>Right']"
dconf write $DIR/move-to-workspace-last "['<Shift><Control><Super>End']"

# keyboard > keyboard shortcuts > screenshots

gsettings set org.gnome.shell.keybindings show-screenshot-ui '[]'

# keyboard > keyboard shortcuts > windows

dconf write $DIR/toggle-fullscreen "['<Alt>F11']"

dconf write $DIR/move-to-center "['<Super><Control>C']"

# keyboard > keyboard shortcuts > custom shortcuts

CUSTOM_KEYBINDINGS=()

add_shortcut() {
  local schema="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
  local dir="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$1/"

  gsettings set "$schema:$dir" 'binding' $2
  gsettings set "$schema:$dir" 'name' $3
  gsettings set "$schema:$dir" 'command' $4 

  CUSTOM_KEYBINDINGS+="'$dir'"
}

add_shortcut 0 'Print' 'flameshot' 'flameshot gui'
add_shortcut 1 '<Control><Super>a' 'audio output' "/home/$USER/code/arch/audio.zsh sink"
add_shortcut 2 '<Control><Super>m' 'audio input' "/home/$USER/code/arch/audio.zsh source"

[[ $HOST = 'player' || $HOST = 'worker' ]] && 
  add_shortcut 3 '<Control><Super>n' 'night light' 'pkill -USR1 redshift'
  
gsettings set \
  org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "[${(j., .)CUSTOM_KEYBINDINGS}]"

# region and language

gsettings set org.gnome.system.locale region 'pl_PL.UTF-8'

# accessibility

gsettings set org.gnome.desktop.interface cursor-size 32

# extensions

DIR=$XDG_DATA_HOME/gnome-shell/extensions

[[ -d $DIR ]] || mkdir -p $DIR
cp -r `dirname $0`/home/$USER/.local/share/gnome-shell/extensions/windows@grzegorzkozub.github.com $DIR
pushd $DIR/windows@grzegorzkozub.github.com && glib-compile-schemas schemas && popd

gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com', 'trayIconsReloaded@selfmade.pl', 'Hide_Activities@shay.shayel.org', 'windows@grzegorzkozub.github.com']"

# tweaks > appearance

gsettings set org.gnome.desktop.interface icon-theme 'Papirus'

# when kde-gtk-config is installed
# gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
# gsettings set org.gnome.desktop.sound theme-name 'freedesktop'
# gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'

gsettings set org.gnome.desktop.sound event-sounds false

# tweaks > fonts

# when kde-gtk-config is installed
# gsettings set org.gnome.desktop.interface font-name 'Cantarell 11'
# gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 11'
# gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 11'

gsettings set org.gnome.desktop.interface monospace-font-name 'Cascadia Code Regular 10'

gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'

if [[ $HOST = 'drifter' ]]; then
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
else
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.5
fi

# tweaks > windows

gsettings set org.gnome.mutter center-new-windows true

# dash

[[ $XDG_SESSION_TYPE = 'wayland' ]] && CODE='code-url-handler' || CODE='code'

gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'kitty.desktop', '$CODE.desktop', 'postman.desktop', 'brave-browser.desktop', 'org.keepassxc.KeePassXC.desktop', 'steam.desktop']" # 'slack-desktop'

gsettings set org.gnome.desktop.interface enable-hot-corners false

