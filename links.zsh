#!/usr/bin/env zsh

set -e -o verbose

# hidden apps

for APP in \
  avahi-discover \
  bssh \
  btop \
  bvnc \
  cmake-gui \
  htop \
  lstopo \
  mpv \
  nvtop \
  org.freedesktop.MalcontentControl \
  org.gnome.ColorProfileViewer \
  org.gnome.Terminal \
  qv4l2 \
  qvidcap \
  stoken-gui \
  stoken-gui-small \
  xcolor \
  yazi \
  zellij
do
  if [[ ! -f /usr/share/applications/$APP.desktop ]]; then
    rm -rf $XDG_DATA_HOME/applications/$APP.desktop || true
    continue
  fi
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
done

  # redshift redshift-gtk

rm -rf $XDG_DATA_HOME/applications/electron*.desktop || true

for LINK in `fd --glob 'electron*.desktop' /usr/share/applications --exec basename {}`; do
  cp /usr/share/applications/$LINK $XDG_DATA_HOME/applications
  sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$LINK
done

# alacritty

# cp /usr/share/applications/Alacritty.desktop $XDG_DATA_HOME/applications
# sed -i \
#   -e "s/^Exec=alacritty$/Exec=alacritty --option=font.size=$(~/code/dot/alacritty/alacritty/font.sh)/" \
#   $XDG_DATA_HOME/applications/Alacritty.desktop

# flameshot

# if [[ $HOST = 'worker' ]]; then
#
#   cp /usr/share/applications/org.flameshot.Flameshot.desktop $XDG_DATA_HOME/applications
#   sed -i -e "s/^Exec=/Exec=env QT_SCREEN_SCALE_FACTORS='1.5,1.5' /" $XDG_DATA_HOME/applications/org.flameshot.Flameshot.desktop
#
# fi

# foot

# for APP in \
#   foot \
#   foot-server \
#   footclient
# do
#   cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
#   sed -i '2iStartupWMClass=foot' $XDG_DATA_HOME/applications/$APP.desktop
# done

# for APP in \
#   foot-server \
#   footclient
# do
#   sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/$APP.desktop
# done

# sed -i \
#   -e "s/^Exec=foot$/Exec=foot --override=include=~\/.config\/foot\/$HOST.ini/" \
#   $XDG_DATA_HOME/applications/foot.desktop

# ghostty

if [[ $HOST = 'drifter' ]]; then

  cp /usr/share/applications/com.mitchellh.ghostty.desktop $XDG_DATA_HOME/applications
  sed -i \
    -e "s/^Exec=\/usr\/bin\/ghostty/Exec=\/usr\/bin\/ghostty --window-height=30 --window-width=120/" \
    $XDG_DATA_HOME/applications/com.mitchellh.ghostty.desktop

fi

# keepassxc

cp /usr/share/applications/org.keepassxc.KeePassXC.desktop $XDG_DATA_HOME/applications
sed -i \
  -e 's/^Exec=/Exec=env QT_QPA_PLATFORM=wayland /' \
  $XDG_DATA_HOME/applications/org.keepassxc.KeePassXC.desktop

# nvidia

if [[ $HOST =~ ^(player|worker)$ ]]; then

  [[ -d $XDG_DATA_HOME/nvidia-settings ]] || mkdir $XDG_DATA_HOME/nvidia-settings

  cp /usr/share/applications/nvidia-settings.desktop $XDG_DATA_HOME/applications
  sed -i \
    -e 's/^Name=.*$/Name=NVIDIA/' \
    -e "s/^Exec=.*$/Exec=\/usr\/bin\/nvidia-settings --config=\/home\/$USER\/.local\/share\/nvidia-settings\/nvidia-settings-rc/" \
    $XDG_DATA_HOME/applications/nvidia-settings.desktop

fi

# nvim

cp /usr/share/applications/nvim.desktop $XDG_DATA_HOME/applications
sed -i \
  -e "s/^Exec=nvim %F$/Exec=kitty nvim %F/" \
  -e 's/^Terminal=true$/Terminal=false/' \
  $XDG_DATA_HOME/applications/nvim.desktop
sed -i '2iNoDisplay=true' $XDG_DATA_HOME/applications/nvim.desktop

if [[ $HOST =~ ^(drifter|worker)$ ]]; then # work

  # postman

  if [[ $XDG_SESSION_TYPE = 'wayland' ]]; then

    cp /usr/share/applications/postman.desktop $XDG_DATA_HOME/applications
    sed -i \
      -e 's/\/opt\/postman\/Postman/\/opt\/postman\/Postman --ozone-platform-hint=auto/' \
      $XDG_DATA_HOME/applications/postman.desktop

  fi

  # teams

  cp /usr/share/applications/teams-for-linux.desktop $XDG_DATA_HOME/applications
  sed -i \
    -e 's/^Name=.*/Name=Teams/' \
    -e '/^Exec=/s/--gtk-version=3//' \
    -e '/^Exec=/s/teams-for-linux/teams-for-linux --ozone-platform-hint=auto/' \
    $XDG_DATA_HOME/applications/teams-for-linux.desktop

fi

# utilities

for APP in \
  org.gnome.Screenshot \
  org.gnome.tweaks
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i \
    -e '/^Categories=/s/Utility;//' \
    -e '/^Categories=/s/X-GNOME-Utilities;//' \
    $XDG_DATA_HOME/applications/$APP.desktop
done

# vscode

for APP in \
  code \
  code-url-handler
do
  cp /usr/share/applications/$APP.desktop $XDG_DATA_HOME/applications
  sed -i -e 's/^Name=.*/Name=Code/' $XDG_DATA_HOME/applications/$APP.desktop
done

