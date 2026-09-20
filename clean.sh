#!/usr/bin/env bash
set -eo pipefail -ux

# TODO: these were last removed in september 2026; check if any reappeared

# rm -rf "$XDG_CACHE_HOME"/{appstream,cmp,fsh}/
# rm -rf "$XDG_CONFIG_HOME"/{fsh,github-copilot}/
# rm -rf "$XDG_DATA_HOME"/man/
# rm -rf "$XDG_STATE_HOME"/{.copilot,pipewire}/

# bluetooth

rm -rf "$XDG_CACHE_HOME"/obexd/

# electron

rm -rf "$XDG_CACHE_HOME"/electron/
rm -rf "$XDG_CONFIG_HOME"/Electron/

# gnome

rm -rf ~/.gnome/

rm -rf "$XDG_CACHE_HOME"/{gnome-calculator,gnome-desktop-thumbnailer,thumbnails}/

rm -rf "$XDG_CONFIG_HOME"/{gnome-control-center,gnome-session,nautilus}

rm -f "$XDG_DATA_HOME"/gnome-shell/{application_state,gnome-overrides-migrated,update-check-*}
rm -rf "$XDG_DATA_HOME"/nautilus/
rm -f "$XDG_DATA_HOME"/recently-used.xbel

if [[ ${1:-} == 'deep' ]]; then

  rm -rf "$XDG_CACHE_HOME"/{evolution,glycin,gstreamer-1.0,libgetweather,tracker3}
  rm -f "$XDG_CACHE_HOME"/event-sound-cache*

  rm -rf "$XDG_CONFIG_HOME"/{evolution,goa-1.0}
  rm -f "$XDG_CONFIG_HOME"/.gsd-keyboard.settings-ported

  rm -rf "$XDG_DATA_HOME"/{evolution,gnome-settings-daemon,gvfs-metadata,sounds}
  rm -f "$XDG_DATA_HOME"/gnome-shell/session.gvdb

  rm -f "$XDG_STATE_HOME"/gnome-session@gnome.state

fi

# gtk

rm -rf "$XDG_CACHE_HOME"/gtk-4.0/
rm -rf "$XDG_CONFIG_HOME"/gtk-4.0/

# ibus

if [[ ${1:-} == 'deep' ]]; then
  rm -rf "$XDG_CACHE_HOME"/ibus/
  rm -rf "$XDG_CONFIG_HOME"/ibus/
fi

# lact

if [[ ${1:-} == 'deep' ]]; then
  rm -rf "$XDG_CONFIG_HOME"/lact/
fi

# mesa

rm -rf "$XDG_CACHE_HOME"/{mesa_shader_cache,mesa_shader_cache_db}/

# mime

rm -f "$XDG_DATA_HOME"/mimeapps.list

# nvidia

rm -rf ~/.nv/
rm -f ~/.nvidia-settings-rc
rm -rf "$XDG_CACHE_HOME"/{nv,nvidia}/
rm -rf "$XDG_DATA_HOME"/nvidia-settings/

# qt

rm -rf "$XDG_CONFIG_HOME"/QtProject.conf/

# pulseaudio

if [[ ${1:-} == 'deep' ]]; then
  rm -rf "$XDG_CONFIG_HOME"/pulse/
fi

# xdg

rm -rf "$XDG_CONFIG_HOME"/autostart/

# dot

~/code/dot/clean.sh "$@"
