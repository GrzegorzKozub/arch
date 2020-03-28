set -e -o verbose

# node

sudo pacman -S --noconfirm nodejs npm

npm install --global \
  @angular/cli \
  create-react-app \
  eslint \
  express-generator \
  js-beautify \
  neovim \
  pm2 \
  rimraf \
  typescript \
  typescript-formatter

