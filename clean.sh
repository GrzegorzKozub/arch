#!/usr/bin/env bash
set -eo pipefail -ux

# bash

rm -f ~/.{bash_history,bash_logout,bash_profile,bashrc}

# bluetooth

rm -rf "$XDG_CACHE_HOME"/obexd/

# claude

rm -rf "$XDG_CACHE_HOME"/claude-cli-nodejs/
rm -rf "$XDG_CONFIG_HOME"/anthropic/

# electron

rm -rf "$XDG_CACHE_HOME"/electron/
rm -rf "$XDG_CONFIG_HOME"/Electron/

# fontconfig

rm -rf "$XDG_CACHE_HOME"/fontconfig/
rm -rf "$XDG_CONFIG_HOME"/fontconfig/

# github

rm -rf "$XDG_CACHE_HOME"/gh/

# gnome

# TODO recreated on login: all evolution, glycin, gstreamer-1.0, libgetweather, tracker3, goa-1.0, gsd-keyboard..., input-sources..., session.vdb, update-check-LATEST, gvfs-metadata, sounds (so leave autostart as well?), session in state dir
# application_state to gnome.sh?

rm -rf ~/.gnome/

rm -rf "$XDG_CACHE_HOME"/{evolution,glycin,gnome-calculator,gnome-desktop-thumbnailer,libgweather,thumbnails,tracker3}/
rm -f "$XDG_CACHE_HOME"/event-sound-cache*

rm -rf "$XDG_CONFIG_HOME"/{evolution,gnome-control-center,gnome-session,goa-1.0,nautilus}

rm -f "$XDG_CONFIG_HOME"/.gsd-keyboard.settings-ported

rm -rf "$XDG_DATA_HOME"/{evolution,gnome-settings-daemon,gvfs-metadata,nautilus,sounds}/
rm -f "$XDG_DATA_HOME"/gnome-shell/{application_state,session.gvdb,update-check-*}
rm -f "$XDG_DATA_HOME"/recently-used.xbel

rm -f "$XDG_STATE_HOME"/gnome-session@gnome.state

# go

rm -rf "$XDG_CACHE_HOME"/{goimports,gopls}/

# gopass

rm -rf "$XDG_CACHE_HOME"/gopass/

# gstreamer

# rm -rf "$XDG_CACHE_HOME"/gstreamer-1.0/

# gtk

rm -rf "$XDG_CACHE_HOME"/gtk-4.0/

# ime

# rm -rf "$XDG_CACHE_HOME"/ibus/

# lact

rm -rf "$XDG_CONFIG_HOME"/lact/

# linecast

rm -rf "$XDG_CACHE_HOME"/linecast/

# node

rm -f ~/.yarnrc
rm -rf ~/.{npm,yarn}/
rm -rf "$XDG_CACHE_HOME"/{js-v8flags,node,node-gyp,yarn}/

# nvidia

rm -f ~/.nvidia-settings-rc
rm -rf ~/.nv/

rm -rf "$XDG_CACHE_HOME"/{mesa_shader_cache,mesa_shader_cache_db,nv,nvidia}/

rm -rf "$XDG_DATA_HOME"/nvidia-settings/

# nvim

rm -rf "$XDG_CACHE_HOME"/{luarocks,nvim,tree-sitter}/

# qt

rm -rf "$XDG_CONFIG_HOME"/QtProject.conf/

# pulseaudio

# rm -rf "$XDG_CONFIG_HOME"/pulse/

# tensaku

rm -rf "$XDG_CACHE_HOME"/tensaku/

# vscode

rm -rf "$XDG_CONFIG_HOME"/copilot/

# wget

rm -f ~/.wget-hsts

# wireplumber

rm -rf "$XDG_STATE_HOME"/wireplumber/

# xdg

rm -rf "$XDG_CONFIG_HOME"/autostart/

# zed

rm -rf "$XDG_CACHE_HOME"/zed/

# zsh

rm -f ~/.zshrc
# rm -rf "$XDG_CACHE_HOME"/gitstatus/ # powerlevel10k

# root

sudo find /root -mindepth 1 -delete
