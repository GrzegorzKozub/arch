set -e -o verbose

# gnome

if [ ! -d ~/Pictures ]; then mkdir ~/Pictures; fi
cp `dirname $0`/home/greg/Pictures/Among\ Trees.png ~/Pictures

gsettings set org.gnome.desktop.background picture-uri 'file:///home/greg/Pictures/Among%20Trees.png'
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///home/greg/Pictures/Among%20Trees.png'

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'pl')]"
gsettings set org.gnome.system.locale region "pl_PL.UTF-8"

gsettings set org.gnome.desktop.interface text-scaling-factor 1.25

gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.mouse speed -0.5

gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true

gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'

gsettings set org.gnome.nautilus.preferences default-folder-viewer "list-view"

dconf write /org/gtk/settings/file-chooser/show-hidden true
dconf write /org/gtk/settings/file-chooser/sort-directories-first true

dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['<Super>Tab']"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Alt>Tab']"

gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.freedesktop.DBus.Properties.Set org.gnome.SettingsDaemon.Power.Screen Brightness "<int32 50>"

amixer sset Master 50%
amixer sset Capture 50%

# no ui equivalent
# gsettings set org.gnome.desktop.sound event-sounds false

# blurry
# gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'visual-studio-code.desktop', 'postman.desktop', 'chromium.desktop', 'slack.desktop', 'org.keepassxc.KeePassXC.desktop']"

for APP in \
  avahi-discover \
  bssh \
  bvnc \
  electron4 \
  gvim \
  laptop-mode-tools \
  org.gnome.Cheese \
  qv4l2 \
  qvidcap \
  stoken-gui \
  stoken-gui-small \
  vim
do
  printf "[Desktop Entry]\nNoDisplay=true" > ~/.local/share/applications/$APP.desktop
done

