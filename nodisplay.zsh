#!/usr/bin/env zsh

set -e -o verbose

# hidden links

for APP in \
  avahi-discover \
  bssh \
  btop \
  bvnc \
  cmake-gui \
  htop \
  java-java-openjdk \
  java-java21-openjdk \
  jconsole-java-openjdk \
  jconsole-java21-openjdk \
  jshell-java-openjdk \
  jshell-java21-openjdk \
  lstopo \
  mpv \
  nvtop \
  org.freedesktop.MalcontentControl \
  org.gnome.Terminal \
  qv4l2 \
  qvidcap \
  stoken-gui \
  stoken-gui-small \
  xcolor \
  yazi
do
  if [[ ! -f /usr/share/applications/$APP.desktop ]]; then
    rm -rf $XDG_DATA_HOME/applications/$APP.desktop || true
    continue
  fi
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

  # zellij

rm -rf $XDG_DATA_HOME/applications/electron*.desktop || true

for LINK in `fd --glob 'electron*.desktop' /usr/share/applications --exec basename {}`; do
  cp /usr/share/applications/$LINK $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$LINK
done

