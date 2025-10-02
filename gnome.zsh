#!/usr/bin/env zsh

set -e -o verbose

# displays

gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true # depends on colord.service
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true

if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then

  # scale-monitor-framebuffer - fractional scaling
  # xwayland-native-scaling - https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3567

  [[ $HOST = 'drifter' ]] &&
    gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer', 'variable-refresh-rate']"

  [[ $HOST =~ ^(player|worker)$ ]] &&
    gsettings set org.gnome.mutter experimental-features "['variable-refresh-rate']"

fi

# power

if [[ $HOST = 'drifter' ]]; then

  gsettings set org.gnome.desktop.session idle-delay 300
  gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
  gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'

fi

[[ $HOST =~ ^(player|worker)$ ]] &&
  gsettings set org.gnome.desktop.session idle-delay 600

gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 25

gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 600

gsettings set org.gnome.SessionManager logout-prompt false

# multitasking > general

gsettings set org.gnome.desktop.interface enable-hot-corners false

# appearance

DIR=$XDG_DATA_HOME/backgrounds

[[ -e $DIR ]] && rm -rf $DIR
ln -s ~/code/walls $DIR

FILE="file:///home/$USER/.local/share/backgrounds/women.jpg"

gsettings set org.gnome.desktop.background picture-uri $FILE
gsettings set org.gnome.desktop.background picture-uri-dark $FILE

gsettings set org.gnome.desktop.screensaver picture-uri $FILE

# apps > amberol

gsettings set io.bassi.Amberol background-play false

# apps > brave

dconf write /org/gnome/settings-daemon/global-shortcuts/brave-browser/shortcuts \
  "[('choose_credential_fields', {'description': <'Choose Custom Login Fields'>}), ('fill_password', {'description': <'Fill Password Only'>}), ('fill_totp', {'description': <'Fill TOTP'>}), ('fill_username_password', {'description': <'Fill Username and Password'>}), ('redetect_fields', {'description': <'Redetect login fields'>}), ('reload_extension', {'description': <'Reload'>}), ('request_autotype', {'description': <'Request Global Auto-Type'>}), ('retrive_credentials_forced', {'description': <'Reopen database'>}), ('save_credentials', {'description': <'Save Credentials'>}), ('show_password_generator', {'description': <'Show Password Generator'>})]"

# apps > document viewer

# gsettings set org.gnome.Evince.Default show-sidebar false
# gsettings set org.gnome.Evince.Default sizing-mode 'fit-width'

# apps > extensions

gsettings set org.gnome.shell disable-extension-version-validation true

DIR=$XDG_DATA_HOME/gnome-shell/extensions
[[ -d $DIR ]] || mkdir -p $DIR

for NAME ('windows')
  cp -r `dirname $0`/home/$USER/.local/share/gnome-shell/extensions/$NAME@grzegorzkozub.github.com $DIR

pushd $DIR/windows@grzegorzkozub.github.com && glib-compile-schemas schemas && popd

# gsettings set org.gnome.shell enabled-extensions "[
#   $([[ $HOST != 'drifter' ]] && echo "'blur-my-shell@aunetx','rounded-window-corners@fxgn',")
#   'windows@grzegorzkozub.github.com'
# ]"

for NAME ('blur-my-shell@aunetx' 'rounded-window-corners@fxgn' 'windows@grzegorzkozub.github.com')
  gnome-extensions enable $NAME

  # 'appindicatorsupport@rgcjonas.gmail.com',
  # 'user-theme@gnome-shell-extensions.gcampax.github.com',

gsettings set org.gnome.shell.extensions.appindicator legacy-tray-enabled false

gsettings set org.gnome.shell.extensions.blur-my-shell.panel override-background-dynamically true

[[ $XDG_SESSION_TYPE = 'wayland' ]] && RADIUS=12 || RADIUS=16
gsettings set org.gnome.shell.extensions.rounded-window-corners-reborn global-rounded-corner-settings \
  "{'padding': <{'left': uint32 1, 'right': 1, 'top': 1, 'bottom': 1}>,
    'keepRoundedCorners': <{'maximized': false, 'fullscreen': false}>,
    'borderRadius': <uint32 $RADIUS>,
    'smoothing': <0.0>,
    'borderColor': <(0.5, 0.5, 0.5, 1.0)>,
    'enabled': <true>}"

# apps > files

gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

dconf write /org/gtk/settings/file-chooser/show-hidden true
dconf write /org/gtk/settings/file-chooser/sort-directories-first true

xdg-mime default org.gnome.Nautilus.desktop inode/directory

# apps > image viewer

xdg-mime default org.gnome.Loupe.desktop image/jpeg
xdg-mime default org.gnome.Loupe.desktop image/png

# apps > papers

gsettings set org.gnome.Papers.Default show-sidebar false

xdg-mime default org.gnome.Papers.desktop application/pdf

# apps > software

# gsettings set org.gnome.software download-updates false

# apps > terminal

UUID=$(gsettings get org.gnome.Terminal.ProfilesList default)
UUID=${UUID:1:-1}

dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/default-size-columns" 100
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/default-size-rows" 25

dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/font" "'Fira Code weight=450 12'" # Retina
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/use-system-font" false

dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/audible-bell" false

dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/use-theme-colors" false

# solarized
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/palette" "[
  'rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)', 'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', 'rgb(42,161,152)', 'rgb(238,232,213)',
  'rgb(0,43,54)', 'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', 'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', 'rgb(253,246,227)'
]"

# solarized dark
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/background-color" "'rgb(0,43,54)'"
dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/foreground-color" "'rgb(131,148,150)'"

# solarized light
# dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/background-color" "'rgb(253,246,227)'"
# dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/foreground-color" "'rgb(101,123,131)'"

dconf write "/org/gnome/terminal/legacy/profiles:/:$UUID/scrollbar-policy" "'never'"

# apps > tweaks

gsettings set org.gnome.tweaks show-extensions-notice false

# apps > tweaks > appearance

gsettings set org.gnome.desktop.interface icon-theme 'Papirus'

# when kde-gtk-config is installed
# gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
# gsettings set org.gnome.desktop.sound theme-name 'freedesktop'
# gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'

gsettings set org.gnome.desktop.sound event-sounds false

# apps > tweaks > fonts

# when kde-gtk-config is installed
# gsettings set org.gnome.desktop.interface font-name 'Cantarell 11'
# gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 11'
# gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 11'

gsettings set org.gnome.desktop.interface monospace-font-name 'Cascadia Code NF Regular 10'

gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'

# gsettings set org.gnome.desktop.interface text-scaling-factor 1

# apps > tweaks > windows

gsettings set org.gnome.mutter center-new-windows true

# notifications

gsettings set org.gnome.desktop.notifications show-banners false
gsettings set org.gnome.desktop.notifications show-in-lock-screen false

# search

gsettings set org.gnome.desktop.search-providers disabled "[
  'org.gnome.Nautilus.desktop',
  'org.gnome.Terminal.desktop',
  'org.gnome.Characters.desktop'
]"

gsettings set org.gnome.desktop.search-providers disable-external false

# digital wellbeing

gsettings set org.gnome.desktop.screen-time-limits history-enabled false

# mouse & touchpad

if [[ $HOST = 'drifter' ]]; then

  gsettings set org.gnome.desktop.peripherals.touchpad speed 0.25
  gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

fi

[[ $HOST =~ ^(player|worker)$ ]] &&
  gsettings set org.gnome.desktop.peripherals.mouse speed -0.75

# keyboard > input sources

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'pl')]"

# keyboard > keyboard shortcuts

dconf write /org/gnome/mutter/overlay-key "'Super_L'"

DIR='/org/gnome/desktop/wm/keybindings'

for KEY in $(dconf list $DIR/)
  dconf reset $DIR/$KEY

# keyboard > keyboard shortcuts > navigation

dconf write $DIR/show-desktop "['<Super>d']"

dconf write $DIR/switch-applications '@as []'
dconf write $DIR/switch-applications-backward '@as []'

dconf write $DIR/switch-windows "['<Super>Tab']"
dconf write $DIR/switch-windows-backward "['<Shift><Super>Tab']"

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

dconf write $DIR/always-on-top "['<Super>T']"

# keyboard > keyboard shortcuts > screenshots

gsettings set org.gnome.shell.keybindings show-screenshot-ui '[]'

# keyboard > keyboard shortcuts > system

gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>w']"

# keyboard > keyboard shortcuts > typing

dconf write $DIR/switch-input-source '@as []'
dconf write $DIR/switch-input-source-backward '@as []'

# keyboard > keyboard shortcuts > windows

dconf write $DIR/begin-move "['<Super>F7']"
dconf write $DIR/begin-resize "['<Super>F8']"

dconf write $DIR/toggle-fullscreen "['<Super>F11']"

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

add_shortcut 0 'Print' 'screenshot' "/home/$USER/code/arch/screenshot.zsh"
add_shortcut 1 '<Control>Print' 'screenshot delay' "/home/$USER/code/arch/screenshot.zsh delay"
add_shortcut 2 '<Control><Super>a' 'audio output' "/home/$USER/code/arch/audio.zsh sink"
add_shortcut 3 '<Control><Super>m' 'audio input' "/home/$USER/code/arch/audio.zsh source"

# [[ $HOST =~ ^(player|worker)$ ]] &&
#   add_shortcut 4 '<Control><Super>n' 'night light' 'pkill -USR1 redshift'

gsettings set \
  org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "[${(j., .)CUSTOM_KEYBINDINGS}]"

# accessibility > seeing

# gsettings set org.gnome.desktop.interface cursor-size 24

# privacy & security > file history & trash

# gsettings set org.gnome.desktop.privacy remember-recent-files false

FILE=$XDG_DATA_HOME/recently-used.xbel
[[ -f $FILE ]] && rm $FILE

# system > region & language

gsettings set org.gnome.system.locale region 'pl_PL.UTF-8'

# app picker

gsettings set org.gnome.shell app-picker-layout '[]'

# dash

set +e

gsettings set org.gnome.shell favorite-apps "[
  'org.gnome.Nautilus.desktop',
  'kitty.desktop',
  'com.mitchellh.ghostty.desktop',
  'code.desktop',
  'dev.zed.Zed.desktop',
  'brave-browser.desktop',
  $([[ $HOST =~ ^(drifter|worker)$ ]] && echo "'teams-for-linux.desktop',")
  'org.keepassxc.KeePassXC.desktop',
  'io.bassi.Amberol.desktop'
  $([[ $(sudo pacman -Qq steam 2> /dev/null) ]] && echo ",'steam.desktop'")
]"

  # 'org.gnome.Settings.desktop', 'Alacritty.desktop', 'org.codeberg.dnkl.foot.desktop', 'postman.desktop'

set -e

# file pickers

if [[ $HOST = 'drifter' ]]; then

  dconf write /org/gnome/nautilus/window-state/initial-size-file-chooser '(800, 504)'
  dconf write /org/gtk/settings/file-chooser/window-size '(800, 457)'

fi

if [[ $HOST =~ ^(player|worker)$ ]]; then

  dconf write /org/gnome/nautilus/window-state/initial-size-file-chooser '(720, 655)'
  dconf write /org/gtk/settings/file-chooser/window-size '(720, 608)'

fi

