#!/usr/bin/env zsh

set -e -o verbose

# validation

[[ . = `dirname $0` ]] && exit 1

# pacman refresh

# sudo pacman --noconfirm -Sy archlinux-keyring
sudo pacman --noconfirm -Sy

# git and openssh

sudo pacman -S --noconfirm \
  git git-lfs \
  openssh

paru -S --aur --noconfirm \
  git-extras \
  gitflow-avh \
  gitflow-zshcompletion-avh

# dotfiles init

sudo pacman -S --noconfirm \
  stow

. `dirname $0`/dotfiles.zsh

. ~/code/dotfiles/init.zsh
. ~/code/keys/init.zsh

# fonts

sudo pacman -S --noconfirm \
  gnu-free-fonts \
  noto-fonts \
  noto-fonts-emoji \
  ttf-dejavu \
  ttf-fira-code \
  ttf-liberation

# themes

sudo pacman -S --needed --noconfirm \
  papirus-icon-theme

# gnome

. `dirname $0`/gdm.zsh
. `dirname $0`/gnome.zsh
# . `dirname $0`/terminal.zsh

# terminal

sudo pacman -S --noconfirm \
  alacritty

# common

sudo pacman -S --noconfirm \
  cpupower \
  fd \
  ffmpeg \
  freerdp \
  fzf \
  htop \
  imwheel \
  jq \
  p7zip \
  pass \
  ripgrep \
  rsync \
  stress \
  trash-cli \
  wget \
  xclip \
  xcolor \
  yt-dlp \
  zip

paru -S --aur --noconfirm \
  btop

# zsh, tmux and lf

sudo pacman -S --noconfirm \
  tmux \
  zsh zsh-completions

export GOPATH=${XDG_DATA_HOME:-~/.local/share}/go

paru -S --aur --noconfirm \
  lf

rm -rf ~/.bash*

# vim and neovim

sudo pacman -S --noconfirm \
  astyle ctags editorconfig-core-c gvim tidy \
  glibc neovim

xdg-mime default nvim.desktop text/plain

# docker

sudo pacman -S --noconfirm \
  docker \
  docker-buildx \
  docker-machine

sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl start docker.service

paru -S --aur --noconfirm \
  docker-credential-pass-bin

# aws

sudo pacman -S --noconfirm \
  aws-cli-v2

paru -S --aur --noconfirm \
  aws-sam-cli-bin

# dev

sudo pacman -S --noconfirm \
  dotnet-sdk aspnet-runtime \
  elixir \
  go \
  lua luacheck \
  nodejs npm \
  perl \
  python python-pip \
  ruby \
  rust

paru -S --aur --noconfirm \
  hadolint-bin \
  nvm \
  stylua-bin

NVM_DIR=${XDG_DATA_HOME:-~/.local/share}/nvm source /usr/share/nvm/init-nvm.sh

# apps

sudo pacman -S --noconfirm \
  flameshot \
  keepassxc \
  mpv celluloid \
  openconnect networkmanager-openconnect

paru -S --aur --noconfirm \
  brave-bin \
  postman-bin \
  visual-studio-code-bin

xdg-mime default brave-browser.desktop x-scheme-handler/mailto
xdg-mime default brave-browser.desktop text/calendar

# paru -S --aur --noconfirm \
  # gnome-browser-connector \
  # slack-desktop

gsettings set io.github.celluloid-player.Celluloid always-use-floating-controls true
gsettings set io.github.celluloid-player.Celluloid dark-theme-enable false
gsettings set io.github.celluloid-player.Celluloid mpv-config-enable true
gsettings set io.github.celluloid-player.Celluloid mpv-config-file 'file:///home/greg/.config/mpv/mpv.conf'

# xdg-mime default slack.desktop x-scheme-handler/slack

# clean package caches

sudo pacman --noconfirm -Sc
paru --aur -Sccd

# links

. `dirname $0`/links.zsh

# dotfiles install

. ~/code/dotfiles/install.zsh

# remove obsolete dirs and files

[[ -d ~/.gnome ]] && rm -rf ~/.gnome
[[ -f ~/.zshrc ]] && rm -f ~/.zshrc

