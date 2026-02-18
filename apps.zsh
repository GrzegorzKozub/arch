#!/usr/bin/env zsh

set -e -o verbose

# validation

[[ . = `dirname $0` ]] && exit 1

# env

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

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

`dirname $0`/dot.zsh

~/code/dot/init.zsh
~/code/keys/init.zsh

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

# sudo pacman -S --needed --noconfirm \
#   papirus-icon-theme

paru -S --aur --needed --noconfirm \
  papirus-icon-theme-git

# common

sudo pacman -S --noconfirm \
  7zip \
  bat \
  btop \
  cava \
  cpupower \
  direnv \
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

if [[ $HOST = 'drifter' ]]; then

  sudo pacman -S --noconfirm \
    brightnessctl

fi

if [[ $HOST = 'sacrifice' ]]; then

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

`dirname $0`/docker.sh
`dirname $0`/podman.sh

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

[[ $HOST =~ ^(player|worker)$ ]] && `dirname $0`/pkg/llama-cpp-vulkan.sh

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

`dirname $0`/settings.zsh
`dirname $0`/links.zsh

`dirname $0`/gdm.zsh

[[ $XDG_CURRENT_DESKTOP == 'GNOME' ]] && `dirname $0`/gnome.zsh

`dirname $0`/mime.zsh
`dirname $0`/secrets.sh

# cleanup

`dirname $0`/packages.sh
`dirname $0`/clean.sh

# dotfiles install

~/code/dot/install.zsh

