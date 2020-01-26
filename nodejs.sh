set -e -o verbose

# nodejs

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
  serverless \
  tslint \
  typescript \
  typescript-formatter

