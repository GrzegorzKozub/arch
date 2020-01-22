set -e -o verbose

# tmux

sudo pacman -S --noconfirm tmux

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cp `dirname $0`/home/greg/.tmux.conf ~

~/.tmux/plugins/tpm/bindings/install_plugins

