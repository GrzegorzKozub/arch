set -e -o verbose

# postman

cd ~/AUR
git clone https://aur.archlinux.org/postman.git
cd postman

makepkg -si --noconfirm
git clean -fdx

