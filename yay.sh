set -e -o verbose

# yay

cd ~/AUR
git clone https://aur.archlinux.org/yay.git
cd yay

makepkg -si --noconfirm
git clean -fdx

cd ~

