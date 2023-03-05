#!/usr/bin/env zsh

set -e -o verbose

# config

USR=/usr/share/applications
LOCAL=${XDG_DATA_HOME:-~/.local/share}/applications

# hidden apps

for APP in \
  avahi-discover \
  bssh \
  btop \
  bvnc \
  htop \
  lf \
  mpv \
  org.freedesktop.MalcontentControl \
  org.gnome.ColorProfileViewer \
  org.gnome.Terminal \
  qv4l2 \
  qvidcap \
  stoken-gui \
  stoken-gui-small \
  xcolor
do
  cp $USR/$APP.desktop $LOCAL
  sed -i '2iNoDisplay=true' $LOCAL/$APP.desktop
done

APP=lstopo.desktop

cp $USR/$APP $LOCAL
sed -i '4iNoDisplay=true' $LOCAL/$APP

if [[ $HOST = 'player' || $HOST = 'worker' ]]; then

  for APP in \
    nvtop \
    redshift \
    redshift-gtk
  do
    cp $USR/$APP.desktop $LOCAL
    sed -i '2iNoDisplay=true' $LOCAL/$APP.desktop
  done

fi

# qt

for APP in \
  org.keepassxc.KeePassXC
do
  cp $USR/$APP.desktop $LOCAL
  sed -i -e 's/^Exec=/Exec=env QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough /' $LOCAL/$APP.desktop
done

# alacritty

# if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then
#   APP=Alacritty.desktop
#   cp $USR/$APP $LOCAL
#   sed -i -e's/^Exec=/Exec=env WAYLAND_DISPLAY= /' $LOCAL/$APP
# fi

# kitty

if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then

  APP=kitty.desktop

  cp $USR/$APP $LOCAL
  sed -i -e 's/^Exec=/Exec=env KITTY_DISABLE_WAYLAND=1 /' $LOCAL/$APP

fi

# nvim

APP=nvim.desktop

cp $USR/$APP $LOCAL
sed -i \
  -e 's/^Exec=nvim %F$/Exec=kitty nvim %F/' \
  -e 's/^Terminal=true$/Terminal=false/' \
  $LOCAL/$APP
sed -i '2iNoDisplay=true' $LOCAL/$APP

# vscode

for APP in \
  code \
  code-url-handler
do
  cp $USR/$APP.desktop $LOCAL
  sed -i -e 's/^Name=.*/Name=Code/' $LOCAL/$APP.desktop
done

if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then
  sed -i '2iNoDisplay=true' $LOCAL/code.desktop
  sed -i -e 's/^NoDisplay=true$/NoDisplay=false/' $LOCAL/code-url-handler.desktop
fi

