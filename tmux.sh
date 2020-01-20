set -e -o verbose

# tmux

sudo pacman -S --noconfirm tmux

cp `dirname $0`/home/greg/.tmux.conf ~

