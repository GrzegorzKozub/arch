#!/usr/bin/env zsh

set -e -o verbose

# validation

[[ . = `dirname $0` ]] && exit 1

# pacman refresh

sudo pacman -Sy --noconfirm
sudo pacman-key --refresh-keys

# git and openssh

sudo pacman -S --noconfirm \
  git \
  openssh

yay -S --aur --noconfirm \
  git-extras \
  gitflow-avh \
  gitflow-zshcompletion-avh

# dotfiles

sudo pacman -S --noconfirm \
  stow

. `dirname $0`/dotfiles.zsh

. ~/code/dotfiles/init.zsh
. ~/code/history/init.zsh
. ~/code/keys/init.zsh

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

. `dirname $0`/gdm.zsh
. `dirname $0`/gnome.zsh
. `dirname $0`/terminal.zsh

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
  rsync \
  trash-cli \
  wget \
  wkhtmltopdf \
  xclip \
  xorg-xrandr

# zsh, tmux, lf and ranger

sudo pacman -S --noconfirm \
  ranger \
  tmux \
  zsh zsh-completions

yay -S --aur --noconfirm \
  lf-bin

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

sudo curl -o /usr/local/bin/ecs-cli \
  https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest
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
  chromium \
  flameshot \
  keepassxc qt5-styleplugins \
  mpv \
  openconnect networkmanager-openconnect \
  peek

yay -S --aur --noconfirm \
  postman \
  slack-desktop \
  visual-studio-code-bin

for APP in \
  flameshot \
  org.keepassxc.KeePassXC
do
  cp /usr/share/applications/$APP.desktop ~/.local/share/applications
  sed -i 's/^Exec=/Exec=\/home\/greg\/code\/arch\/qt.sh /' \
    ~/.local/share/applications/$APP.desktop
done

# plugins

. ~/code/dotfiles/plugins.zsh

