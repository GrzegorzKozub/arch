set -e -o verbose

# tmux

sudo pacman -S --noconfirm tmux

if [ ! -d ~/.config/systemd/user ]; then mkdir -p ~/.config/systemd/user; fi
cp `dirname $0`/home/greg/.config/systemd/user/tmux.service ~/.config/systemd/user
systemctl --user enable tmux
