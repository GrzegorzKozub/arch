# fonts
sudo pacman -S --noconfirm ttf-fira-mono ttf-freefont

# zsh
sudo pacman -S --noconfirm zsh

# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 
cp `dirname $0`/home/greg/.zshrc ~

# Chrome
cd ~/AUR
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome.git
makepkg -si --noconfirm

# Git
sudo pacman -S --noconfirm git
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

# Docker
sudo pacman -S --noconfirm docker
sudo systemctl enable docker.service
sudo systemctl start docker.service 

