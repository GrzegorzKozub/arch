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

paru -S --aur --noconfirm \
  ttf-victor-mono

# themes

sudo pacman -S --noconfirm \
  papirus-icon-theme

# paru -S --aur --noconfirm \
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
  nushell \
  nvtop \
  pastel \
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
  worktree \
  xclip \
  xcolor \
  xh \
  zip \
  zsh zsh-completions \
  zoxide

  # libheif - for loupe & yazi to support heic images
  # xclip, wl-clipboard - for keepassxc, neovim & pass

  # tmux zellij

paru -S --aur --noconfirm \
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

paru -S --aur --noconfirm \
  yazi-nightly-bin

# neovim

# sudo pacman -S --noconfirm \
#   neovim

paru -S --aur --noconfirm \
  fswatch \
  neovim-nightly-bin \
  vivify-bin

# containers

"${BASH_SOURCE%/*}"/docker.sh
"${BASH_SOURCE%/*}"/podman.sh

# dev

sudo pacman -S --noconfirm \
  go \
  lua luacheck luarocks stylua \
  nodejs npm \
  perl \
  prettier \
  python python-pip python-pynvim python-requests uv \
  shfmt \
  taplo \
  tree-sitter-cli

  # python-requests for fetch.py
  # elixir ruby rust

paru -S --aur --noconfirm \
  golangci-lint-bin \
  fnm-bin \
  shellcheck-bin

# ai

[[ $HOST =~ ^(player|worker)$ ]] && "${BASH_SOURCE%/*}"/pkg/llama-cpp-vulkan.sh

# apps

sudo pacman -S --noconfirm \
  amberol \
  keepassxc \
  mission-center \
  mpv \
  obsidian \
  pavucontrol \
  satty \
  zed

paru -S --aur --noconfirm \
  brave-bin \
  tidal-hifi-bin \
  visual-studio-code-bin

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
