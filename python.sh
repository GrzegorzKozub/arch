set -e -o verbose

# python

sudo pacman -S --noconfirm python python-pip

pip install --user \
  awscli \
  docker-compose \
  lastversion \
  pynvim

# pip install --user \
#   awsebcli

pip install --user --pre \
  vim-vint

