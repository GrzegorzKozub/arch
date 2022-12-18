#!/usr/bin/env zsh

set -e -o verbose

# hidden apps

for APP in \
  avahi-discover \
  bssh \
  bvnc \
  btop \
  cmake-gui \
  electron4 \
  electron7 \
  gvim \
  htop \
  lf \
  lstopo \
  mpv \
  nvtop \
  org.freedesktop.MalcontentControl \
  org.gnome.Cheese \
  org.gnome.Software \
  org.gnome.Terminal \
  org.gtk.Demo4 \
  org.gtk.IconBrowser4 \
  org.gtk.PrintEditor4 \
  org.gtk.WidgetFactory4 \
  qv4l2 \
  qvidcap \
  stoken-gui \
  stoken-gui-small \
  unison \
  vim \
  xcolor
do
  printf "[Desktop Entry]\nNoDisplay=true" > ~/.local/share/applications/$APP.desktop
done

# qt

for APP in \
  org.keepassxc.KeePassXC
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i 's/^Exec=/Exec=env QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough /' \
    ~/.local/share/applications/$APP.desktop
done

# nvim

for APP in \
  nvim
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i \
    -e 's/^Exec=nvim %F$/Exec=alacritty --command nvim %F/' \
    -e 's/^Terminal=true$/Terminal=false/' \
    ~/.local/share/applications/$APP.desktop
  echo 'NoDisplay=true' >> ~/.local/share/applications/$APP.desktop
done

# vscode

for APP in \
  code \
  code-url-handler
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i 's/^Name=.*/Name=Code/' \
    ~/.local/share/applications/$APP.desktop
done

if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then

  [[ $(grep 'NoDisplay' ~/.local/share/applications/code.desktop) ]] ||
    sed -i -e '/^Keywords=.*/a NoDisplay=true' ~/.local/share/applications/code.desktop

  sed -i -e '/^NoDisplay=.*/a NoDisplay=false' ~/.local/share/applications/code-url-handler.desktop

fi

