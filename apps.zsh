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
  git-credential-gopass \
  openssh

paru -S --aur --noconfirm \
  git-extras

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

paru -S --aur --noconfirm \
  ttf-victor-mono

# themes

sudo pacman -S --needed --noconfirm \
  papirus-icon-theme

# terminal

sudo pacman -S --noconfirm \
  kitty

  # alacritty foot

# common

sudo pacman -S --noconfirm \
  bat \
  btop \
  cpupower \
  dust \
  eza \
  fd \
  ffmpeg \
  freerdp \
  fzf \
  git-delta \
  go-yq \
  gopass pass \
  htop \
  hyperfine \
  jq \
  mdcat \
  nushell \
  nvtop \
  ripgrep \
  rsync \
  silicon \
  stress \
  time \
  zellij \
  trash-cli \
  wget \
  wl-clipboard \
  xclip \
  xcolor \
  python-secretstorage yt-dlp \
  zip \
  zsh zsh-completions \
  zoxide

  # xclip, wl-clipboard - for keepassxc, neovim and pass

  # dua-cli gdu
  # gopass-jsonapi
  # imwheel
  # p7zip
  # tmux

paru -S --aur --noconfirm \
  7-zip-full \
  cava \
  tmux-git

# if [[ $HOST = 'player' ]]; then
#
#   sudo pacman -S --noconfirm \
#     redshift
#
# fi

if [[ $HOST = 'worker' ]]; then

  # btop amd gpu monitoring
  sudo pacman -S --noconfirm \
    rocm-smi-lib

end

# yazi

sudo pacman -S --noconfirm \
  imagemagick \
  poppler

paru -S --aur --noconfirm \
  yazi-nightly-bin

# neovim

# sudo pacman -S --noconfirm \
#   neovim

paru -S --aur --noconfirm \
  fswatch \
  neovim-nightly-bin \
  vivify-bin

# docker

sudo pacman -S --noconfirm \
  docker \
  docker-buildx \
  docker-compose

sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl start docker.service

paru -S --aur --noconfirm \
  docker-credential-pass-bin

# aws

# --nocheck skips tests
paru -S --aur --noconfirm --nocheck \
  aws-cli-v2

paru -S --aur --noconfirm \
  aws-sam-cli-bin

# dev

sudo pacman -S --noconfirm \
  dotnet-sdk aspnet-runtime \
  go \
  lua luacheck luarocks stylua \
  perl \
  python python-pip \
  taplo \
  tree-sitter

  # elixir
  # nodejs npm
  # ruby
  # rust

paru -S --aur --noconfirm \
  golangci-lint-bin \
  fnm-bin

  # nvm

# NVM_DIR=$XDG_DATA_HOME/nvm source /usr/share/nvm/init-nvm.sh

export CARGO_HOME=$XDG_DATA_HOME/cargo
export RUSTUP_HOME=$XDG_DATA_HOME/rustup

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

# apps

sudo pacman -S --noconfirm \
  keepassxc \
  mpv \
  obsidian \
  satty

  # flameshot

paru -S --aur --noconfirm \
  brave-bin gnome-browser-connector \
  postman-bin \
  teams-for-linux \
  visual-studio-code-bin

  # mission-center slack-desktop

# settings

. `dirname $0`/settings.zsh
. `dirname $0`/links.zsh
. `dirname $0`/gdm.zsh

[[ $XDG_CURRENT_DESKTOP = 'GNOME' ]] && . `dirname $0`/gnome.zsh
[[ $XDG_CURRENT_DESKTOP = 'KDE' ]] && . `dirname $0`/plasma.zsh

# cleanup

. `dirname $0`/packages.zsh
. `dirname $0`/clean.zsh

# dotfiles install

. ~/code/dotfiles/install.zsh

