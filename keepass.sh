set -e -o verbose

# keepassxc

sudo pacman -S --noconfirm \
  keepassxc qt5-styleplugins

if [ ! -d ~/.config/environment.d ]; then mkdir -p ~/.config/environment.d; fi
cp `dirname $0`/home/greg/.config/environment.d/environment.conf ~/.config/environment.d/
