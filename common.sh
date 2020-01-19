set -e -o verbose

# common

sudo pacman -S --noconfirm \
  flameshot \
  fzf \
  graphviz \
  jq \
  htop \
  man-db \
  man-pages \
  p7zip \
  peek \
  ripgrep \
  wget \
  wkhtmltopdf \
  xclip \
  xorg-xrandr

yay -S --aur --noconfirm \
  git-extras
