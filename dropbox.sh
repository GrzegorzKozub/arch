set -e -o verbose

# dropbox

gpg --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E

yay -S --aur --noconfirm dropbox dropbox-cli

