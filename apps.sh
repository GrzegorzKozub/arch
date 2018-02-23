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

# Node.js and Yarn
sudo pacman -S --noconfirm nodejs ttf-freefont yarn
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

popd

