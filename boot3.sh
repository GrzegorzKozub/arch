set -e -o verbose

# dirs

if [ ! -d ~/AUR ]; then mkdir ~/AUR; fi

# preloader-signed

if [ -d ~/AUR/preloader-signed ]; then rm -rf ~/AUR/preloader-signed; fi

cd ~/AUR
git clone https://aur.archlinux.org/preloader-signed.git
cd preloader-signed

makepkg -si --noconfirm
git clean -fdx

cd ~

