set -e -o verbose

# dropbox

gpg --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E

yay -S --aur --noconfirm dropbox dropbox-cli

if [ ! -d ~/.config/systemd/user ]; then mkdir -p ~/.config/systemd/user; fi
cp `dirname $0`/home/greg/.config/systemd/user/dropbox-fix.service ~/.config/systemd/user
systemctl --user enable dropbox-fix
