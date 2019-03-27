set -o verbose

cd ~

if [ ! -d AUR ]; then mkdir AUR; fi
cd AUR

if [ -d preloader-signed ]; then rm -rf preloader-signed; fi
git clone https://aur.archlinux.org/preloader-signed.git
cd preloader-signed

makepkg -si --noconfirm

cd ~

