set -e -o verbose

# common

sudo pacman -S --noconfirm \
  drive \
  flameshot \
  graphviz \
  jq \
  htop \
  man-db \
  man-pages \
  p7zip \
  pdftk \
  ripgrep \
  tree \
  wget \
  wkhtmltopdf

yay -S --aur --noconfirm \
  pandoc-bin
