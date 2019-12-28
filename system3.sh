set -e -o verbose

# dirs

if [ ! -d ~/AUR ]; then mkdir ~/AUR; fi

# firmware

pushd ~/AUR

if [ -d aic94xx-firmware ]; then rm -rf aic94xx-firmware; fi
git clone https://aur.archlinux.org/aic94xx-firmware.git
cd aic94xx-firmware
makepkg -si --noconfirm
git clean -fdx
cd ..

if [ -d wd719x-firmware ]; then rm -rf wd719x-firmware; fi
git clone https://aur.archlinux.org/wd719x-firmware.git
cd wd719x-firmware
makepkg -si --noconfirm
git clean -fdx
cd ..

popd

