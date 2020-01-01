set -e -o verbose

# common

sudo pacman -S --noconfirm \
  flameshot \
  graphviz \
  jq \
  htop \
  man-db \
  man-pages \
  p7zip \
  ripgrep \
  tree \
  wget \
  wkhtmltopdf

yay -S --aur --noconfirm \
  drive-bin
