#!/usr/bin/env zsh

set -e -o verbose

# links

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
  vim
do
  printf "[Desktop Entry]\nNoDisplay=true" > ~/.local/share/applications/$APP.desktop
done

for APP in \
  org.keepassxc.KeePassXC
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i 's/^Exec=/Exec=env QT_SCALE_FACTOR_ROUNDING_POLICY=PassThrough /' \
    ~/.local/share/applications/$APP.desktop
done

for APP in \
  Alacritty
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i 's/^Exec=/Exec=env WAYLAND_DISPLAY= /' \
    ~/.local/share/applications/$APP.desktop
done

for APP in \
  nvim
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i \
    -e 's/^Exec=nvim %F$/Exec=env WAYLAND_DISPLAY= alacritty --command nvim %F/' \
    -e 's/^Terminal=true$/Terminal=false/' \
    ~/.local/share/applications/$APP.desktop
  echo 'NoDisplay=true' >> ~/.local/share/applications/$APP.desktop
done

