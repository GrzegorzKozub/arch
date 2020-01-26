set -e -o verbose

# erlang and elixir

sudo pacman -S --noconfirm elixir

mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new --force

