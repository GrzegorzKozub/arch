set -e -o verbose

# internet

sudo wifi-menu
sleep 10
#elinks google.com

# mount

if [[ ! $(sudo mount | grep "sda1 on /mnt") ]]; then sudo mount /dev/sda1 /mnt; fi

# pacman db sync

sudo pacman -Syu --noconfirm

# AUR

if [ ! -d ~/AUR ]; then mkdir ~/AUR; fi

# git and openssh

sudo pacman -S --noconfirm git openssh

cp `dirname $0`/home/greg/.gitconfig ~
mkdir ~/.ssh
cp /mnt/.Arch/.ssh/config ~/.ssh
cp -r /mnt/.Arch/.ssh/github.com ~/.ssh
chmod 600 ~/.ssh/id_rsa

# fonts

sudo pacman -S --noconfirm gnu-free-fonts noto-fonts-emoji ttf-fira-mono

cd ~/AUR
git clone https://aur.archlinux.org/otf-fira-code.git
cd otf-fira-code

makepkg -si --noconfirm
git clean -fdx

cd ~

# zsh and oh-my-zsh

sudo pacman -S --noconfirm wget zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

cp -r `dirname $0`/home/greg/.oh-my-zsh/custom/themes ~/.oh-my-zsh/custom
cp `dirname $0`/home/greg/.zshrc ~

rm ~/.zshrc.pre-oh-my-zsh

# chrome

cd ~/AUR
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome

makepkg -si --noconfirm
git clean -fdx

cd ~

# keepassxc

sudo pacman -S --noconfirm keepassxc

cp -r `dirname $0`/home/greg/.config/keepassxc ~/.config

# nodejs and yarn

sudo pacman -S --noconfirm nodejs npm yarn

yarn global add \
  @angular/cli \
  babel-cli \
  create-react-app \
  eslint \
  express-generator \
  gulp-cli \
  js-beautify \
  karma-cli \
  neovim \
  pm2 \
  rimraf \
  tslint \
  typescript \
  typescript-formatter \
  yo

# dotnet

sudo pacman -S --noconfirm dotnet-sdk

# perl

sudo pacman -S --noconfirm perl

# python

sudo pacman -S --noconfirm python python-pip

pip install httpie pynvim --user
pip install vim-vint --user --pre

# ruby

sudo pacman -S --noconfirm ruby
gem install neovim --user-install

# go

sudo pacman -S --noconfirm go

for package in \
  `# shared by vscode-go and vim-go` \
  github.com/alecthomas/gometalinter \
  github.com/davidrjenni/reftools/cmd/fillstruct \
  github.com/fatih/gomodifytags \
  github.com/josharian/impl \
  github.com/mdempsky/gocode \
  github.com/rogpeppe/godef \
  github.com/zmb3/gogetdoc \
  golang.org/x/lint/golint \
  golang.org/x/tools/cmd/goimports \
  golang.org/x/tools/cmd/gorename \
  golang.org/x/tools/cmd/guru \
  `# just for https://github.com/Microsoft/vscode-go` \
  github.com/acroca/go-symbols \
  github.com/cweill/gotests/... \
  github.com/haya14busa/goplay/cmd/goplay \
  github.com/ramya-rao-a/go-outline \
  github.com/uudashr/gopkgs/cmd/gopkgs \
  golang.org/x/tools/cmd/godoc \
  sourcegraph.com/sqs/goreturns \
  `# just for https://github.com/fatih/vim-go` \
  github.com/fatih/motion \
  github.com/go-delve/delve/cmd/dlv \
  github.com/golangci/golangci-lint/cmd/golangci-lint \
  github.com/jstemmer/gotags \
  github.com/kisielk/errcheck \
  github.com/klauspost/asmfmt/cmd/asmfmt \
  github.com/koron/iferr \
  github.com/stamblerre/gocode \
  golang.org/x/tools/cmd/gopls \
  honnef.co/go/tools/cmd/keyify
do
  echo $package
  go get -u $package
done

~/go/bin/gometalinter --install

# erlang and elixir

sudo pacman -S --noconfirm elixir

mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new --force

cp `dirname $0`/home/greg/.iex.exs ~

# docker

sudo pacman -S --noconfirm docker

sudo systemctl enable docker.service
sudo systemctl start docker.service

# vscode

cd ~/AUR
git clone https://aur.archlinux.org/visual-studio-code-bin.git
cd visual-studio-code-bin

makepkg -si --noconfirm
git clean -fdx

for extension in \
  dbaeumer.vscode-eslint \
  editorconfig.editorconfig \
  esbenp.prettier-vscode \
  equinusocio.vsc-material-theme \
  JakeBecker.elixir-ls \
  ms-vscode.azure-account \
  ms-vscode.csharp \
  ms-vscode.go \
  ms-vscode.PowerShell \
  ms-vscode.vscode-typescript-tslint-plugin \
  msjsdiag.debugger-for-chrome \
  ms-azuretools.vscode-docker \
  pkief.material-icon-theme
do
  code --install-extension $extension --force
done

if [ -d ~/.config/Code ]; then rm -rf ~/.config/Code; fi
git clone git@github.com:GrzegorzKozub/VisualStudioCode.git ~/.config/Code

cd ~

# vim and neovim

sudo pacman -S --noconfirm astyle ctags editorconfig-core-c fzf ripgrep tidy vim
sudo pacman -S --noconfirm glibc neovim

if [ -d ~/.vim ]; then rm -rf ~/.vim; fi
git clone git@github.com:GrzegorzKozub/Vim.git ~/.vim

vim -c "PlugInstall | exit"

ln -s ~/.vim  ~/.config/nvim

# mc

sudo pacman -S --noconfirm mc

# scripts

if [ ! -d ~/Code ]; then mkdir ~/Code; fi
if [ -d ~/Code/Arch ]; then rm -rf ~/Code/Arch; fi
git clone git@github.com:GrzegorzKozub/Arch.git ~/Code/Arch

# unmount

sudo umount -R /mnt

