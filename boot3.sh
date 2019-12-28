set -e -o verbose

# dirs

if [ ! -d ~/AUR ]; then mkdir ~/AUR; fi

# secure boot support

pushd ~/AUR

if [ -d preloader-signed ]; then rm -rf preloader-signed; fi
git clone https://aur.archlinux.org/preloader-signed.git
cd preloader-signed
makepkg -si --noconfirm
git clean -fdx
cd ..

popd

