set -e -o verbose

# AUR

if [ ! -d ~/AUR ]; then mkdir ~/AUR; fi

# dropbox

gpg --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E

cd ~/AUR
git clone https://aur.archlinux.org/dropbox.git
cd dropbox

makepkg -si --noconfirm
git clean -fdx

cd ~

# dropbox-cli

cd ~/AUR
git clone https://aur.archlinux.org/dropbox-cli.git
cd dropbox-cli

makepkg -si --noconfirm
git clean -fdx

cd ~

