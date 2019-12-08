set -e -o verbose

# git

sudo pacman -S --noconfirm git

cp `dirname $0`/home/greg/.gitconfig ~

