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

rm -rf ~/.gnome/

rm -rf "$XDG_CACHE_HOME"/{evolution,glycin,gnome-calculator,gnome-desktop-thumbnailer,libgweather,thumbnails,tracker3}/
rm -f "$XDG_CACHE_HOME"/event-sound-cache*

rm -rf "$XDG_CONFIG_HOME"/{evolution,gnome-control-center,gnome-session,goa-1.0,nautilus}

rm -f "$XDG_CONFIG_HOME"/.gsd-keyboard.settings-ported

rm -rf "$XDG_DATA_HOME"/sounds/
rm -f "$XDG_DATA_HOME"/recently-used.xbel

# go

rm -rf "$XDG_CACHE_HOME"/{goimports,gopls}/

# gopass

rm -rf "$XDG_CACHE_HOME"/gopass/

# gstreamer

rm -rf "$XDG_CACHE_HOME"/gstreamer-1.0/

# gtk

rm -rf "$XDG_CACHE_HOME"/gtk-4.0/

# ime

rm -rf "$XDG_CACHE_HOME"/ibus/

# lact

rm -rf "$XDG_CONFIG_HOME"/lact/

# linecast

rm -rf "$XDG_CACHE_HOME"/linecast/

# mime

rm -f "$XDG_DATA_HOME"/mimeapps.list

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

rm -rf "$XDG_CACHE_HOME"/{luarocks,nvim}/

# qt

rm -rf "$XDG_CONFIG_HOME"/QtProject.conf/

# ps & top

rm -rf "$XDG_CONFIG_HOME"/procps/

# pulseaudio

rm -rf "$XDG_CONFIG_HOME"/pulse/

# tensaku

rm -rf "$XDG_CACHE_HOME"/tensaku/

# tree-sitter

rm -rf "$XDG_CACHE_HOME"/tree-sitter/

# vim

rm -f ~/.viminfo

# vscode

rm -rf "$XDG_CONFIG_HOME"/copilot/

# wget

rm -f ~/.wget-hsts

# xdg

rm -rf "$XDG_CONFIG_HOME"/autostart/

# zed

rm -rf "$XDG_CACHE_HOME"/zed/

# zsh

rm -f ~/.zshrc
rm -rf "$XDG_CONFIG_HOME"/fsh/
# rm -rf "$XDG_CACHE_HOME"/gitstatus/ # powerlevel10k

# root

sudo find /root -mindepth 1 -delete
