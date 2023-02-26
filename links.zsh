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
  org.freedesktop.MalcontentControl \
  org.gnome.ColorProfileViewer \
  org.gnome.Terminal \
  qv4l2 \
  qvidcap \
  stoken-gui \
  stoken-gui-small \
  xcolor
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i '2iNoDisplay=true' ~/.local/share/applications/$APP.desktop
done

cp /usr/share/applications/lstopo.desktop ~/.local/share/applications
sed -i '4iNoDisplay=true' ~/.local/share/applications/lstopo.desktop

if [[ $HOST = 'player' || $HOST = 'worker' ]]; then

  for APP in \
    nvtop \
    redshift \
    redshift-gtk
  do
    cp /usr/share/applications/$APP.desktop ~/.local/share/applications
    sed -i '2iNoDisplay=true' ~/.local/share/applications/$APP.desktop
  done

fi

# qt

for APP in \
  org.keepassxc.KeePassXC
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i \
    -e 's/^Exec=/Exec=env QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough /' \
    ~/.local/share/applications/$APP.desktop
done

# alacritty

# if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then
#   APP=Alacritty
#   cp /usr/share/applications/$APP.desktop ~/.local/share/applications
#   sed -i \
#     -e's/^Exec=/Exec=env WAYLAND_DISPLAY= /' \
#     ~/.local/share/applications/$APP.desktop
# fi

# kitty

if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then
  APP=kitty
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i \
    -e 's/^Exec=/Exec=env KITTY_DISABLE_WAYLAND=1 /' \
    ~/.local/share/applications/$APP.desktop
fi

# nvim

APP=nvim
cp /usr/share/applications/$APP.desktop ~/.local/share/applications
sed -i \
  -e 's/^Exec=nvim %F$/Exec=kitty nvim %F/' \
  -e 's/^Terminal=true$/Terminal=false/' \
  ~/.local/share/applications/$APP.desktop
sed -i '2iNoDisplay=true' ~/.local/share/applications/$APP.desktop

# vscode

for APP in \
  code \
  code-url-handler
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i \
    -e 's/^Name=.*/Name=Code/' \
    ~/.local/share/applications/$APP.desktop
done

if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then

  [[ $(grep 'NoDisplay' ~/.local/share/applications/code.desktop) ]] ||
    sed -i \
      -e '/^Keywords=.*/a NoDisplay=true' \
      ~/.local/share/applications/code.desktop

  sed -i \
    -e '/^NoDisplay=.*/a NoDisplay=false' \
    ~/.local/share/applications/code-url-handler.desktop

fi

