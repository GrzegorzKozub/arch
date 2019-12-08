set -e -o verbose

# chrome

cd ~/AUR
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome

makepkg -si --noconfirm
git clean -fdx

cd ~

