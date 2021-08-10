#!/usr/bin/env zsh

set -e -o verbose

# validation

[[ . = `dirname $0` ]] && exit 1

# pacman refresh

sudo pacman -Sy --noconfirm
# sudo pacman-key --refresh-keys

# git and openssh

sudo pacman -S --noconfirm \
  git \
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

# gnome

. `dirname $0`/gdm.zsh
. `dirname $0`/gnome.zsh
# . `dirname $0`/terminal.zsh

# terminal

sudo pacman -S --noconfirm \
  alacritty

# common

sudo pacman -S --noconfirm \
  fd \
  freerdp \
  fzf \
  graphviz \
  htop \
  imwheel \
  jq \
  man-db man-pages \
  p7zip \
  pass \
  ripgrep \
  rsync \
  trash-cli \
  wget \
  wkhtmltopdf \
  xclip \
  xdotool \
  xorg-xrandr \
  youtube-dl ffmpeg \
  zip

paru -S --aur --noconfirm \
  wrk2-git

if [[ $HOST = 'ampere' || $HOST = 'turing' ]]; then

  sudo pacman -S --noconfirm \
    nvtop

fi

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

paru -S --aur --noconfirm \
  hadolint-bin

xdg-mime default nvim.desktop text/plain

# docker

sudo pacman -S --noconfirm \
  docker docker-machine

sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl start docker.service

paru -S --aur --noconfirm \
  docker-credential-pass-bin

# aws

paru -S --aur --noconfirm \
  aws-cli-v2-bin

# dev

sudo pacman -S --noconfirm \
  dotnet-sdk \
  elixir \
  go \
  nodejs npm \
  perl \
  python python-pip \
  ruby \
  rust

# apps

sudo pacman -S --noconfirm \
  flameshot \
  keepassxc \
  mpv celluloid \
  openconnect networkmanager-openconnect \
  peek gifski gst-plugins-good gst-plugins-ugly

paru -S --aur --noconfirm \
  google-chrome \
  postman-bin \
  slack-desktop \
  visual-studio-code-bin

gsettings set io.github.celluloid-player.Celluloid always-use-floating-controls true
gsettings set io.github.celluloid-player.Celluloid dark-theme-enable false
gsettings set io.github.celluloid-player.Celluloid mpv-config-enable true
gsettings set io.github.celluloid-player.Celluloid mpv-config-file '/home/greg/.config/mpv/mpv.conf'
gsettings set io.github.celluloid-player.Celluloid mpv-options '--hwdec=auto'

xdg-mime default slack.desktop x-scheme-handler/slack

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

