# fonts
sudo pacman -S --noconfirm ttf-fira-mono ttf-freefont
cd ~/AUR
git clone https://aur.archlinux.org/otf-fira-code.git
cd otf-fira-code
makepkg -si --noconfirm

# zsh
sudo pacman -S --noconfirm zsh

# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 
cp `dirname $0`/home/greg/.zshrc ~
rm ~/.zshrc.pre-oh-my-zsh

# Chrome
cd ~/AUR
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -si --noconfirm

# Git
sudo pacman -S --noconfirm git openssh
cp `dirname $0`/home/greg/.gitconfig ~

# Node.js and Yarn
sudo pacman -S --noconfirm nodejs yarn
yarn global add \
  @angular/cli \
  babel-cli \
  create-react-app \
  eslint \
  express-generator \
  gulp-cli \
  js-beautify \
  karma-cli \
  pm2 \
  rimraf \
  tslint \
  typescript \
  typescript-formatter \
  yo

# .NET Core
sudo pacman -S --noconfirm dotnet-sdk

# Go
sudo pacman -S --noconfirm go

# Ruby
sudo pacman -S --noconfirm ruby

# Perl
sudo pacman -S --noconfirm perl

# Python
sudo pacman -S --noconfirm python

# Docker
sudo pacman -S --noconfirm docker
sudo systemctl enable docker.service
sudo systemctl start docker.service 

# Visual Studio Code
cd ~/AUR
git clone https://aur.archlinux.org/visual-studio-code-bin.git
cd visual-studio-code-bin
makepkg -si --noconfirm

# Vim
sudo pacman -S --noconfirm gvim
git clone git@github.com:GrzegorzKozub/Vim.git ~/.vim

