#!/usr/bin/env zsh

set -o verbose

# paru

sudo pacman -Rs --noconfirm \
  paru paru-debug

sudo pacman -Syu --noconfirm

CARGO_HOME=

[[ -d ~/paru-git ]] && rm -rf ~/paru-git

pushd ~

git clone https://aur.archlinux.org/paru-git.git
cd paru-git
makepkg -si --noconfirm

popd

rm -rf ~/paru-git
rm -rf ~/.cargo

sudo pacman -Rs --noconfirm \
  rust

# gnome

sudo pacman -S --noconfirm \
  gnome-remote-desktop

gsettings set org.gnome.shell disable-extension-version-validation true

# lf

paru -Rs --noconfirm \
  lf

rm -rf ~/.local/share/applications/lf.desktop
rm -rf ~/.local/share/lf
rm -rf ~/.config/lf

# mdcat

sudo pacman -S --noconfirm \
  mdcat

# nvim

rm -rf ~/.cache/nvim

# obsidian & satty

paru -Rs --noconfirm \
  satty-bin obsidian-bin

sudo pacman -S --noconfirm \
  obsidian satty

# vscode

for EXTENSION in \
  bierner.markdown-mermaid
do
  code --install-extension $EXTENSION --force
done

# yazi

sudo pacman -Rs --noconfirm \
  ffmpegthumbnailer

FILE=$XDG_CONFIG_HOME/yazi/package.toml
[[ -f $FILE ]] && rm -f $FILE

for PLUGIN in \
  KKV9/compress \
  Tyarel8/video-ffmpeg \
  yazi-rs/plugins:git \
  yazi-rs/plugins:jump-to-char
do
  ya pack --add "$PLUGIN"
done

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

