#!/usr/bin/env zsh

set -e -o verbose

# software

# gsettings set org.gnome.software download-updates false

# keyboard

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'pl')]"
gsettings set org.gnome.system.locale region 'pl_PL.UTF-8'

dconf write /org/gnome/desktop/wm/keybindings/move-to-center "['<Super><Control>C']"

dconf write /org/gnome/desktop/wm/keybindings/move-to-side-e "['<Super><Control>Right']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-n "['<Super><Control>Up']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-s "['<Super><Control>Down']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-w "['<Super><Control>Left']"

dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['<Super>Tab']"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Alt>Tab']"

# shortcuts

gsettings set org.gnome.shell.keybindings show-screenshot-ui '[]'

CUSTOM_KEYBINDINGS=()

gsettings set \
  org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
  name 'flameshot'

gsettings set \
  org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
  command 'flameshot gui'

gsettings set \
  org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
  binding 'Print'

CUSTOM_KEYBINDINGS+="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/'"

gsettings set \
  org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ \
  name 'audio output'

gsettings set \
  org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ \
  command '/home/greg/code/arch/audio.zsh sink'

gsettings set \
  org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ \
  binding '<Control><Super>a'

CUSTOM_KEYBINDINGS+="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/'"

gsettings set \
  org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ \
  name 'audio input'

gsettings set \
  org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ \
  command '/home/greg/code/arch/audio.zsh source'

gsettings set \
  org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ \
  binding '<Control><Super>m'

CUSTOM_KEYBINDINGS+="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/'"

if [[ $HOST = 'player' || $HOST = 'worker' ]]; then

  gsettings set \
    org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ \
    name 'night light'

  gsettings set \
    org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ \
    command 'pkill -USR1 redshift'

  gsettings set \
    org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ \
    binding '<Control><Super>n'

  CUSTOM_KEYBINDINGS+="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/'"

fi
  
gsettings set \
  org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "[${(j., .)CUSTOM_KEYBINDINGS}]"

# mouse and touchpad

[[ $XDG_SESSION_TYPE = 'wayland' ]] && gsettings set org.gnome.desktop.peripherals.mouse speed -0.75
[[ $XDG_SESSION_TYPE = 'x11' ]] && gsettings set org.gnome.desktop.peripherals.mouse speed -0.5

if [[ $HOST = 'drifter' ]]; then

  [[ $XDG_SESSION_TYPE = 'wayland' ]] && gsettings set org.gnome.desktop.peripherals.touchpad speed 0.25
  [[ $XDG_SESSION_TYPE = 'x11' ]] && gsettings set org.gnome.desktop.peripherals.touchpad speed 0.5

  gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

fi

# screen

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

# sound

gsettings set org.gnome.desktop.sound event-sounds false

# when kde-gtk-config is installed
# gsettings set org.gnome.desktop.sound theme-name 'freedesktop'

# power

gsettings set org.gnome.SessionManager logout-prompt false

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

# themes

gsettings set org.gnome.desktop.interface icon-theme 'Papirus'

# when kde-gtk-config is installed
# gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
# gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'

# wallpapers

[[ -d ${XDG_DATA_HOME:-~/.local/share}/backgrounds ]] || mkdir ${XDG_DATA_HOME:-~/.local/share}/backgrounds
cp `dirname $0`/home/$USER/.local/share/backgrounds/* ${XDG_DATA_HOME:-~/.local/share}/backgrounds

gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/.local/share/backgrounds/women.jpg"
gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/$USER/.local/share/backgrounds/women.jpg"

gsettings set org.gnome.desktop.screensaver picture-uri "file:///home/$USER/.local/share/backgrounds/women.jpg"

# fonts

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

# shell

gsettings set org.gnome.mutter center-new-windows true

gsettings set org.gnome.desktop.search-providers disabled "['org.gnome.Nautilus.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Software.desktop']"
gsettings set org.gnome.desktop.search-providers disable-external true

gsettings set org.gnome.desktop.notifications show-banners false
gsettings set org.gnome.desktop.notifications show-in-lock-screen false

[[ $XDG_SESSION_TYPE = 'wayland' ]] && CODE=code-url-handler || CODE=code

gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'kitty.desktop', '$CODE.desktop', 'postman.desktop', 'brave-browser.desktop', 'org.keepassxc.KeePassXC.desktop', 'steam.desktop']" # 'slack-desktop'

gsettings set org.gnome.desktop.interface enable-hot-corners false

# extensions

EXT=${XDG_DATA_HOME:-~/.local/share}/gnome-shell/extensions
[[ -d $EXT ]] || mkdir -p $EXT

cp -r `dirname $0`/home/greg/.local/share/gnome-shell/extensions/windows@grzegorzkozub.github.com $EXT
pushd $EXT/windows@grzegorzkozub.github.com && glib-compile-schemas schemas && popd

gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com', 'trayIconsReloaded@selfmade.pl', 'Hide_Activities@shay.shayel.org', 'windows@grzegorzkozub.github.com']"

# terminal

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

# nautilus

gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

dconf write /org/gtk/settings/file-chooser/show-hidden true
dconf write /org/gtk/settings/file-chooser/sort-directories-first true

# eog

gsettings set org.gnome.eog.ui sidebar false

xdg-mime default org.gnome.eog.desktop image/jpeg
xdg-mime default org.gnome.eog.desktop image/png

# evince

gsettings set org.gnome.Evince.Default show-sidebar false
gsettings set org.gnome.Evince.Default sizing-mode 'fit-width'

xdg-mime default org.gnome.Evince.desktop application/pdf

