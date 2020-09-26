#!/usr/bin/env zsh

set -e -o verbose

# gnome

sudo pacman -S --needed --noconfirm \
  arc-gtk-theme \
  arc-icon-theme \
  arc-solid-gtk-theme \
  elementary-icon-theme \
  materia-gtk-theme \
  papirus-icon-theme

[[ -d ~/Pictures ]] || mkdir ~/Pictures
cp `dirname $0`/home/greg/Pictures/among-trees.png ~/Pictures

gsettings set org.gnome.desktop.background picture-uri 'file:///home/greg/Pictures/among-trees.png'
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///home/greg/Pictures/among-trees.png'

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'pl')]"
gsettings set org.gnome.system.locale region 'pl_PL.UTF-8'

gsettings set org.gnome.desktop.peripherals.mouse speed -0.5
if [[ $HOST = 'drifter' ]]; then
  gsettings set org.gnome.desktop.peripherals.touchpad speed 0.5
  gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
fi

gsettings set org.gnome.mutter center-new-windows true

gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true

gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'

gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

gsettings set org.gnome.Evince.Default show-sidebar false
gsettings set org.gnome.Evince.Default sizing-mode 'fit-width'

xdg-mime default org.gnome.Evince.desktop application/pdf

gsettings set org.gnome.eog.ui sidebar false

xdg-mime default org.gnome.eog.desktop image/jpeg
xdg-mime default org.gnome.eog.desktop image/png

[[ $HOST = 'drifter' ]] && gsettings set org.gnome.desktop.interface text-scaling-factor 1
[[ $HOST = 'turing' ]] && gsettings set org.gnome.desktop.interface text-scaling-factor 1.5

gsettings set org.gnome.desktop.interface gtk-theme 'Arc-solid'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
gsettings set org.gnome.shell.extensions.user-theme name 'Arc-Dark-solid'

gsettings set org.gnome.desktop.search-providers disabled "['org.gnome.Nautilus.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Software.desktop']"
gsettings set org.gnome.desktop.search-providers disable-external true

gsettings set org.gnome.desktop.notifications show-banners false
gsettings set org.gnome.desktop.notifications show-in-lock-screen false

dconf write /org/gtk/settings/file-chooser/show-hidden true
dconf write /org/gtk/settings/file-chooser/sort-directories-first true

dconf write /org/gnome/desktop/wm/keybindings/move-to-center "['<Super><Control>C']"

dconf write /org/gnome/desktop/wm/keybindings/move-to-side-e "['<Super><Control>Right']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-n "['<Super><Control>Up']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-s "['<Super><Control>Down']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-w "['<Super><Control>Left']"

dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['<Super>Tab']"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Alt>Tab']"

gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 1200

if [[ $HOST = 'drifter' ]]; then

  gdbus call \
    --session \
    --dest org.gnome.SettingsDaemon.Power \
    --object-path /org/gnome/SettingsDaemon/Power \
    --method org.freedesktop.DBus.Properties.Set org.gnome.SettingsDaemon.Power.Screen Brightness '<int32 50>'

fi

amixer sset Master 50%
amixer sset Capture 25%

gsettings set org.gnome.desktop.sound event-sounds false

gsettings set org.gnome.shell enabled-extensions "['dim-on-battery@nailfarmer.nailfarmer.com', 'tray-icons@zhangkaizhao.com', 'user-theme@gnome-shell-extensions.gcampax.github.com']"

gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'Alacritty.desktop', 'visual-studio-code.desktop', 'postman.desktop', 'chromium.desktop', 'google-chrome.desktop', 'slack.desktop', 'org.keepassxc.KeePassXC.desktop']"

for APP in \
  avahi-discover \
  bssh \
  bvnc \
  electron4 \
  electron7 \
  gvim \
  laptop-mode-tools \
  lstopo \
  nvim \
  org.freedesktop.MalcontentControl \
  org.gnome.Cheese \
  qv4l2 \
  qvidcap \
  stoken-gui \
  stoken-gui-small \
  unison \
  vim
do
  printf "[Desktop Entry]\nNoDisplay=true" > ~/.local/share/applications/$APP.desktop
done

