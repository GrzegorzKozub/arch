set -e -o verbose

# common

sudo pacman -S --noconfirm \
  fzf \
  glances \
  graphviz \
  jq \
  man-db \
  man-pages \
  p7zip \
  ripgrep \
  stow \
  wget \
  wkhtmltopdf \
  xclip \
  xorg-xrandr

yay -S --aur --noconfirm \
  git-extras
