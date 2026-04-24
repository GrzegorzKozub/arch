#!/usr/bin/env bash
set -eo pipefail -ux

# brave origin

for APP in \
  brave-origin-beta \
  com.brave.Origin.beta; do
  if [[ -f /usr/share/applications/$APP.desktop ]]; then
    cp /usr/share/applications/$APP.desktop "$XDG_DATA_HOME"/applications
    sed -i \
      -e 's/^Icon=brave-origin-beta$/Icon=brave-desktop/' \
      -e 's/^Name=.*$/Name=Brave Origin/' \
      "$XDG_DATA_HOME"/applications/$APP.desktop
  fi
done

# ghostty

if [[ $HOST == 'drifter' ]]; then

  cp /usr/share/applications/com.mitchellh.ghostty.desktop "$XDG_DATA_HOME"/applications
  sed -i \
    -e "s/^Exec=\/usr\/bin\/ghostty/Exec=\/usr\/bin\/ghostty --window-height=30 --window-width=120/" \
    -e "s/^DBusActivatable=true/DBusActivatable=false/" \
    "$XDG_DATA_HOME"/applications/com.mitchellh.ghostty.desktop

fi

# keepassxc

cp /usr/share/applications/org.keepassxc.KeePassXC.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e 's/^Exec=/Exec=env QT_QPA_PLATFORM=wayland /' \
  "$XDG_DATA_HOME"/applications/org.keepassxc.KeePassXC.desktop

# nvidia

if [[ $HOST =~ ^(player|worker)$ ]]; then

  [[ -d $XDG_DATA_HOME/nvidia-settings ]] || mkdir "$XDG_DATA_HOME"/nvidia-settings

  cp /usr/share/applications/nvidia-settings.desktop "$XDG_DATA_HOME"/applications
  sed -i \
    -e 's/^Name=.*$/Name=NVIDIA/' \
    -e "s/^Exec=.*$/Exec=\/usr\/bin\/nvidia-settings --config=\/home\/$USER\/.local\/share\/nvidia-settings\/nvidia-settings-rc/" \
    "$XDG_DATA_HOME"/applications/nvidia-settings.desktop

fi

# nvim

cp /usr/share/applications/org.neovim.nvim.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e "s/^Exec=nvim %F$/Exec=kitty nvim %F/" \
  -e 's/^Terminal=true$/Terminal=false/' \
  "$XDG_DATA_HOME"/applications/org.neovim.nvim.desktop
sed -i '2iNoDisplay=true' "$XDG_DATA_HOME"/applications/org.neovim.nvim.desktop

# tweaks

cp /usr/share/applications/org.gnome.tweaks.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e '/^Categories=/s/Utility;//' \
  -e '/^Categories=/s/X-GNOME-Utilities;//' \
  "$XDG_DATA_HOME"/applications/org.gnome.tweaks.desktop

# tidal

cp /usr/share/applications/tidal-hifi.desktop "$XDG_DATA_HOME"/applications
sed -i \
  -e 's/^Exec=.*$/Exec=tidal-hifi --disable-seccomp-filter-sandbox %U/' \
  -e 's/^Name=.*$/Name=TIDAL/' \
  "$XDG_DATA_HOME"/applications/tidal-hifi.desktop

  # https://github.com/Mastermindzh/tidal-hifi/blob/master/docs/known-issues.md#white-screen-on-loginlaunch

# vscode

for APP in \
  code \
  code-url-handler; do
  cp /usr/share/applications/$APP.desktop "$XDG_DATA_HOME"/applications
  sed -i -e 's/^Name=.*/Name=Code/' "$XDG_DATA_HOME"/applications/$APP.desktop
done

# hidden links

"${BASH_SOURCE%/*}"/nodisplay.sh
