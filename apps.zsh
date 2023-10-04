#!/usr/bin/env zsh

set -e -o verbose

# validation

[[ . = `dirname $0` ]] && exit 1

# env

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-~/.local/share}

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
  otf-cascadia-code \
  ttf-dejavu \
  ttf-fira-code \
  ttf-liberation \
  ttf-nerd-fonts-symbols

# themes

sudo pacman -S --needed --noconfirm \
  papirus-icon-theme

# terminal

sudo pacman -S --noconfirm \
  kitty

  # alacritty

if [[ $HOST = 'drifter' || $HOST = 'worker' ]]; then

  sudo pacman -S --noconfirm \
    foot

fi

# common

sudo pacman -S --noconfirm \
  bat \
  cpupower \
  fd \
  ffmpeg \
  freerdp \
  fzf \
  htop \
  hyperfine \
  jq \
  nvtop \
  p7zip \
  pass \
  ripgrep \
  rsync \
  stress \
  trash-cli \
  wget \
  wl-clipboard \
  xclip \
  xcolor \
  yt-dlp \
  zip

  # xclip, wl-clipboard - for keepassxc, neovim and pass
  # imwheel ncdu

paru -S --aur --noconfirm \
  btop \
  cava

if [[ $HOST = 'player' ]]; then

  sudo pacman -S --noconfirm \
    redshift

fi

# terminal

sudo pacman -S --noconfirm \
  zsh zsh-completions \
  tmux \
  zellij

export GOPATH=$XDG_DATA_HOME/go

paru -S --aur --noconfirm \
  lf

rm -rf ~/.bash*

# neovim

sudo pacman -S --noconfirm \
  neovim

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
  lua luacheck luarocks \
  perl \
  python python-pip \
  ruby \
  rust taplo \
  tree-sitter

  # nodejs npm

paru -S --aur --noconfirm \
  nvm \
  stylua-bin

NVM_DIR=$XDG_DATA_HOME/nvm source /usr/share/nvm/init-nvm.sh

# apps

sudo pacman -S --noconfirm \
  flameshot \
  keepassxc \
  mpv \
  openconnect networkmanager-openconnect

  # celluloid

paru -S --aur --noconfirm \
  brave-bin \
  postman-bin \
  visual-studio-code-bin

  # gnome-browser-connector slack-desktop

xdg-mime default brave-browser.desktop x-scheme-handler/mailto
xdg-mime default brave-browser.desktop text/calendar

# gsettings set io.github.celluloid-player.Celluloid always-use-floating-controls true
# gsettings set io.github.celluloid-player.Celluloid dark-theme-enable false
# gsettings set io.github.celluloid-player.Celluloid mpv-config-enable true
# gsettings set io.github.celluloid-player.Celluloid mpv-config-file 'file:///home/greg/.config/mpv/mpv.conf'

# xdg-mime default slack.desktop x-scheme-handler/slack

# clean package caches

sudo pacman --noconfirm -Sc
paru --aur -Sccd

# settings

. `dirname $0`/settings.zsh
. `dirname $0`/links.zsh
. `dirname $0`/gdm.zsh

[[ $XDG_CURRENT_DESKTOP = 'GNOME' ]] && . `dirname $0`/gnome.zsh
[[ $XDG_CURRENT_DESKTOP = 'KDE' ]] && . `dirname $0`/plasma.zsh

# clean

. `dirname $0`/clean.zsh

# dotfiles install

. ~/code/dotfiles/install.zsh

