#!/usr/bin/env zsh

set -o verbose

[[ $1 = 'nvim' ]] && {
  rm -rf $XDG_CACHE_HOME/nvim
  rm -rf $XDG_DATA_HOME/nvim
  rm -rf ~/.local/state/nvim
  nvim \
    -c 'lua vim.opt.messagesopt = "wait:100,history:500"' \
    -c 'autocmd User MasonToolsUpdateCompleted quitall' \
    -c 'autocmd User VeryLazy MasonToolsUpdate'
}

[[ $1 = 'rust' ]] && {
  rm -rf $XDG_DATA_HOME/cargo
  rm -rf $XDG_DATA_HOME/rustup
  curl --proto '=https' --tlsv1.3 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
  cargo install cargo-update
}

