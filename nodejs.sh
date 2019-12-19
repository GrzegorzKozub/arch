set -e -o verbose

# nodejs

cp `dirname $0`/home/greg/.angular-config.json ~
cp `dirname $0`/home/greg/.npmrc ~

sudo pacman -S --noconfirm nodejs npm

npm install --global \
  @angular/cli \
  create-react-app \
  eslint \
  express-generator \
  js-beautify \
  neovim \
  pm2 \
  rdme \
  rimraf \
  serverless \
  tslint \
  typescript \
  typescript-formatter

