set -e -o verbose

# python

sudo pacman -S --noconfirm python python-pip

pip install awscli aws-shell lastversion pynvim --user
pip install vim-vint --user --pre

