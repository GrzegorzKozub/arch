set -o verbose

sudo mount /dev/sda2 /mnt
if [[ ! $? == 0 ]]; then
  exit 1
fi

# git
sudo pacman -S --noconfirm git openssh
cp `dirname $0`/home/greg/.gitconfig ~
mkdir ~/.ssh
cp /mnt/id_rsa* ~/.ssh

# fonts
sudo pacman -S --noconfirm ttf-fira-mono ttf-freefont
cd ~/AUR
git clone https://aur.archlinux.org/otf-fira-code.git
cd otf-fira-code
makepkg -si --noconfirm
cd ../..

# zsh and oh my zsh
sudo pacman -S --noconfirm wget zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp `dirname $0`/home/greg/.zshrc ~
rm ~/.zshrc.pre-oh-my-zsh

# Chrome
cd ~/AUR
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -si --noconfirm
cd ../..

# KeePassXC
sudo pacman -S --noconfirm keepassxc

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

# .NET Core, Go, Perl, Python and Ruby
sudo pacman -S --noconfirm dotnet-sdk go perl python ruby

# Docker
sudo pacman -S --noconfirm docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Visual Studio Code
cd ~/AUR
git clone https://aur.archlinux.org/visual-studio-code-bin.git
cd visual-studio-code-bin
makepkg -si --noconfirm
cd ../..

# Vim
sudo pacman -S --noconfirm astyle ctags editorconfig-core-c fzf ripgrep tidy vim
git clone git@github.com:GrzegorzKozub/Vim.git ~/.vim

# Arch
mkdir ~/Code
git clone git@github.com:GrzegorzKozub/Arch.git ~/Code/Arch

