set -e -o verbose

# vim and neovim

sudo pacman -S --noconfirm astyle ctags editorconfig-core-c tidy gvim
sudo pacman -S --noconfirm glibc neovim
yay -S --aur --noconfirm hadolint-bin

