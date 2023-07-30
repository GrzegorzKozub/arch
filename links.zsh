#!/usr/bin/env zsh

set -e -o verbose

# hidden apps

for APP in \
  avahi-discover \
  bssh \
  btop \
  bvnc \
  htop \
  lf \
  mpv \
  nvtop \
  org.freedesktop.MalcontentControl \
  org.gnome.ColorProfileViewer \
  org.gnome.Terminal \
  qv4l2 \
  qvidcap \
  redshift \
  redshift-gtk \
  stoken-gui \
  stoken-gui-small \
  xcolor
do
  [[ ! -f /usr/share/applications/$APP.desktop ]] && continue
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

cp /usr/share/applications/lstopo.desktop $XDG_DATA_HOME/applications
sed -i '4iNoDisplay=true' $XDG_DATA_HOME/applications/lstopo.desktop

# alacritty

# if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then
#
#   cp /usr/share/applications/Alacritty.desktop $XDG_DATA_HOME/applications
#
#   # xwayland
#   sed -i -e 's/^Exec=/Exec=env WAYLAND_DISPLAY= /' $XDG_DATA_HOME/applications/Alacritty.desktop
#
# fi

# flameshot

# if [[ $HOST = 'worker' ]]; then
#
#   cp /usr/share/applications/org.flameshot.Flameshot.desktop $XDG_DATA_HOME/applications
#   sed -i -e "s/^Exec=/Exec=env QT_SCREEN_SCALE_FACTORS='1.5,1.5' /" $XDG_DATA_HOME/applications/org.flameshot.Flameshot.desktop
#
# fi

# foot

if [[ $HOST = 'drifter' || $HOST = 'worker' ]]; then

  for APP in \
    org.codeberg.dnkl.foot-server \
    org.codeberg.dnkl.foot \
    org.codeberg.dnkl.footclient
  do
    cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
    sed -i '2iStartupWMClass=foot' $XDG_DATA_HOME/applications/$APP.desktop
  done

  for APP in \
    org.codeberg.dnkl.foot-server \
    org.codeberg.dnkl.footclient
  do
    sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
  done

  sed -i \
    -e "s/^Exec=foot$/Exec=foot --override=include=~\/.config\/foot\/$HOST.ini/" \
    $XDG_DATA_HOME/applications/org.codeberg.dnkl.foot.desktop
fi

# keepassxc

cp /usr/share/applications/org.keepassxc.KeePassXC.desktop $XDG_DATA_HOME/applications

# if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then
#
#   # native wayland
#   sed -i \
#     -e 's/^Exec=/Exec=env QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough QT_QPA_PLATFORM=wayland /' \
#     $XDG_DATA_HOME/applications/org.keepassxc.KeePassXC.desktop
#
# else

sed -i \
  -e 's/^Exec=/Exec=env QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough /' \
  $XDG_DATA_HOME/applications/org.keepassxc.KeePassXC.desktop

# fi

# kitty
#
# if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then
#
#   cp /usr/share/applications/kitty.desktop $XDG_DATA_HOME/applications
#
#   # xwayland
#   sed -i -e 's/^Exec=/Exec=env KITTY_DISABLE_WAYLAND=1 /' $XDG_DATA_HOME/applications/kitty.desktop
#
# fi

# nvidia

if [[ $HOST = 'player' ]]; then

  [[ -d $XDG_DATA_HOME/nvidia-settings ]] || mkdir $XDG_DATA_HOME/nvidia-settings

  cp /usr/share/applications/nvidia-settings.desktop $XDG_DATA_HOME/applications
  sed -i \
    -e 's/^Name=.*$/Name=NVIDIA/' \
    -e "s/^Exec=.*$/Exec=\/usr\/bin\/nvidia-settings --config=\/home\/$USER\/.local\/share\/nvidia-settings\/nvidia-settings-rc/" \
    $XDG_DATA_HOME/applications/nvidia-settings.desktop

fi

# nvim

[[ $XDG_SESSION_TYPE = 'wayland' ]] && TERMINAL='foot' || TERMINAL='kitty'

cp /usr/share/applications/nvim.desktop $XDG_DATA_HOME/applications
sed -i \
  -e "s/^Exec=nvim %F$/Exec=$TERMINAL nvim %F/" \
  -e 's/^Terminal=true$/Terminal=false/' \
  $XDG_DATA_HOME/applications/nvim.desktop
sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/nvim.desktop

# vscode

for APP in \
  code \
  code-url-handler
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i -e 's/^Name=.*/Name=Code/' $XDG_DATA_HOME/applications/$APP.desktop
done

if [[ $HOST = 'drifter' ]]; then

  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/code.desktop
  sed -i -e 's/^NoDisplay=true$/NoDisplay=false/' $XDG_DATA_HOME/applications/code-url-handler.desktop

fi

