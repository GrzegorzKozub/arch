set -e -o verbose

# vim and neovim

sudo pacman -S --noconfirm astyle ctags editorconfig-core-c tidy vim
sudo pacman -S --noconfirm glibc neovim

if [ -d ~/.vim ]; then rm -rf ~/.vim; fi
git clone git@github.com:GrzegorzKozub/Vim.git ~/.vim

vim -c "PlugInstall | exit"

ln -s ~/.vim  ~/.config/nvim

