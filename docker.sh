set -e -o verbose

# docker

sudo pacman -S --noconfirm docker

sudo usermod -aG docker $USER

sudo systemctl enable docker.service
sudo systemctl start docker.service

