set -e -o verbose

# python

sudo pacman -S --noconfirm python python-pip

pip install --user \
  awscli \
  awsebcli \
  aws-shell \
  docker-compose \
  lastversion \
  pynvim

pip install --user --pre \
  vim-vint

