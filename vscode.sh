set -e -o verbose

# vscode

yay -S --aur --noconfirm visual-studio-code-bin

for EXTENSION in \
  JakeBecker.elixir-ls \
  alexkrechik.cucumberautocomplete \
  aws-scripting-guy.cform \
  dbaeumer.vscode-eslint \
  editorconfig.editorconfig \
  equinusocio.vsc-material-theme \
  esbenp.prettier-vscode \
  `# humao.rest-client` \
  ms-azuretools.vscode-docker \
  `# ms-vscode-remote.remote-wsl` \
  `# ms-vscode.PowerShell` \
  `# ms-vscode.azure-account` \
  `# ms-vscode.csharp` \
  ms-vscode.go \
  ms-vscode.vscode-typescript-tslint-plugin \
  `# msjsdiag.debugger-for-chrome` \
  pkief.material-icon-theme
do
  code --install-extension $EXTENSION --force
done

