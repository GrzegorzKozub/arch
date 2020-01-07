set -e -o verbose

# ranger

sudo pacman -S --noconfirm ranger

if [ ! -d ~/.config/ranger ]; then mkdir ~/.config/ranger; fi

cp `dirname $0`/home/greg/.config/ranger/rc.conf ~/.config/ranger

