set -e -o verbose

# internet

sudo wifi-menu
sleep 10
#elinks google.com

# mount

if [[ ! $(sudo mount | grep "sda1 on /mnt") ]]; then sudo mount /dev/sda1 /mnt; fi

# pacman db sync

pacman -Syu --noconfirm

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

# keepass

sudo pacman -S --noconfirm keepass

cp -r `dirname $0`/home/greg/.config/KeePass ~/.config

# nodejs and yarn

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

# dotnet, perl and ruby

sudo pacman -S --noconfirm dotnet-sdk perl ruby

# python

sudo pacman -S --noconfirm python
pip install httpie pynvim --user

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

gometalinter --install

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
  peterjausovec.vscode-docker \
  pkief.material-icon-theme
do
  code --install-extension $extension --force
done

if [ -d ~/.config/Code ]; then rm -rf ~/.config/Code; fi
git clone git@github.com:GrzegorzKozub/VisualStudioCode.git ~/.config/Code

cd ~

# vim

sudo pacman -S --noconfirm astyle ctags editorconfig-core-c fzf ripgrep tidy vim

if [ -d ~/.vim ]; then rm -rf ~/.vim; fi
git clone git@github.com:GrzegorzKozub/Vim.git ~/.vim

vim -c "PlugInstall | exit"

# mc

sudo pacman -S --noconfirm mc

# scripts

if [ ! -d ~/Code ]; then mkdir ~/Code; fi
if [ -d ~/Code/Arch ]; then rm -rf ~/Code/Arch; fi
git clone git@github.com:GrzegorzKozub/Arch.git ~/Code/Arch

# unmount

sudo umount -R /mnt

