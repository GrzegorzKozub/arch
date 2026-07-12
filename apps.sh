#!/usr/bin/env bash
set -eo pipefail -ux

# env

export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# pacman refresh

# sudo pacman --noconfirm -Sy archlinux-keyring
sudo pacman --noconfirm -Sy

# git & openssh

sudo pacman -S --noconfirm \
  git git-lfs \
  git-credential-gopass \
  openssh \
  github-cli

# dotfiles init

sudo pacman -S --noconfirm \
  stow

"${BASH_SOURCE%/*}"/dot.sh

~/code/dot/init.sh
~/code/keys/init.sh

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

yay --aur --noconfirm --answerdiff=None -S \
  ttf-victor-mono

# themes

sudo pacman -S --noconfirm \
  papirus-icon-theme

# yay --aur --noconfirm --answerdiff=None -S \
#   papirus-icon-theme-git

# common

sudo pacman -S --noconfirm \
  7zip \
  bat \
  btop \
  bubblewrap socat \
  cava \
  cpupower \
  direnv \
  docx2txt \
  duckdb \
  eza \
  fastfetch \
  fd \
  ffmpeg \
  fzf \
  git-delta \
  go-yq \
  gopass pass \
  hl \
  htop \
  hyperfine \
  jq \
  jwt-cli \
  libheif \
  nvtop \
  pastel \
  playerctl \
  rclone \
  restic \
  ripgrep ripgrep-all \
  rsync \
  silicon \
  stress \
  time \
  trash-cli \
  wget \
  wl-clipboard \
  xclip \
  xcolor \
  xh \
  zip \
  zsh zsh-completions \
  zoxide

  # libheif - for loupe & yazi to support heic images
  # xclip, wl-clipboard - for keepassxc, neovim & pass

  # tmux zellij

yay --aur --noconfirm --answerdiff=None -S \
  tmux-git

if [[ $HOST == 'drifter' ]]; then

  sudo pacman -S --noconfirm \
    brightnessctl

fi

if [[ $HOST == 'sacrifice' ]]; then

  # btop amd gpu monitoring
  sudo pacman -S --noconfirm \
    rocm-smi-lib

fi

# yazi

sudo pacman -S --noconfirm \
  imagemagick \
  poppler \
  resvg

  # poppler - pdf

yay --aur --noconfirm --answerdiff=None -S \
  yazi-nightly-bin

# neovim

# aur not needed on cachy
sudo pacman -S --noconfirm \
  neovim-nightly-bin

yay --aur --noconfirm --answerdiff=None -S \
  fswatch \
  vivify-bin

# containers

"${BASH_SOURCE%/*}"/docker.sh
"${BASH_SOURCE%/*}"/podman.sh

# dev

sudo pacman -S --noconfirm \
  go \
  lua luacheck luarocks stylua \
  mise usage \
  nodejs npm \
  perl \
  prettier \
  python python-pip python-pynvim python-requests uv \
  shfmt \
  taplo \
  tree-sitter-cli

  # python-requests for fetch.py
  # elixir ruby rust

yay --aur --noconfirm --answerdiff=None -S \
  golangci-lint-bin \
  shellcheck-bin

# ai

[[ $HOST =~ ^(player|worker)$ ]] && "${BASH_SOURCE%/*}"/pkg/llama-cpp-vulkan-bin.sh

# apps

sudo pacman -S --noconfirm \
  amberol \
  keepassxc \
  mission-center \
  mpv \
  obsidian \
  pavucontrol \
  satty \
  openbsd-netcat zed

# aur not needed on cachy
sudo pacman -S --noconfirm \
  brave-origin-bin

yay --aur --noconfirm --answerdiff=None -S \
  tidal-hifi-bin \
  visual-studio-code-bin

  # or brave-bin

# settings

"${BASH_SOURCE%/*}"/settings.sh
"${BASH_SOURCE%/*}"/links.sh

"${BASH_SOURCE%/*}"/gdm.sh

[[ $XDG_CURRENT_DESKTOP == 'GNOME' ]] && "${BASH_SOURCE%/*}"/gnome.sh

"${BASH_SOURCE%/*}"/mime.sh
"${BASH_SOURCE%/*}"/secrets.sh

# cleanup

"${BASH_SOURCE%/*}"/packages.sh
"${BASH_SOURCE%/*}"/clean.sh

# dotfiles install

~/code/dot/install.sh
