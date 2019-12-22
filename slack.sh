set -e -o verbose

# slack

cd ~/AUR
git clone https://aur.archlinux.org/slack-desktop.git
cd slack-desktop

makepkg -si --noconfirm
git clean -fdx

