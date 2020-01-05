set -e -o verbose

# vim and neovim

sudo pacman -S --noconfirm astyle ctags editorconfig-core-c tidy gvim
sudo pacman -S --noconfirm glibc neovim
yay -S --aur --noconfirm hadolint-bin

if [ -d ~/.vim ]; then rm -rf ~/.vim; fi
git clone git@github.com:GrzegorzKozub/vim.git ~/.vim

vim -c 'PlugInstall | exit'

ln -s ~/.vim  ~/.config/nvim

