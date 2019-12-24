set -e -o verbose

# chromium

sudo pacman -S --noconfirm chromium

cd ~/AUR
git clone https://aur.archlinux.org/chromium-widevine.git
cd chromium-widevine

makepkg -si --noconfirm
git clean -fdx

cd ~
