pushd

# zsh
sudo pacman -S --noconfirm zsh
cp `dirname $0`/home/greg/.zshrc ~

# Chrome
cd ~/AUR
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome.git
makepkg -si --noconfirm

# Git
sudo pacman -S --noconfirm git
cp `dirname $0`/home/greg/.gitconfig ~

popd

