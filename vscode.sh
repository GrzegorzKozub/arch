set -e -o verbose

# vscode

cd ~/AUR
git clone https://aur.archlinux.org/visual-studio-code-bin.git
cd visual-studio-code-bin

makepkg -si --noconfirm
git clean -fdx

for extension in \
  dbaeumer.vscode-eslint \
  editorconfig.editorconfig \
  EFanZh.graphviz-preview \
  esbenp.prettier-vscode \
  equinusocio.vsc-material-theme \
  humao.rest-client \
  JakeBecker.elixir-ls \
  ms-vscode.azure-account \
  ms-vscode.csharp \
  ms-vscode.go \
  ms-vscode.PowerShell \
  ms-vscode-remote.remote-wsl \
  ms-vscode.vscode-typescript-tslint-plugin \
  msjsdiag.debugger-for-chrome \
  ms-azuretools.vscode-docker \
  pkief.material-icon-theme \
  Stephanvs.dot
do
  code --install-extension $extension --force
done

if [ -d ~/.config/Code ]; then rm -rf ~/.config/Code; fi
git clone git@github.com:GrzegorzKozub/VisualStudioCode.git ~/.config/Code

cd ~

