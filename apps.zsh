#!/usr/bin/env zsh

set -e -o verbose

# validation

if [[ . == `dirname $0` ]]; then exit 1; fi

# pacman db sync

sudo pacman -Sy --noconfirm

# git and openssh

sudo pacman -S --noconfirm \
  git \
  openssh

yay -S --aur --noconfirm \
  git-extras

# dotfiles

. `dirname $0`/dotfiles.zsh

. ~/code/dotfiles/init.sh
. ~/code/keys/init.sh

# fonts

sudo pacman -S --noconfirm \
  gnu-free-fonts \
  noto-fonts \
  noto-fonts-emoji \
  otf-fira-code \
  ttf-dejavu \
  ttf-liberation

# yay -S --aur --noconfirm \
#   nerd-fonts-fira-code

# gnome

. `dirname $0`/gdm.sh
. `dirname $0`/gnome.sh
. `dirname $0`/terminal.sh

# terminal

sudo pacman -S --noconfirm \
  alacritty

# common

sudo pacman -S --noconfirm \
  fd \
  fzf \
  glances \
  graphviz \
  imwheel \
  jq \
  man-db man-pages \
  p7zip \
  ripgrep \
  stow \
  wget \
  wkhtmltopdf \
  xclip \
  xorg-xrandr

# zsh, tmux and ranger

sudo pacman -S --noconfirm \
  ranger \
  tmux \
  zsh zsh-completions

rm -rf ~/.bash*

# vim and neovim

sudo pacman -S --noconfirm \
  astyle ctags editorconfig-core-c gvim tidy \
  glibc neovim

yay -S --aur --noconfirm \
  hadolint-bin

# docker

sudo pacman -S --noconfirm \
  docker docker-machine

sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl start docker.service

# aws

sudo curl -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest
sudo chmod +x /usr/local/bin/ecs-cli

# dev

sudo pacman -S --noconfirm \
  dotnet-sdk \
  elixir \
  go \
  nodejs npm \
  perl \
  python python-pip \
  ruby

# apps

sudo pacman -S --noconfirm \
  flameshot \
  keepassxc qt5-styleplugins \
  mpv \
  openconnect networkmanager-openconnect \
  peek

yay -S --aur --noconfirm \
  google-chrome \
  postman \
  slack-desktop \
  visual-studio-code-bin

# plugins

. ~/code/dotfiles/plugins.sh

