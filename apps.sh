set -e -o verbose

timedatectl set-ntp true

systemctl enable gdm.service
systemctl enable NetworkManager.service

grpck

sudo mount /dev/sda2 /mnt
if [[ ! $? == 0 ]]; then
  exit 1
fi

# git
sudo pacman -S --noconfirm git openssh
cp `dirname $0`/home/greg/.gitconfig ~
mkdir ~/.ssh
cp /mnt/.greg/id_rsa* ~/.ssh
chmod 600 ~/.ssh/id_rsa

# fonts
sudo pacman -S --noconfirm ttf-fira-mono ttf-freefont noto-fonts-emoji
cd ~/AUR
git clone https://aur.archlinux.org/otf-fira-code.git
cd otf-fira-code
makepkg -si --noconfirm
git clean -fdx
cd ../..

# zsh and oh-my-zsh
sudo pacman -S --noconfirm wget zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp -r `dirname $0`/home/greg/.oh-my-zsh/custom/themes ~/.oh-my-zsh/custom
cp `dirname $0`/home/greg/.zshrc ~
rm ~/.zshrc.pre-oh-my-zsh

# Chrome
cd ~/AUR
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -si --noconfirm
git clean -fdx
cd ../..

# KeePass
sudo pacman -S --noconfirm keepass
cp `dirname $0`/home/greg/.config/KeePass ~/.config

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
git clean -fdx
cd ../..

# Vim
sudo pacman -S --noconfirm astyle ctags editorconfig-core-c fzf ripgrep tidy vim
git clone git@github.com:GrzegorzKozub/Vim.git ~/.vim

# Midnight Commander
sudo pacman -S --noconfirm mc

# Arch
rm -rf ~/Code
mkdir ~/Code
git clone git@github.com:GrzegorzKozub/Arch.git ~/Code/Arch

