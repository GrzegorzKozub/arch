set -e -o verbose

# yay

if [ -d ~/yay ]; then rm -rf ~/yay; fi
pushd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
popd
rm -rf ~/yay

# firmware and power saving

yay -S --aur --noconfirm \
  aic94xx-firmware wd719x-firmware \
  laptop-mode-tools

