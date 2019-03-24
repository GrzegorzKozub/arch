set -o verbose

mkdir ~/AUR
cd ~/AUR
rm -rf preloader-signed
git clone https://aur.archlinux.org/preloader-signed.git
cd preloader-signed
makepkg -si --noconfirm
cd ~

